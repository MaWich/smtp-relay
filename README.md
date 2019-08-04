# smtp-relay-host  

## What?
This is a SMTP relay host for transactional based emails from within a k8 cluster.

## Why ?
Many public cloud providers do not allow the sending of e-mails to the normal SMTP port 25.  
The waiting time between public cloud providers and outside SMTP Services can be too long for applications that send emails. In this time suspend the applications for users.  
If you use mail services such as SendGrid, MailGun, or Mailjet, you do not have a protocol for debugging the mailtransport.  
So we need a simple Docker image that can be configured with env vars. In addition, the functionality can be easily overridden by providing an alternative init script.
 
## Overview
This repository contains Kubernetes config files and a docker image to easily set up a SMTP relay for services.

## Quickstart

### Build local Container

Run in `smtp-relay` Directory
```shell
./bin/image.sh build
```


### Run Container 

Run on docker
```shell
docker run --rm -it -p 2525:25 \
	-e SMTP_RELAY_HOST="[smtp.sendgrid.net]:587" \
	-e SMTP_RELAY_USERNAME=username \
	-e SMTP_RELAY_PASSWORD=password \
	mawich/smtp-relay

```
