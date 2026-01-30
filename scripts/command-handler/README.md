# Command Handler Module

A simple command handler module for Lua-based game servers. This module provides a clean way to register commands with optional role-based permissions.

> **Dependency**: [Player-Wrapper](../player-wrapper/player-wrapper.lua) module is required.

---

## Command Registration

Commands are registered using two parameters:

```lua
Command.register(options, callback)
```

---

## Parameters

### 1. Options

```lua
{
  name: string,
  description: string,
  permissions?: roleID[],
  permission?: roleID
}
```

**Fields**

- `name` (required)
  Command name without prefix.

- `description` (required)
  Short description of the command.

- `permission` (optional)
  Single role ID allowed to use the command.

- `permissions` (optional)
  List of role IDs allowed to use the command.

Use only one of `permission` or `permissions`.

---

### 2. Callback

```lua
function(world: World, player: Player, data)
```

The callback receives:

```lua
{
  command: string,
  args: any[],
  message: string
}
```

- `command` : command name
- `args` : parsed arguments
- `message` : raw command message

---

## Example

```lua
local Command = require("command-handler")

Command.register({
  name = "ping",
  description = "Check server response",
  permission = 1
}, function(world, player, data)
  player:onTalkBubble(player:getNetID(), "Pong!", 0)
  return true
end)
```

---

## Permission Rules

- No permission field means the command is public
- `permission` checks a single role
- `permissions` checks multiple roles

---

## Notes

- Designed to be minimal and easy to understand
- No assertions, safer for runtime execution
- Suitable for GTPS or other Lua-based servers

---

## Author

@Nperma
