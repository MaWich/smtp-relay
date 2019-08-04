FROM ${FROM_IMAGE}
LABEL org.label-schema.name="mawich/smtp-relay" \
      org.label-schema.version="0.1.0" \
      org.label-schema.description="SMTP Mail Relay Service" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.vcs-url="https://github.com/mawich/smtp-relay" \
      author1="Maik Wichmann <maik.wichmann@de.clara.net>"

RUN apk add --no-cache postfix rsyslog supervisor \
    && /usr/bin/newaliases

COPY docker/ /

EXPOSE 25

ENTRYPOINT [ "/smtp-relay.sh" ]

