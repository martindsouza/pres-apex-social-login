---?color=black

@snap[midpoint span-100]
# Demo
@snapend

---

@snap[north span-100]
## Demo
@snapend


@snap[midpoint span-100]

@ul[](false)
- Facebook Configuration
- APEX Configuration
- Store user info
@ulend

@snapend

---

@snap[north span-100]
## Users Table
@snapend


@snap[midpoint span-100 text-08]

| `AUTH_ID` | `AUTH_SOURCE` | `EMAIL` | `NAME` | `PIC_URL` |
| --- | --- | --- | --- | --- |
| `123` | `FACEBOOK` | `jon@gmail.com` | `Jon` | `http://...` |


@snapend

--- 
@snap[north span-100]
## Code
@snapend


@snap[midpoint span-100 text-08 ]
```sql zoom-00 code-line-numbers 
p_apex_post_auth(
  p_auth_source_code => 'FACEBOOK',
  p_auth_id => apex_json.get_varchar2(p_path=>'id'),
  p_email => apex_json.get_varchar2(p_path=>'email'),
  p_full_name => apex_json.get_varchar2(p_path=>'name'),
  p_picture_url => apex_string.format('//graph.facebook.com/%0/picture', apex_json.get_varchar2(p_path=>'id'))
);

```
@snapend


