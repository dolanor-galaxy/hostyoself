###################################
# 1. Build in a Go-based image   #
###################################
FROM golang:1.12-alpine as builder
RUN apk add --no-cache git ca-certificates # add deps here (like make) if needed
WORKDIR /go/hostyoself
COPY . .
# any pre-requisities to building should be added here
RUN go generate -v
RUN go build -v

###################################
# 2. Copy into a clean image     #
###################################
FROM alpine:latest
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /go/hostyoself/hostyoself /hostyoself
VOLUME /data
CMD ["sh","-c","/hostyoself host --folder /data"] 

