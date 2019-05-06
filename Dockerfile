FROM alpine

LABEL maintainer="Myroslav Mail<myroslavmail@ukr.net>"

RUN apk update \
&& apk -Uuv add groff less python py-pip \
&& pip install awscli \
&& apk add jq \
&& apk --purge -v del py-pip \
&& apk add coreutils \
&& rm /var/cache/apk/*
