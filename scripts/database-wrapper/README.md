# Database Wrapper (SQL & JSON)

A lightweight database wrapper for Lua (GTPS Cloud / GrowSoft environment).
Provides a unified **key–value interface** for both **SQLite** and **JSON file storage** with caching.

Author: **@Nperma**
GitHub: [https://github.com/nperma](https://github.com/nperma)

---

## Overview

This module is designed to simplify persistent data storage by exposing the same API for SQL and JSON backends.

Use cases:

- Player data
- Counters / statistics
- Simple configuration storage
- Lightweight persistence without complex schemas

---

## Features

- Two backends:
  - **SQLite** (`sql`)
  - **JSON file** with in-memory cache (`json`)

- Unified API for both backends
- JSON data is:
  - Loaded once
  - Cached in memory
  - Automatically flushed on changes

- SQLite table auto-created (`kv`)
- Minimal overhead and predictable performance

---

## Installation

Save the module as:

```
db-wrapper.lua
```

Then import it using `require`.

---

## Importing the Module

```lua
local Database = require("db-wrapper").wrapper
```

---

## Creating a Database Instance

### JSON Backend (default)

```lua
local db = Database("player-data")
```

This will create:

```
currentState/luaData/player-data.json
```

---

### SQL Backend

```lua
local db = Database("player-data", "sql")
```

This will create:

```
player-data.db
```

---

## API Reference

All backends expose the same methods.

---

### set(key, value)

Stores or updates a value.

```lua
db.set("coins", 100)
```

---

### get(key)

Returns the stored value, or `nil` if the key does not exist.

```lua
local coins = db.get("coins")
```

---

### has(key)

Checks whether a key exists.

```lua
if db.has("coins") then
  print("Coins key exists")
end
```

---

### delete(key)

Removes a key and its value.

```lua
db.delete("coins")
```

---

### keys()

Returns all stored key–value pairs as a table.

```lua
local data = db.keys()
for key, value in pairs(data) do
  print(key, value)
end
```

---

### values()

Returns all stored values as an array.

```lua
local values = db.values()
for i, value in ipairs(values) do
  print(value)
end
```

---

### close() _(SQL only)_

Closes the SQLite connection.

```lua
db.close()
```

> JSON backend does **not** require `close()`.

---

## Example Usage

### Player Counter (JSON)

```lua
local Database = require("db-wrapper").wrapper

local playerDB = Database("player-counter")

local userId = tostring(player:getUserID())

local count = playerDB.get(userId) or 0
playerDB.set(userId, count + 1)

player:onConsoleMessage("Counter: " .. (count + 1))
```

---

## Notes

- Use **JSON** for small, fast-access data.
- Use **SQL** for larger or structured datasets.
- Always call methods using dot notation:

  ```lua
  db.get(key)
  ```

  not colon notation.

- JSON data is cached in memory and flushed automatically.
