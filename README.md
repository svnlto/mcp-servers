# MCP Servers with Multiverse

This project sets up all MCP servers using `mcp-server-multiverse` for multiplexing multiple clients.

## Quick Start

```bash
# Install and start everything
make install

# Edit your API tokens
vim .env

# Restart with your tokens
make restart
```

## Architecture

- Single container running `mcp-server-multiverse`
- Manages all MCP servers as child processes
- Both Claude Desktop and Zed can connect simultaneously
- Persistent data stored in `./data/` and `./workspace/`

## Available Commands

Run `make help` to see all available commands:

- `make install` - Full setup (copy .env, start services)
- `make start` - Start the containers
- `make stop` - Stop everything
- `make restart` - Restart services
- `make logs` - Follow live logs
- `make status` - Check container status
- `make clean` - Full cleanup

## Configuration

### Environment Variables

1. Copy the example: `make setup` (or `cp .env.example .env`)
2. Edit `.env` with your actual API tokens:
   - `GITHUB_OWNER` - Your GitHub username
   - `NOTION_TOKEN` - Notion API token
   - `LINEAR_API_KEY` - Linear API key

### Editor Configuration

Update your editor configs using the examples in `./configs/`:

**Claude Desktop** (on host machine via vagrant):

```json
{
  "mcpServers": {
    "multiverse": {
      "command": "bash",
      "args": [
        "-c",
        "cd ~/.config/nix && vagrant ssh -- 'cd /home/vagrant/mcp-servers && docker-compose exec -T multiverse npx mcp-server-multiverse config.json'"
      ]
    }
  }
}
```

**Zed Editor** (inside VM via remote SSH):

```json
{
  "mcpServers": {
    "multiverse": {
      "command": "docker",
      "args": [
        "compose",
        "-f",
        "/home/vagrant/mcp-servers/docker-compose.yml",
        "exec",
        "-T",
        "multiverse",
        "npx",
        "mcp-server-multiverse",
        "config.json"
      ]
    }
  }
}
```

### MCP Servers

Edit `multiverse-config.json` to add/remove MCP servers. Current servers:

- Memory - Persistent memory across sessions
- GitHub - Repository access and operations
- Sequentialthinking - Step-by-step reasoning
- Context7 - Context management
- Filesystem - File operations in workspace
- Notion - Notion database and page access
- Linear - Issue tracking and project management

## Troubleshooting

**Check container status:**

```bash
make status
```

**View logs:**

```bash
make logs
```

**Full restart:**

```bash
make clean
make start
```

**Shell into container:**

```bash
make shell
```
