-- class by @Nperma | github: @nperma
local Player = {}

-- @param player Player
function Player.register(player)
  local self = {
    __player = player,
    name     = player:getName(),
    userID   = player:getUserID(),
    netID    = player:getNetID(),
    email    = player:getEmail(),
    ip       = player:getIP(),
    rid      = player:getRID()
  }

  function self:say(message)
    player:onTalkBubble(self.netID, message, 0)
  end

  function self:console(message)
    player:onConsoleMessage(message)
  end

  function self:getTile()
    return player:getWorld():getTile(player:getPosX(), player:getPosY())
  end

  function self:consumeItem(itemID, amount)
    local world = player:getWorld()
    amount = amount or 1
    if amount > 1 then
      for i = 1, amount do
        world:useConsumable(player, self:getTile(), itemID, 1)
      end
    else
      world:useConsumable(player, self:getTile(), itemID, 1)
    end
  end

  function self:openDialog(dialogString, callback, delay)
    delay = delay or 0
    player:onDialogRequest(dialogString, delay, callback)
  end

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
