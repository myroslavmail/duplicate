FROM alpine

LABEL maintainer="Myroslav Mail<myroslavmail@ukr.net>"

RUN apk update
RUN apk -Uuv add groff less python py-pip
RUN pip install awscli
RUN apk --purge -v del py-pip
RUN rm /var/cache/apk/*
RUN aws configure set aws_access_key_id AKIAYA4DMQLPZIDALJCW
RUN aws configure set aws_secret_access_key 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
RUN aws configure set backup.region us-east-1
