-- dev-test script
print("(Loaded) dev-test script for GTPS Cloud")

local DEV = getHighestPriorityRole()

registerLuaCommand({
  command = "addobject",
  description = "DevOart",
  roleRequired = DEV.roleID
})

onPlayerCommandCallback(function(world, player, fullCommand)
  local command, args = fullCommand:match("^(%S+)%s*(.*)$")
  command = command and command:lower()
  if command == "addobject" and player:hasRole(DEV.roleID) then
    local itemID = tonumber(args)
    if not itemID then
      player:onConsoleMessage("`4>> pls type the itemID..\n`oUsage: /addobject 242")
      return true
    end

    local tiles = world:getTiles()
    local index = 1
    
    local interval
    interval = timer.setInterval(0.0001, function()
      local tile = tiles[index]
      if not tile or index > #tiles then
        timer.clear(interval)
        return
      end

      local fg = tile:getTileForeground()
      if not fg or fg == 0 then
        local drop = world:spawnItem(
          tile:getPosX(),
          tile:getPosY(),
          itemID,
          1,
          0
        )
      end
      index = index + 1
    end)

    return true
  end

  if command == "takeall" then
    local itemID = tonumber(args)
    if not itemID then
        player:onConsoleMessage("`4>> pls type the itemID..\n`oUsage: /takeall 242")
        return true
    end
    local npc = world:createNPC(
        "test",
        player:getPosX() * 32,
        player:getPosY() * 32
    )
    world:setClothing(npc, 1904)
    world:setClothing(npc, 3774)
    world:updateClothing(npc)

    local npcNetID ,playerNetID = npc:getNetID(), player:getNetID()

    local removeDrop,setPos,useEffect = world.removeDroppedItem, world.setPlayerPosition,world.useItemEffect

    local found = false

    for _, drop in ipairs(world:getDroppedItems()) do
        if drop:getItemID() == itemID then
            found = true

            removeDrop(world, drop:getUID())
            setPos(
                world,
                npc,
                drop:getPosX(),
                drop:getPosY()
            )
            useEffect(
                world,
                npcNetID,
                itemID,
                playerNetID,
                0
            )
        end
    end
    world:removeNPC(npc)
    if not found then player:onConsoleMessage("none") end

    return true
end

end)
