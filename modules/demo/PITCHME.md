---?color=black

[drop=center]
# Demo

---

[drop=top]
## Demo

[drop=center]
@ul[list-fade-bullets]
- Facebook Configuration
- APEX Configuration
- Store user info
@ul

---

[drop=top]
## `users` Table


[drop=center]
| `AUTH_ID` | `AUTH_SOURCE` | `EMAIL` | `NAME` | `PIC_URL` |
| --- | --- | --- | --- | --- |
| `123` | `FACEBOOK` | `jon@gmail.com` | `Jon` | `http://...` |


--- 

[drop=top]
## Code


[drop=center]
```sql code-line-numbers
p_apex_post_auth(
  p_auth_source_code => 'FACEBOOK',
  p_auth_id => apex_json.get_varchar2(p_path=>'id'),
  p_email => apex_json.get_varchar2(p_path=>'email'),
  p_full_name => apex_json.get_varchar2(p_path=>'name'),
  p_picture_url => apex_string.format('//graph.facebook.com/%0/picture', apex_json.get_varchar2(p_path=>'id'))
);
```


