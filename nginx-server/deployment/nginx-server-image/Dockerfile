FROM dockerhub.azk8s.cn/library/nginx:1.15.3-alpine
ADD ./default.conf /etc/nginx/conf.d/default.conf
ADD ./gitclone.sh /mnt/gitclone.sh
ADD ./genfiles.sh /mnt/genfiles.sh

RUN apk add git
