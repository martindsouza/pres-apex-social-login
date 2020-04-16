create or replace package pkg_apex
as

  procedure p_apex_post_auth_facebook;

  procedure p_apex_post_auth_google;

  procedure p_apex_post_auth_debug;
  
end pkg_apex;
/