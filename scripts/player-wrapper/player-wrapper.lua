-- class by @Nperma | github: @nperma

--- Player wrapper class.
--- Extends native Player instance.
---@class PlayerWrapper : Player
---@field __player Player        @ Native player reference
---@field name string            @ Player name
---@field userID number          @ Player user ID
---@field netID number           @ Player network ID
---@field email string           @ Player email
---@field ip string              @ Player IP address
---@field rid number             @ Player RID
---@field say fun(self: PlayerWrapper, message: string)
---@field console fun(self: PlayerWrapper, message: string)
---@field getTile fun(self: PlayerWrapper): Tile
---@field consumeItem fun(self: PlayerWrapper, itemID: number, amount?: number)
---@field isDev fun(self: PlayerWrapper, role?: number): boolean
---@field openDialog fun(self: PlayerWrapper, dialogString: string, callback: function, delay?: number)
---@field getInventory fun(self: PlayerWrapper): { items: table, isMax: boolean, size: number }
local Player = {}

--- Register native Player object into PlayerWrapper.
---@param player Player          @ Native Player object
---@return PlayerWrapper
function Player.register(player)
  ---@class PlayerWrapper
  local self = {
    __player = player,
    name     = player:getName(),
    userID   = player:getUserID(),
    netID    = player:getNetID(),
    email    = player:getEmail(),
    ip       = player:getIP(),
    rid      = player:getRID()
  }

  --- Send talk bubble message to player.
  ---@param message string
  function self:say(message)
    player:onTalkBubble(self.netID, message, 0)
  end

  --- Send console message to player.
  ---@param message string
  function self:console(message)
    player:onConsoleMessage(message)
  end

  --- Get current tile where player stands.
  ---@return Tile
  function self:getTile()
    return player:getWorld():getTile(
      player:getPosX(),
      player:getPosY()
    )
  end

  --- Consume item from inventory at player's position.
  ---@param itemID number
  ---@param amount? number        @ Default: 1
  function self:consumeItem(itemID, amount)
    local world = player:getWorld()
    amount = amount or 1

    for _ = 1, amount do
      world:useConsumable(player, self:getTile(), itemID, 1)
    end
  end

  --- Check whether player has developer / specific role.
  ---@param role? number          @ Default: highest priority role
  ---@return boolean
  function self:isDev(role)
    return player:hasRole(
      role or getHighestPriorityRole().roleID
    )
  end

  --- Open dialog for player.
  ---@param dialogString string
  ---@param callback function
  ---@param delay? number         @ Default: 0
  function self:openDialog(dialogString, callback, delay)
    delay = delay or 0
    player:onDialogRequest(dialogString, delay, callback)
  end

  --- Get inventory information.
  ---@return { items: table, isMax: boolean, size: number }
  function self:getInventory()
    return {
      items = player:getInventoryItems(),
      isMax = player:isMaxInventorySpace(),
      size  = player:getInventorySize()
    }
  end

  return setmetatable(self, {
    __index = function(_, key)
      local value = player[key]

      if type(value) == "function" then
        return function(_, ...)
          return value(player, ...)
        end
      end

      return value
    end
  })
end

return Player
