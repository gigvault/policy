FROM golang:1.23-bullseye AS builder
WORKDIR /src

# Copy shared library first
COPY shared/ ./shared/

# Copy service files
COPY policy/go.mod policy/go.sum ./policy/
WORKDIR /src/policy
RUN go mod download

WORKDIR /src
COPY policy/ ./policy/
WORKDIR /src/policy
RUN CGO_ENABLED=0 GOOS=linux go build -o /out/policy ./cmd/policy

FROM alpine:3.18
RUN apk add --no-cache ca-certificates
COPY --from=builder /out/policy /usr/local/bin/policy
COPY policy/config/ /config/
EXPOSE 8080 9090
ENTRYPOINT ["/usr/local/bin/policy"]
