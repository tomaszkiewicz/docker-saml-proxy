# SAML Proxy

## Overview

This repo and Docker image provides a proxy server, configured with SAML authentication.

To start, run like this:
```
docker run -p 80:80 -h auth.example.com -e BACKEND=https://api.example.com:8443 -ti barnabassudy/saml-proxy
```

Invocation details:
* 80 is the http proxy port

Environment variables:
* BACKEND - to requests are proxied to
* PROXY_HOST - the hostname the proxy is available

  
## Example Use

1. Copy your IDP's metadata XML to /etc/httpd/conf.d/saml_idp.xml and restart httpd (`httpd -k restart`)

2. An example IDP can be created at https://auth0.com/. After creating an account, edit the default app's *Addons > SAML2 Web App* settings as follows:

    *Settings > Application Callback URL*: https://auth.example.com/mellon/postResponse

    *Settings > Settings*: 
    ```
    {
        "audience":  "https://auth.example.com",
        ...
    }
    ```

    *Usage > Identity Provider Metadata*: Copy to /etc/httpd/conf.d/saml_idp.xml in your proxy image and restart httpd (`httpd -k restart`) 
    
 ## Use with Kubernetes
 
 TODO
