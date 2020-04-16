create or replace package pkg_auth_source as

-- CONSTANTS
/**
 * @constant gc_auth_source_code_facebook
 * @constant gc_auth_source_code_google
 */
 gc_auth_source_code_facebook constant auth_source.auth_source_code%type := 'FACEBOOK';
 gc_auth_source_code_google constant auth_source.auth_source_code%type := 'GOOGLE';

end pkg_auth_source;
/
