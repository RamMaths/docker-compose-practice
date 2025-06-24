#!/bin/bash
# variables
HOST_DATA_DIR=/home/ram/data
HOST_SECURITY_DIR=/home/ram/security
DOCKER_CERT_DIR=/etc/docker/certs.d/ram:443

# Create directories
mkdir -p $HOST_DATA_DIR
mkdir -p $HOST_SECURITY_DIR
sudo mkdir -p $DOCKER_CERT_DIR

# openssl key generation
cd $HOST_SECURITY_DIR
openssl req -newkey rsa:4096 -nodes -sha256 -keyout registry.key -x509 -days 365 -out registry.crt -subj "/CN=ram/C=MX/ST=MA/L=Monterrey/O=Inoware/OU=Training" -addext "subjectAltName = DNS:ram"
sudo cp $HOST_SECURITY_DIR/registry.crt $DOCKER_CERT_DIR
cd -

# Create htpasswd file
docker run --rm --entrypoint htpasswd httpd -Bbn admin password > $HOST_SECURITY_DIR/htpasswd

# CRITICAL FIX: Set proper permissions and ownership
# The registry container runs as user 1000:1000 (not root)
sudo chown -R 1000:1000 $HOST_SECURITY_DIR
sudo chown -R 1000:1000 $HOST_DATA_DIR

# Ensure files are readable by the container user
chmod 644 $HOST_SECURITY_DIR/registry.key
chmod 644 $HOST_SECURITY_DIR/registry.crt
chmod 644 $HOST_SECURITY_DIR/htpasswd

# Make directories accessible
chmod 755 $HOST_SECURITY_DIR
chmod 755 $HOST_DATA_DIR

# Stop and remove existing container if it exists
docker stop private_registry 2>/dev/null || true
docker rm private_registry 2>/dev/null || true

# Run the registry with proper configuration
docker run -d -p 443:443 --restart=always --name private_registry \
  -v $HOST_DATA_DIR:/var/lib/registry \
  -v $HOST_SECURITY_DIR:/auth \
  -v $HOST_SECURITY_DIR:/certs \
  -e REGISTRY_AUTH=htpasswd \
  -e REGISTRY_AUTH_HTPASSWD_REALM="My security practice" \
  -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
  -e REGISTRY_HTTP_ADDR=0.0.0.0:443 \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/registry.crt \
  -e REGISTRY_HTTP_TLS_KEY=/certs/registry.key \
  registry:2

# Verify the container is running
echo "Waiting for container to start..."
sleep 5
docker logs private_registry --tail 10
