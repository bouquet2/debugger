## debugger

A comprehensive Kubernetes debugging container based on Fedora, designed for troubleshooting clusters, networking, and applications.

## Images

| Image | Description |
|-------|-------------|
| `ghcr.io/bouquet2/debugger:latest` | Base image with all debugging tools |
| `ghcr.io/bouquet2/debugger-tmux:latest` | Same as base + tmux with auto-attach on start |

## Included Tools

### Kubernetes
- **kubectl** - Kubernetes CLI
- **helm** - Package manager
- **stern** - Multi-pod log tailing
- **krew** - kubectl plugin manager

### Container Tools
- **skopeo** - Inspect container images and registries

### Networking
- **curl**, **wget** - HTTP clients
- **dig**, **nslookup**, **host** - DNS utilities
- **ip**, **ifconfig**, **netstat** - Network configuration
- **nc**, **socat** - Network utilities
- **tcpdump** - Packet analysis
- **iperf3** - Network performance testing

### Data Processing
- **jq** - JSON processor
- **yq** - YAML processor
- **vim**, **nano** - Text editors

### Databases
- **psql** - PostgreSQL client
- **mysql** - MySQL client
- **redis-cli** - Redis client
- **mongosh** - MongoDB shell
- **rabbitmqctl** - RabbitMQ management

### Load Testing
- **siege** - HTTP load testing

### Debugging Utilities
- **strace** - System call tracer
- **lsof** - Open files listing
- **htop** - Process viewer
- **grpcurl** - gRPC debugging

### Other
- **git**, **git-lfs** - Version control
- **sops** - Secrets encryption/decryption

## Usage

### Base Image
```bash
kubectl run debugger --rm -it --image ghcr.io/bouquet2/debugger:latest
```

### Tmux Image
```bash
kubectl run debugger --rm -it --image ghcr.io/bouquet2/debugger-tmux:latest
```

The tmux variant auto-starts a tmux session on container launch. Use `Ctrl+B` then `D` to detach.

### Run as a Deployment (for persistent debugging)
```bash
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: debugger
spec:
  replicas: 1
  selector:
    matchLabels:
      app: debugger
  template:
    metadata:
      labels:
        app: debugger
    spec:
      containers:
      - name: debugger
        image: ghcr.io/bouquet2/debugger:latest
        command: ["sleep", "infinity"]
EOF
```

## License

This project is in the public domain. See [LICENSE](LICENSE) file for details.