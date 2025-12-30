---@meta
--- GrowSoft / GTPS Cloud Luascript API Definitions
--- IntelliSense only (NOT executed)

----- Globals

---@class CommandData
---@field command string
---@field description string 
---@field roleRequired number 
local CommandData = {}

--- Register a new Lua command
--- @usage
--- registerLuaCommand({command:"hello", description:"Says hello", roleRequired:0})
---@param commandData CommandData
registerLuaCommand = function(commandData) end

---get World Object by WorldID
---@param worldID integer
---@return World
function getWorld(worldID) end

---get Item Object by ItemID
---@param itemID integer
---@return Item 
function getItem(itemID) end

---get Higher Role Object by RoleID
---@return Role
function getHighestPriorityRole() end

---get Roles List
---@return Role[]
function getRoles() end

----- Role Object

---@class Role
---@field roleID number                          -- unique role ID
---@field rolePrice number                       -- role price
---@field roleName string                        -- role display name
---@field roleItemID number                      -- item ID associated with role
---@field textureName string                     -- texture file name
---@field textureXY string                       -- texture coordinates (e.g. "x,y")
---@field discordRoleID string                   -- Discord role ID
---@field roleDescription string                 -- role description text
---@field namePrefix string                      -- prefix before player name
---@field chatPrefix string                      -- prefix in chat
---@field dailyRewardDiamondLocksCount number    -- daily DL reward
---@field rolePriority number                    -- role priority (higher = stronger)
---@field computedFlags number                   -- internal computed flags (bitmask)
local Role = {}

----- Item Object

---@class Item
local Item = {}

---get item name
---@return string
function Item:getName() end

--- get itemID
--- @return number
function Item:getID() end

----- Tile Object

---@class Tile
local Tile = {}

--- get tileID
---@return number
function Tile:getTileID() end

----- Player Object

---@class Player
local Player = {}

--- Get player role Object
---@return Role
function Player:getRole() end

--- Print message to player's console
---
--- @example
--- player:onConsoleMessage("Hello World")
---
---@param text string
function Player:onConsoleMessage(text) end

--- Show a talk bubble for a player
---
--- @example
--- player:onTalkBubble(player:getNetID(), "Hello!", 0)
---
---@param netID number
---@param text string
---@param condition number
function Player:onTalkBubble(netID, text, condition) end

--- Get player name
---
--- @example
--- local name = player:getName()
---
---@return string
function Player:getName() end

--- Get player IP address
---
--- @example
--- local ip = player:getIP()
---
---@return string
function Player:getIP() end

--- Get player RID
---
--- @example
--- local rid = player:getRID()
---
---@return number
function Player:getRID() end

--- Get player userID
---@return number
function Player:getUserID() end

--- Get player NetID
---@return number
function Player:getNetID() end

--- Dialog Showed
--- @param dialog_string string
function Player:onDialogRequest(dialog_string) end

---Check Role
---@param roleID integer
---@return boolean
function Player:hasRole(roleID) end

--- Check if the player has any active blessing
---
--- @example
--- if player:hasActiveBlessing() then
---   player:onConsoleMessage("Blessing active!")
--- end
---
---@return boolean
function Player:hasActiveBlessing() end

--- Add a blessing to the player
---
--- @example
--- player:addBlessing("speed")
---
---@param name string
function Player:addBlessing(name) end

----- World Object

---@class World
local World = {}

---get world name
---@return string
function World:getName() end

---get world lock tile object
---@return Tile|nil
function World:getWorldLock() end

--- Get world type
---
--- @example
--- local type = world:getWorldType()
---
---@return string
function World:getWorldType() end

--- Set world owner
---
--- @example
--- world:setOwner(player:getUserID())
---
---@param userID number
function World:setOwner(userID) end

----- Callbacks

--- Player command callback
--- Fired when a player executes a command
---
--- @usage
--- onPlayerCommandCallback(function(world, player, message)
---   if message == "hello" then
---     player:onConsoleMessage("Hello " .. player:getName())
---     return true -- block default handler
---   end
---  return false
--- end)
---
---@param callback fun(world:World, player:Player, message:string): boolean|nil
function onPlayerCommandCallback(callback) end


--- Player dialog callback
---
--- @usage
--- onPlayerDialogCallback(function(world, player, data)
---   player:onConsoleMessage("Dialog: " .. data)
--- end)
---
---@param callback fun(world: World, player: Player, data: string): boolean|nil
function onPlayerDialogCallback(callback) end


---- Fired when a player claims a blessing
---
--- @usage
--- onPlayerBlessingClaimCallback(function(player)
---   player:onConsoleMessage("Blessing claimed!")
--- end)
---
---@param callback fun(player: Player)
function onPlayerBlessingClaimCallback(callback) end

---comment
---@param callback fun(world: World, player: Player): any
function onPlayerEnterWorldCallback(callback) end

--- Fired when a player claims a boost
---
--- @usage
--- onPlayerBoostClaimCallback(function(player)
---   player:onConsoleMessage("Boost activated!")
--- end)
---
---@param callback fun(player: Player)
function onPlayerBoostClaimCallback(callback) end

--- Auto Update Data
---@param callback fun()
function onAutoSaveRequest(callback) end

--- SAve Data String
--- @param key string
--- @param value string
function saveStringToServer(key, value) end

--- Load Data String
--- @param key string
--- @return string
function loadStringFromServer(key) end

---@class Json
---@field encode fun(value: any): string
---@field decode fun(text: string): any
local Json = {}