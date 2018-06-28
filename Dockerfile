FROM fedora:28
MAINTAINER matt@parr.geek.nz

RUN dnf install -y \
  apr-util-openssl \
  authconfig \
  httpd \
  mod_auth_mellon \
  mod_intercept_form_submit \
  mod_session \
  mod_ssl \
  gettext \
  wget \
  && dnf clean all

# Add mod_auth_mellon setup script
ADD mellon_create_metadata.sh /usr/sbin/mellon_create_metadata.sh

# Add conf file for Apache
ADD proxy.conf /tmp/proxy.conf.template

EXPOSE 80

ADD configure /usr/sbin/configure
ENTRYPOINT /usr/sbin/configure
