# GrowSoft Lua IntelliSense

Lua IntelliSense definitions (`.d.lua`) for **GrowSoft / GTPS Cloud LuaScript**.  
This project provides **autocomplete, type hints, callback signatures, and documentation**
inside **Visual Studio Code** using **Lua Language Server**.

> ⚠️ This repository contains **IntelliSense stubs only**  
> The files are **NOT executed at runtime**.

---

## 📁 Project Structure

```

luascript-growsoft/
│
├─ api/
│ └─ growsoft.d.lua # Main IntelliSense definitions
│
├─ scripts/ # Public Folder
│ └─ premium/ # Private Folder
│
│
└─ .vscode/
  └─ settings.json

```

Only **one IntelliSense file** is required:
👉 `api/growsoft.d.lua`

---

## 🚀 Installation (VS Code)

### 1️⃣ Install Lua Language Server

- Open VS Code
- Go to **Extensions**
- Install **Lua Language Server** (by sumneko)

---

### 2️⃣ Clone / Copy This Repository

Place this project anywhere you want, for example:

```

C:/Document/luascript-growsoft/

```

---

## ⚠️ Important Notice

> 🚧 **This IntelliSense is NOT complete yet**

- Some APIs may be missing
- Some callback parameters may be undocumented
- Some types may change based on server updates

This project aims to **match real GrowSoft / GTPS Cloud behavior**,
but it is still **work in progress**.

---

## 🤝 Contributing

Contributions are very welcome ❤️

You can help by:

- Adding missing APIs
- Fixing incorrect field types
- Improving documentation comments
- Syncing with official Growsoft / GTPS Cloud updates

### How to contribute

1. Fork this repository
2. Create a new branch
3. Make your changes
4. Submit a Pull Request

---

## 📜 License

This project is provided **as-is** for development convenience.
No official affiliation with GrowSoft or GTPS Cloud.

---

⭐ If this project helps you, consider giving it a star on GitHub!
