FROM alpine

LABEL maintainer="Myroslav Mail<myroslavmail@ukr.net>"

RUN apk update
RUN apk -Uuv add groff less python py-pip
RUN pip install awscli
RUN apk --purge -v del py-pip
RUN rm /var/cache/apk/*

ARG AWS_DEFAULT_REGION=us-east-1
ARG AWS_DEFAULT_PROFILE=backup
ARG AWS_ACCESS_KEY_ID=AKIAYA4DMQLPZIDALJCW
ARG AWS_SECRET_ACCESS_KEY=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
