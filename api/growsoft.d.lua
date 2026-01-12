---@meta
--- GrowSoft / GTPS Cloud LuaScript API Definitions
--- IntelliSense only (NOT executed)

-- =========================================================
-- DATA TYPES
-- =========================================================

---@class CommandData
---@field command string
---@field description string
---@field roleRequired? number

---@class EventData
---@field id number
---@field title string
---@field description string
---@field message string

---@class SidebarButton
---@field active boolean
---@field buttonAction string
---@field buttonTemplate string
---@field counter number
---@field counterMax number
---@field itemIdIcon number
---@field name string
---@field order number
---@field rcssClass string
---@field text string

-- =========================================================
-- GLOBAL UTILITIES
-- =========================================================

---@class Json
---@field encode fun(value: any): string
---@field decode fun(text: string): any
json = {}

---@class Timer
---@field setInterval fun(interval: number, callback: fun()): any
---@field setTimeout fun(timeout: number, callback: fun()): any
---@field clear fun(id: any): any
timer = {}

-- =========================================================
-- ROLE
-- =========================================================

---@class Role
---@field roleID number
---@field rolePrice number
---@field roleName string
---@field roleItemID number
---@field textureName string
---@field textureXY string
---@field discordRoleID string
---@field roleDescription string
---@field namePrefix string
---@field chatPrefix string
---@field dailyRewardDiamondLocksCount number
---@field rolePriority number
---@field computedFlags number

-- =========================================================
-- ITEM
-- =========================================================

---@class Item
---@field getName fun(self: Item): string
---@field getID fun(self: Item): number

-- =========================================================
-- TILE
-- =========================================================

---@class Tile
---@field getTileID fun(self: Tile): number
---@field getPosX fun(self: Tile): number
---@field getPosY fun(self: Tile): number

-- =========================================================
-- DROP
-- =========================================================

---@class Drop
---@field getUID fun(self: Drop): number
---@field getItemID fun(self: Drop): number
---@field getPosX fun(self: Drop): number
---@field getPosY fun(self: Drop): number

-- =========================================================
-- PLAYER & NPC
-- =========================================================

---@class Player
---@field getWorld fun(self: Player): World
---@field getRole fun(self: Player): Role
---@field getBankBalance fun(self: Player): number
---@field setBankBalance fun(self: Player, value: number)
---@field onConsoleMessage fun(self: Player, text: string)
---@field onTalkBubble fun(self: Player, netID: number, text: string, condition: number)
---@field getName fun(self: Player): string
---@field getIP fun(self: Player): string
---@field getRID fun(self: Player): number
---@field getUserID fun(self: Player): number
---@field getNetID fun(self: Player): number
---@field sendVariant fun(self: Player, variants: any[], delay?: number, netID?: number)
---@field onDialogRequest fun(self: Player, dialog: string)
---@field hasRole fun(self: Player, roleID: number): boolean
---@field hasActiveBlessing fun(self: Player): boolean
---@field addBlessing fun(self: Player, name: string)
---@field getPosX fun(self: Player): number
---@field getPosY fun(self: Player): number
---@field getItemAmount fun(self: Player, itemID: number): number
---@field changeItem fun(self: Player, itemID: number, amount: number, toBackpack: number): boolean
---@field playAudio fun(self: Player, filePath: string,delay?: number)
---@field onParticleEffect fun(self: Player, particleID: number,tileX:number,tileY:number,none1:number,none2:number,none3:number)
---@field addBankBalance fun(self: Player, amount:number)
---@field isOnline fun(self: Player): boolean

---@class NPC
---@return Player

-- =========================================================
-- WORLD
-- =========================================================

---@class World
---@field getName fun(self: World): string
---@field getID fun(self: World): number
---@field getTiles fun(self: World): Tile[]
---@field getWorldLock fun(self: World): Tile|nil
---@field getOwner fun(self: World): Player|nil
---@field getWorldType fun(self: World): string
---@field setOwner fun(self: World, userID: number)
---@field getDroppedItems fun(self: World): Drop[]
---@field getTileDroppedItems fun(self: World, tile: Tile): Drop[]
---@field getWorldSizeX fun(self: World): number
---@field getWorldSizeY fun(self: World): number
---@field getPlayers fun(self: World): Player[]
---@field spawnItem fun(self: World, x: number, y: number, itemID: number, condition: number): Drop
---@field removeDroppedItem fun(self: World, dropUID: number)
---@field updateClothing fun(self: World, player: Player|NPC)
---@field setClothing fun(self: World, target: Player|NPC, itemID: number)
---@field hasAccess fun(self: World, user: Player|NPC): boolean
---@field addAccess fun(self: World, user: Player|NPC, permission: 0|1)
---@field removeAccess fun(self: World, user: Player|NPC)
---@field hasTileAccess fun(self: World, user: Player|NPC, tile: Tile): boolean
---@field addTileAccess fun(self: World, user: Player|NPC, tile: Tile)
---@field removeTileAccess fun(self: World, user: Player|NPC, tile: Tile)
---@field createNPC fun(self: World, name: string, x: number, y: number)
---@field findNPCByName fun(self: World, npcName: string)
---@field removeNPC fun(self: World, npc: NPC)
---@field setTileForeground fun(self: World, tile: Tile, itemID: number, isVisual?: 1|0, player?: Player)
---@field setTileBackground fun(self: World, tile: Tile, itemID: number, isVisual?: 1|0, player?: Player)
---@field getTile fun(self: World, tileX: number, tileY: number): Tile
---@field useItemEffect fun(self: World, senderNetID: number, itemID: number, targetNetID: number, delay: number)

-- =========================================================
-- GLOBAL FUNCTIONS
-- =========================================================

---@param commandData CommandData
function registerLuaCommand(commandData) end

---@param worldID number
---@return World
function getWorld(worldID) end

---@param playerID number
---@return Player
function getPlayer(playerID) end

---@param itemID number
---@return Item
function getItem(itemID) end

---@return Role
function getHighestPriorityRole() end

---@param object {modID: number,modName: string, onAddMessage: string, onRemoveMessage: string, iconID: number, changeSkin: table,modState: table}
function registerLuaPlaymod(object) end

---@return Role[]
function getRoles() end

---@param eventData EventData
function registerLuaEvent(eventData) end

---@return number
function getCurrentServerEvent() end

---@param sidebarJson string
function addSidebarButton(sidebarJson) end

---@param text string
function parseText(text) end

-- =========================================================
-- CALLBACKS
-- =========================================================

---@param callback fun(world: World, player: Player, message: string): boolean|nil
function onPlayerCommandCallback(callback) end

---@param callback fun(player: Player)
function onPlayerLoginCallback(callback) end

---@param callback fun(world: World, player: Player, data: string[]): boolean|nil
function onPlayerDialogCallback(callback) end

---@param callback fun(world: World, player: Player, itemID: number, itemcount: number): boolean|nil
function onPlayerPickupItemCallback(callback) end

---@param callback fun(player: Player)
function onPlayerBlessingClaimCallback(callback) end

---@param callback fun(world: World, player: Player)
function onPlayerEnterWorldCallback(callback) end

---@param callback fun(player: Player)
function onPlayerBoostClaimCallback(callback) end

---@param callback fun()
function onAutoSaveRequest(callback) end

---@param callback fun(newEventID: number, oldEventID: number)
function onEventChangedCallback(callback) end

---@param callback fun(world: World, player: Player, tile: Tile): boolean|nil
function onTilePunchCallback(callback) end

---@param callback fun(world: World, player: Player, tile: Tile, clickedPlayer: Player, itemID: number): boolean|nil
function onPlayerConsumableCallback(callback) end

---@param callback fun(player: Player, variants: any[], delay: number, netID: number)
function onPlayerVariantCallback(callback) end

---@param callback fun(world: World, player: Player, data: string[]): boolean|nil
function onPlayerActionCallback(callback) end

---@param callback fun(world: World, player: Player, tile: Tile): boolean|nil
function onTileWrenchCallback(callback) end

---@param callback fun(): any
function onTick(callback) end

---@param callback fun(player: Player): any
function onPlayerTick(callback) end

---@param callback fun(world: World): any
function onWorldTick(callback) end

---@param callback fun(world: World): any
function onWorldLoaded(callback) end

---@param callback fun(world: World): any
function onWorldOffloaded(callback) end

---@param callback fun(player: Player, data: string, delay: number, netID: number): boolean|nil
function onPlayerVariantCallback(callback) end

---@param callback fun(world: World,player: Player, tile: Tile): boolean|nil
function onTileBreakCallback(callback) end

-- =========================================================
-- SERVER STORAGE
-- =========================================================

---@param key string
---@param value string
function saveStringToServer(key, value) end

---@param key string
---@return string
function loadStringFromServer(key) end

--- Save Data into table
---
--- @usage
--- saveDataToServer('nperma_db', {'boolean'})
---
---@param key string -- key database
---@param data any -- value
function saveDataToServer(key, data) end

---@param key string
---@return any
function loadDataFromServer(key) end

--- get Server ID
--- @return number
function getServerID() end

--- get Server Name
--- @return string
function getServerName() end
