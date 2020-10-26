## Setup Facebook

Create a Facebook App & "Register" for FB Login

- Go to [developers.facebook.com](https://developers.facebook.com/)
  - My Apps > Create App

- Create and Register App
  - Settings > Basic
    - *Copy and save these for later*
    - AppID: Client ID
    - App Secret: Client Secret
    - App Domains: Put domain name (not URL) of the domains that can access your app
      - Ex: apex.oracle.com and apexatho.me
      - `https://cwbhuqhizxythyu-atp01.adb.ca-toronto-1.oraclecloudapps.com`


- Register "Product (Facebook Login)" for your app
  - This is what will give you login access
  - Products > Facebook Login
    - WWW
    - Site URL: 
      - https://apexatho.me/pls/apex/f?p=apexathome
      - `https://cwbhuqhizxythyu-atp01.adb.ca-toronto-1.oraclecloudapps.com/ords/f?p=102`
      - 
    - Settings
      - `<DOMAIN>/ords/apex_authentication.callback`
      - `https://cwbhuqhizxythyu-atp01.adb.ca-toronto-1.oraclecloudapps.com/ords/apex_authentication.callback`


      - `https://apexatho.me/pls/apex/apex_authentication.callback`
      - `https://apex.oracle.com/pls/apex/apex_authentication.callback`


## Setup Google

- Go to https://console.developers.google.com/
- New Project (name)
  - Select Project from drop down
- Credentials > Configure Consent Screen
  - Domains: `apexatho.me`, `apex.oracle.com/`
- `+ Create Credentials`
  - OAuth Client ID
    - Application Type: `Web Application`
    - Name: `APEX Login`
    - Authorised redirect URIs: 
      - https://apexatho.me/pls/apex/apex_authentication.callback
      - https://apex.oracle.com/pls/apex/apex_authentication.callback




## APEX Setup

### Setup FB Developer Credentials

*Note: you'll need to do this in each environment you deploy to, it is not exported*

- App Builder > Workspace Utilities > All Workspace Utilities
  - Web Credentials > Create
    - Name: Facebook
    - Secret: `********`
      - TODO: Store in Enpass so no one sees live

### Create Authentication Scheme


- Shared Components > Authentication Schemes > Create
  - Based on a pre-configured scheme from the gallery
  - Name: Facebook
  - Scheme Type: Social Signin
    - Credential Store: Facebook (this comes from what we previously created in Workspace Utilities)
    - Authentication Provider: Facebook
    - Scope: `public_profile,email`
      - Permissions you're asking from the end users for their Facebook account
      - Can get a list of possible values from: https://developers.facebook.com/docs/facebook-login/permissions
      - Remember this is the permissions you're asking for (not the data you're asking to receive)
    - Username Attribute: `name`
    - Additional User Attributes: `email`
      - Data you're asking the Facebook API to send back to your APEX application
  - Create



https://developers.facebook.com/docs/facebook-login/permissions




- Edit Facebook Authentication
  -  Switch in Session: Enabled 
     -  This allows us to have multiple Authentication schemes (More on this later)


#### Google Changes

- Scope: `profile,email`
  - List of Scopes: https://developers.google.com/identity/protocols/oauth2/scopes#google_sign-in
- Username: `name`
- Additional User Attributes: `email`


### Create Login Link

- Edit P9999 (Login Page)
- Add Button
  - Button Name: `LOGIN_FACEBOOK`
  - Label: `Facebook`
  - Position: `Next`
  - Behavior
    - Action: Redirect to URL
    - Target: `f?p=&APP_ID.:1:&APP_SESSION.:APEX_AUTHENTICATION=Facebook`
      - Note can do this manually but the key thing is that the `Request` = `APEX_AUTHENTICATION=Facebook`

*Optional: Disable other login button/process*

- Test it out
  - At this point you're `APP_USER` will be your Facebook full name (*as defined by the Username Attribute in the Authentication Setting*)




## Store the Data

We just have the username but want additional information

### What's happening?

- Facebook sending back a JSON payload
- The JSON object is temporarily stored "in" the `apex_json` package
  - Only available during post-authorization
- Up to you to extract

### Demo

- Create `G_USER_ID`

Post Auth: `pkg_apex.p_apex_post_auth_facebook`
  - Highlight what we're doing
 

Show in Report (need to do in Safari)


<img src="//graph.facebook.com/#AUTH_ID#/picture">