FROM alpine

LABEL maintainer="Myroslav Mail<myroslavmail@ukr.net>"

RUN apk update\
&& apk -Uuv add groff less python py-pip \
&& pip install awscli \
&& apk add jq \
&& apk --purge -v del py-pip \
&& rm /var/cache/apk/*
RUN aws configure set profile.backup.aws_access_key_id AKIAYA4DMQLPZIDALJCW \
&& aws configure set profile.backup.aws_secret_access_key 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 \
&& aws configure set profile.backup.region us-east-1
