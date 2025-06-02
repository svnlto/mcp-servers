# MCP Servers Collection

This project runs multiple MCP servers using Supergateway to expose each server over SSE (Server-Sent Events). Each server runs in its own container on a dedicated port.

## Quick Start

```bash
# Copy environment file
cp .env.example .env

# Edit your API tokens
vim .env

# Start all services
docker-compose up -d
```

## Architecture

- Multiple containers, each running a specific MCP server via Supergateway
- Each server exposed on a unique port (9001-9006)
- Servers can be connected to individually or all at once
- Persistent data stored in mounted volumes

## Available Commands

### Basic Operations
```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# Restart all services
docker-compose restart

# Check status
docker-compose ps

# View logs from all services
docker-compose logs -f

# View logs from specific service
docker-compose logs -f mcp-filesystem
docker-compose logs -f mcp-github
```

### Individual Service Management
```bash
# Restart specific service
docker-compose restart mcp-filesystem
docker-compose restart mcp-github

# Shell into specific container
docker-compose exec mcp-filesystem sh
docker-compose exec mcp-github sh

# View logs from last 50 lines
docker-compose logs --tail=50
```

### Cleanup
```bash
# Stop and remove containers
docker-compose down

# Stop and remove containers + volumes
docker-compose down -v

# Pull latest images
docker-compose pull
```

## MCP Servers & Ports

| Service | Port | Description | Environment Variables |
|---------|------|-------------|----------------------|
| **mcp-github** | 9001 | GitHub repository access | `GITHUB_TOKEN`, `GITHUB_OWNER` |
| **mcp-linear** | 9002 | Linear issue tracking | `LINEAR_API_KEY`, `GITHUB_TOKEN` |
| **mcp-notion** | 9003 | Notion workspace access | `NOTION_TOKEN` |
| **mcp-filesystem** | 9004 | File system operations | - |
| **mcp-memory** | 9005 | Persistent memory | - |
| **mcp-sequential-thinking** | 9006 | Step-by-step reasoning | - |
| **mcp-context7** | 9007 | Up-to-date documentation | `DEFAULT_MINIMUM_TOKENS` |
| **mcp-prisma** | 9009 | Prisma database management | - |

## Configuration

### Environment Variables

1. Copy the example: `make setup` (or `cp .env.example .env`)
2. Edit `.env` with your actual API tokens:
   - `GITHUB_OWNER` - Your GitHub username
   - `GITHUB_TOKEN` - GitHub Personal Access Token
   - `NOTION_TOKEN` - Notion API token
   - `LINEAR_API_KEY` - Linear API key

### Connecting to MCP Servers

Each server is available via SSE at:
- **SSE Endpoint**: `http://localhost:900X/sse`
- **POST Messages**: `http://localhost:900X/message`

#### Claude Desktop Configuration

Connect to individual servers:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "supergateway", "--sse", "http://localhost:9001/sse"]
    },
    "linear": {
      "command": "npx", 
      "args": ["-y", "supergateway", "--sse", "http://localhost:9002/sse"]
    },
    "notion": {
      "command": "npx",
      "args": ["-y", "supergateway", "--sse", "http://localhost:9003/sse"] 
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "supergateway", "--sse", "http://localhost:9004/sse"]
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "supergateway", "--sse", "http://localhost:9005/sse"]
    },
    "sequential-thinking": {
      "command": "npx", 
      "args": ["-y", "supergateway", "--sse", "http://localhost:9006/sse"]
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "supergateway", "--sse", "http://localhost:9007/sse"]
    },
    "prisma": {
      "command": "npx",
      "args": ["-y", "supergateway", "--sse", "http://localhost:9009/sse"]
    }
  }
}
```

#### Zed Editor Configuration

```json
{
  "context_servers": {
    "github": {
      "command": {
        "path": "npx",
        "args": ["-y", "supergateway", "--sse", "http://localhost:9001/sse"]
      }
    },
    "filesystem": {
      "command": {
        "path": "npx",
        "args": ["-y", "supergateway", "--sse", "http://localhost:9004/sse"]
      }
    }
  }
}
```

## Service Details

### GitHub MCP Server (Port 9001)
- Repository operations (clone, create, update)
- Issue and PR management
- File operations within repositories
- Requires: `GITHUB_TOKEN`, `GITHUB_OWNER`

### Linear MCP Server (Port 9002)  
- Issue creation and management
- Project and team operations
- Integration with GitHub repositories
- Requires: `LINEAR_API_KEY`, `GITHUB_TOKEN`

### Notion MCP Server (Port 9003)
- Database queries and updates
- Page creation and modification
- Block-level operations
- Requires: `NOTION_TOKEN`

### Filesystem MCP Server (Port 9004)
- File and directory operations
- Mounted to `/workspace` (maps to `/home/vagrant/projects`)
- Read, write, create, delete operations

### Memory MCP Server (Port 9005)
- Persistent memory across sessions
- Data stored in `/home/vagrant/.shared-memory`
- Key-value storage for context retention

### Sequential Thinking MCP Server (Port 9006)
- Step-by-step reasoning and planning
- Multi-step problem solving
- No external dependencies

### Context7 MCP Server (Port 9007)
- Fetches up-to-date, version-specific documentation
- Pulls code examples straight from the source
- Helps avoid outdated training data and hallucinated APIs
- Usage: Add "use context7" to your prompts
- Environment: `DEFAULT_MINIMUM_TOKENS` (default: 10000)

### Prisma MCP Server (Port 9009)
- Prisma database management and schema operations
- Database instance management for Postgres
- Schema migrations and database operations
- Early access features for Prisma Platform
- No API key required (uses Prisma CLI authentication)

## Troubleshooting

**Check container status:**
```bash
docker-compose ps
```

**View logs from all services:**
```bash
docker-compose logs -f
```

**View logs from specific service:**
```bash
docker-compose logs -f mcp-github    # GitHub server logs
docker-compose logs -f mcp-filesystem # Filesystem server logs
# etc.
```

**Test individual server connectivity:**
```bash
curl http://localhost:9001/sse  # Should return SSE stream
curl http://localhost:9004/sse  # Filesystem server
```

**Full restart:**
```bash
docker-compose down
docker-compose up -d
```

**Shell into specific container:**
```bash
docker-compose exec mcp-github sh
docker-compose exec mcp-filesystem sh
```

## Development

**Add a new MCP server:**

1. Add service to `docker-compose.yml`
2. Choose next available port (9007+)
3. Add environment variables to `.env.example` if needed
4. Update this README with server details

**Monitor all services:**
```bash
docker-compose up -d && docker-compose logs -f
```
