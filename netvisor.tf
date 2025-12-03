resource "synology_container_project" "netvisor" {
  name = "netvisor"
  run  = true

  # Custom network for inter-service communication
  networks = {
    netvisor = {
      driver = "bridge"
      ipam = {
        config = [
          {
            subnet  = "172.31.0.0/16"
            gateway = "172.31.0.1"
          }
        ]
      }
    }
  }

  # Named volumes for persistent data
  volumes = {
    postgres_data = {}
    daemon-config = {}
    server-data   = {}
  }

  services = {
    # Netvisor Daemon - runs in host network mode for network discovery
    daemon = {
      image          = "mayanayza/netvisor-daemon:latest"
      container_name = "netvisor-daemon"
      restart        = "unless-stopped"
      network_mode   = "host"
      privileged     = true

      ports = [
        {
          target    = 60073
          published = "60073"
          protocol  = "tcp"
        }
      ]

      environment = {
        NETVISOR_LOG_LEVEL          = "info"
        NETVISOR_SERVER_PORT        = "60072"
        NETVISOR_DAEMON_PORT        = "60073"
        NETVISOR_SERVER_URL         = "http://127.0.0.1:60072"
        NETVISOR_PORT               = "60073"
        NETVISOR_BIND_ADDRESS       = "0.0.0.0"
        NETVISOR_NAME               = "netvisor-daemon"
        NETVISOR_HEARTBEAT_INTERVAL = "30"
        NETVISOR_MODE               = "Push"
      }

      healthcheck = {
        test     = ["CMD-SHELL", "curl -f http://localhost:60073/api/health || exit 1"]
        interval = "5s"
        timeout  = "3s"
        retries  = 15
      }

      volumes = [
        {
          type   = "volume"
          source = "daemon-config"
          target = "/root/.config/daemon"
        },
        {
          # Docker socket for container discovery
          type   = "bind"
          source = "/var/run/docker.sock"
          target = "/var/run/docker.sock"
          read_only = true
        }
      ]
    }

    # PostgreSQL database for netvisor server
    postgres = {
      image          = "postgres:17-alpine"
      container_name = "netvisor-postgres"
      restart        = "unless-stopped"

      environment = {
        POSTGRES_DB       = "netvisor"
        POSTGRES_USER     = "postgres"
        POSTGRES_PASSWORD = "password"  # Change this to a secure password
      }

      healthcheck = {
        test     = ["CMD-SHELL", "pg_isready -U postgres"]
        interval = "10s"
        timeout  = "5s"
        retries  = 5
      }

      networks = {
        netvisor = {}
      }

      volumes = [
        {
          type   = "volume"
          source = "postgres_data"
          target = "/var/lib/postgresql/data"
        }
      ]
    }

    # Netvisor Server - main web application
    server = {
      image          = "mayanayza/netvisor-server:latest"
      container_name = "netvisor-server"
      restart        = "unless-stopped"

      ports = [
        {
          target    = 60072
          published = "60072"
          protocol  = "tcp"
        }
      ]

      environment = {
        NETVISOR_LOG_LEVEL           = "info"
        NETVISOR_SERVER_PORT         = "60072"
        NETVISOR_DAEMON_PORT         = "60073"
        NETVISOR_DATABASE_URL        = "postgresql://postgres:password@postgres:5432/netvisor"
        NETVISOR_WEB_EXTERNAL_PATH   = "/app/static"
        NETVISOR_PUBLIC_URL          = "http://localhost:60072"
        NETVISOR_INTEGRATED_DAEMON_URL = "http://172.17.0.1:60073"
      }

      depends_on = {
        postgres = {
          condition = "service_healthy"
        }
        daemon = {
          condition = "service_healthy"
        }
      }

      networks = {
        netvisor = {}
      }

      volumes = [
        {
          type   = "volume"
          source = "server-data"
          target = "/data"
        }
      ]
    }
  }
}
