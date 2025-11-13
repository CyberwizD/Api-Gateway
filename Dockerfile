# --------------------------
# Builder Stage
# --------------------------
FROM golang:1.22 AS builder

# Set working directory
WORKDIR /app

# Copy go mod files first (for caching)
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the source code
COPY . .

# Build the Go binary
# Output the binary to: /app/bin/server
RUN CGO_ENABLED=0 GOOS=linux go build -o /app/bin/server ./cmd/server

# --------------------------
# Final Stage
# --------------------------
FROM alpine:latest

# Set working directory in final image
WORKDIR /root/

# Copy the compiled binary from builder
COPY --from=builder /app/bin/server /root/server

# Expose port
EXPOSE 8080

# Command to run the server
CMD ["/root/server"]
