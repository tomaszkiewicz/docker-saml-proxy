# SAML Proxy

## Overview

This repo and Docker image provides a proxy server, configured with SAML authentication.

To start, run like this:
```
docker run -ti -p 80:80 -h auth.example.com -v -e BACKEND=https://api.example.com:8443 -e SCHEMA=http barnabassudy/saml-proxy
```

Ports:
* 80 for http proxying

Environment variables:
* `BACKEND` - to requests are proxied to (_mandatory_)
* `PROXY_HOST` - the hostname the proxy is available - falls back to the host name of the container.
* `SCHEMA` - the schema via the proxy is available (defaults to `https`) - _Note:_ This is not the protocol how the proxy accepts. SSL termination is not a responsibility of this image.
* `REMOTE_USER_EMAIL_SAML_ATTRIBUTE` - the SAML attribute to be sent as `Remote-User-Name header`
* `REMOTE_USER_NAME_SAML_ATTRIBUTE` - the SAML attribute to be sent as `Remote-User-Email`
* `REMOTE_USER_PREFERRED_USERNAME_SAML_ATTRIBUTE` - the SAML attribute to be sent as `Remote-User-Preferred-Username`

Volumes:
* `/etc/httpd/conf.d/saml_idp.xml` - SAML IPD metadata (_mandatory_)
* `/etc/httpd/conf.d/saml_sp.key` - SAML SP key (generated if not provided)
* `/etc/httpd/conf.d/saml_sp.cert` - SAML SP certificate (generated if not provided)
* `/etc/httpd/conf.d/saml_sp.xml` - SAML SP metadata (generated if not provided)

# Example Use

## Getting SAML metadata
### Auth0

An example IDP can be created at https://auth0.com/. After creating an account, edit the default app's *Addons > SAML2 Web App* settings as follows:

    * Settings > Application Callback URL*: https://auth.example.com/mellon/postResponse

    * Settings > Settings*:
    ```
    {
        "audience":  "https://auth.example.com",
        ...
    }
    ```

    * Usage > Identity Provider Metadata*: Download the metadata xml and make it available as volume.

## Bitium

TODO

## Configuration

### Docker

```
docker run \
  -p 80:80 \
  -h auth.example.com \
  -v <path>/saml_idp.xml:/etc/httpd/conf.d/saml_idp.xml \
  -e BACKEND=https://api.example.com:8443 \
  -e SCHEMA=http  \
  -ti
  barnabassudy/saml-proxy
```

* `-p 80:80` - port is mapped to localhost:80
* `-h auth.example.com` is equivalent with `-e PROXY_HOST=auth.example.com` - waits for requests for this host and will redirect to this host
* `-v <path>/saml_idp.xml:/etc/httpd/conf.d/saml_idp.xml` - provides the SAML metadata as volume
* `-e BACKEND=https://api.example.com:8443` - the url the requests should be proxied to
* `-e SCHEMA=http`
* `-ti` - make it interactive (eg. being able to stop it with Ctrl+C)
* `barnabassudy/saml-proxy` - the name of the Docker image

### Docker Compose

```
version: "2"
services:
  yourservice:
      ...
  saml-proxy:
      image: "barnabassudy/saml-proxy"
      environment:
          BACKEND: "http://yourservice:port"
      ports:
          - "80:80"
      volumes:
          - "<path>/saml_idp.xml:/etc/httpd/conf.d/saml_idp.xml"
```

### Kubernetes

TODO
