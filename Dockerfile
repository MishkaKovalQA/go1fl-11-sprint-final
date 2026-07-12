FROM golang:1.22 AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /out/app .

FROM debian:bookworm-slim

WORKDIR /app

COPY --from=builder /out/app /app/app
COPY tracker.db /app/tracker.db

ENTRYPOINT ["/app/app"]
