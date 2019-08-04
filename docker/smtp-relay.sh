#!/bin/sh

SMTP_RELAY_HOST=${SMTP_RELAY_HOST?Please set env var SMTP_RELAY_HOST}
# SMTP_RELAY_MYHOSTNAME=${SMTP_RELAY_MYHOSTNAME?Please set env var SMTP_RELAY_MYHOSTNAME}
SMTP_RELAY_USERNAME=${SMTP_RELAY_USERNAME?Please set env var SMTP_RELAY_USERNAME}
SMTP_RELAY_PASSWORD=${SMTP_RELAY_PASSWORD?Please set env var SMTP_RELAY_PASSWORD}


# handle sasl
echo "${SMTP_RELAY_HOST} ${SMTP_RELAY_USERNAME}:${SMTP_RELAY_PASSWORD}" > /etc/postfix/sasl_passwd || exit 1
postmap /etc/postfix/sasl_passwd || exit 1
rm /etc/postfix/sasl_passwd || exit 1

postconf 'smtp_sasl_auth_enable = yes' || exit 1
postconf 'smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd' || exit 1
postconf 'smtp_sasl_security_options =' || exit 1

# These are required.
postconf "relayhost = ${SMTP_RELAY_HOST}" || exit 1
# postconf "myhostname = ${SMTP_RELAY_MYHOSTNAME}" || exit 1

# Override what you want here. The 10. network is for kubernetes
postconf 'mynetworks = 127.0.0.0/8,10.0.0.0/8,172.16.0.0/16,192.168.0.0/16' || exit 1

# http://www.postfix.org/COMPATIBILITY_README.html#smtputf8_enable
postconf 'smtputf8_enable = no' || exit 1

# This makes sure the message id is set. If this is set to no dkim=fail will happen.
postconf 'always_add_missing_headers = yes' || exit 1

/usr/bin/supervisord -n
