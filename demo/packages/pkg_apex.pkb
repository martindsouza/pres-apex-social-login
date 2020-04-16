create or replace package body pkg_apex
as

  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';

  /*!
   * Creates or updates user. This is internal from the public calls
   *
   * @issue: 1
   *
   * @author mdsouza
   * @created 22-Mar-2020
   * @param p_auth_source_code
   * @param p_auth_id
   * @param p_email
   * @param p_full_name
   */
  procedure p_apex_post_auth(
    p_auth_source_code in auth_source.auth_source_code%type,
    p_auth_id  in users.auth_id%type,
    p_email in users.email%type,
    p_full_name in users.full_name%type,
    p_picture_url in users.picture_url%type
  )
  as
    l_scope logger_logs.scope%type := gc_scope_prefix || 'p_apex_post_auth';
    l_params logger.tab_param;

    l_auth_source_id auth_source.auth_source_id%type;
    l_user_id users.user_id%type;

  begin
    logger.append_param(l_params, 'p_auth_source_code', p_auth_source_code);
    logger.append_param(l_params, 'p_auth_id', p_auth_id);
    logger.append_param(l_params, 'p_email', p_email);
    logger.append_param(l_params, 'p_full_name', p_full_name);
    logger.append_param(l_params, 'p_picture_url', p_picture_url);
    logger.log('START', l_scope, null, l_params);

    select u.user_id
    into l_user_id
    from dual
      left join v_users u on 1=1
        and u.auth_source_code = p_auth_source_code
        and u.auth_id = p_auth_id
    ;
    logger.log('l_user_id: ' || l_user_id, l_scope);

    if l_user_id is null then
      logger.log('Inserting', l_scope);

      insert into users(
        auth_source_id,
        auth_id,
        email,
        full_name,
        picture_url
      )
      values(
        (select a.auth_source_id from auth_source a where a.auth_source_code = p_auth_source_code),
        p_auth_id,
        p_email,
        p_full_name,
        p_picture_url
      )
      returning user_id
      into l_user_id
      ;
      logger.log('l_user_id: ' || l_user_id, l_scope);
    else
      logger.log('Updating', l_scope);
      
      update users u
      set
        u.email = p_email,
        u.full_name = p_full_name,
        u.picture_url = p_picture_url
      where 1=1
        and u.user_id = l_user_id;
    end if;

    apex_util.set_session_state(
      p_name => 'G_USER_ID',
      p_value => l_user_id,
      p_commit => false
    );

    logger.log('END', l_scope);
  exception
    when others then
      logger.log_error('Unhandled Exception', l_scope, null, l_params);
      raise;
  end p_apex_post_auth;


  /**
   * Post Auth debug (useful for logging OAuth info )
   *
   * @issue 
   *
   * @author mdsouza
   * @created 22-Mar-2020
   */
  procedure p_apex_post_auth_debug
  as
    l_scope logger_logs.scope%type := gc_scope_prefix || 'p_apex_post_auth_debug';
    
    l_key varchar2(32767);
    l_value apex_json.t_value;
  begin
    logger.log('apex_json.g_values: ' || apex_json.g_values.count, l_scope);

    l_key := apex_json.g_values.first;
    
    loop 
      exit when l_key is null;
      logger.log('l_key: ' || l_key, l_scope);
      l_value := apex_json.g_values(l_key);

      logger.log('kind: ' || l_value.kind, l_scope);
      if l_value.kind = apex_json.c_varchar2 then
        logger.log('val: ' || l_value.varchar2_value, l_scope);
      elsif l_value.kind = apex_json.c_object then
        for i in 1..l_value.object_members.count loop
          logger.log(l_value.object_members(i), l_scope);
        end loop;
      end if;

      l_key := apex_json.g_values.next(l_key);
    end loop;

  --  for key IN INDICES apex_json.g_values loop
  --    logger.log('Looping', l_scope);
  ----    logger.log('i: ' || i, l_scope);
  ----    logger.log('kind: ' || apex_json.g_values(i).kind);
  --
  --  end loop;
  exception
    when others then
      logger.log_error('Unhandled Exception', l_scope);
      raise;
    
  end p_apex_post_auth_debug;



  /**
   * Post Auth for Facebook
   *
   * @issue 1
   *
   * @author mdsouza
   * @created 22-Mar-2020
   */
  procedure p_apex_post_auth_facebook
  as
    l_scope logger_logs.scope%type := gc_scope_prefix || 'p_apex_post_auth_facebook';
    l_params logger.tab_param;

  begin
    logger.log('START', l_scope, null, l_params);

    p_apex_post_auth(
      p_auth_source_code => pkg_auth_source.gc_auth_source_code_facebook,
      p_auth_id => apex_json.get_varchar2(p_path=>'id'),
      p_email => apex_json.get_varchar2(p_path=>'email'),
      p_full_name => apex_json.get_varchar2(p_path=>'name'),
      p_picture_url => apex_string.format('//graph.facebook.com/%0/picture', apex_json.get_varchar2(p_path=>'id'))
    );

    logger.log('END', l_scope);
  exception
    when others then
      logger.log_error('Unhandled Exception', l_scope, null, l_params);
      raise;
  end p_apex_post_auth_facebook;


  /**
   * Post Auth for Google
   *
   * @issue 1
   *
   * @author mdsouza
   * @created 22-Mar-2020
   */
  procedure p_apex_post_auth_google
  as
    l_scope logger_logs.scope%type := gc_scope_prefix || 'p_apex_post_auth_google';
    l_params logger.tab_param;

  begin
    logger.log('START', l_scope, null, l_params);

    p_apex_post_auth(
      p_auth_source_code => pkg_auth_source.gc_auth_source_code_google,
      p_auth_id => apex_json.get_varchar2(p_path=>'sub'),
      p_email => apex_json.get_varchar2(p_path=>'email'),
      p_full_name => apex_json.get_varchar2(p_path=>'name'),
      p_picture_url => apex_json.get_varchar2(p_path=>'picture  ')
    );

    logger.log('END', l_scope);
  exception
    when others then
      logger.log_error('Unhandled Exception', l_scope, null, l_params);
      raise;
  end p_apex_post_auth_google;

end pkg_apex;
/