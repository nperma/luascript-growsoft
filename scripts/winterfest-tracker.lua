print('(winterfest-tracker) for GTPS Cloud | by Nperma')

local Config = {
  temporary = 30
}

local event_temporary = loadDataFromServer('event_temporary_nperma') or {}
local temp_table = event_temporary['winterfest_tracker'] or {}
event_temporary['winterfest_tracker'] = temp_table

local lastTick = 0

local function randomVector2(sizeX, sizeY)
  return math.random(0, sizeX), math.random(0, sizeY)
end

local function findSurfaceY(world, x, startY)
  local y = startY
  for _ = 1, 50 do
    if world:getTile(math.floor(x / 32), math.floor(y / 32)):getTileForeground() == 0 then
      return y
    end
    y = y - 32
    if y < 0 then break end
  end
  return startY
end

local function findValidDropPosition(world, sizeX, sizeY, playerY)
  for _ = 1, 40 do
    local x, _ = randomVector2(sizeX, sizeY)
    local y = findSurfaceY(world, x, playerY + math.random(-2, 2) * 32)
    local tile = world:getTile(x / 32, y / 32)
    local drops = world:getTileDroppedItems(tile)
    local same = false
    for _, d in ipairs(drops) do
      if d:getItemID() == 9186 then
        same = true
        break
      end
    end
    if same == false then
      return x, y
    end
  end
  return nil, nil
end

onPlayerConsumableCallback(function(world, player, tile, clickedPlayer, itemID)
  if (itemID == 5402 or itemID == 5404) and (clickedPlayer ~= player or player:getUserID() == 1) then
    local worldID = world:getID()
    local userID = player:getUserID()

    if temp_table[worldID] == nil then
      temp_table[worldID] = {}
    end

    if temp_table[worldID][userID] == nil then
      temp_table[worldID][userID] = {}
    end

    player:sendVariant({
      "OnAddNotification",
      "interface/large/special_event.rttex",
      "`2Royal Winter: `#Royal Winter Seals `ofor everyone! Be Quick you have `230 `oseconds to collect them!",
      "audio/hub_open.wav",
      0
    })

    local expire = os.time() + Config.temporary
    temp_table[worldID][userID][expire] = {}

    for i = 1, 5 do
      local x, y = findValidDropPosition(
        world,
        world:getWorldSizeX() * 32,
        world:getWorldSizeY() * 32,
        player:getPosY()
      )
      if x ~= nil then
        local drop = world:spawnItem(x, y and y or player:getPosX(), 9186, 1)
        temp_table[worldID][userID][expire][drop:getUID()] = false
      end
    end
  end
end)

onWorldTick(function(world)
  local now = os.time()
  if now == lastTick then return end
  lastTick = now

  local worldID = world:getID()
  local worldData = temp_table[worldID]

  if worldData ~= nil then
    for userID, userData in pairs(worldData) do
      for expire, drops in pairs(userData) do
        if expire <= now then
          local foundCount = 0

          for uid, taken in pairs(drops) do
            if taken == true then
              foundCount = foundCount + 1
            end
            world:removeDroppedItem(uid)
          end

          local players = world:getPlayers()
          if #players ~= nil then
            for _,pl in ipairs(players) do
            pl:sendVariant({
              "OnAddNotification",
              "interface/large/special_event.rttex",
              string.format(
                "`2Royal Winter: `oTime's up! %d of %d items found.",
                foundCount,
                5
              ),
              "",
              0
            })
          end
        end

          userData[expire] = nil
        end
      end
    end
  end
end)


onPlayerPickupItemCallback(function(world, player, itemID, itemcount)
  if itemID == 9186 then
    local worldID = world:getID()
    local userID = player:getUserID()
    local worldData = temp_table[worldID]

    if worldData ~= nil then
      local userData = worldData[userID]
      if userData ~= nil then
        for expire, drops in pairs(userData) do
          for uid, taken in pairs(drops) do
            if taken == false then
              drops[uid] = true
              player:onConsoleMessage('take ' .. uid)
              return
            end
          end
        end
      end
    end
  end
end)


onAutoSaveRequest(function()
  saveDataToServer('event_temporary_nperma', event_temporary)
end)
