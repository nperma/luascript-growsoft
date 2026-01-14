print('(test-dev-2026114) for GTPS Cloud | by Nperma')

local DEV = getHighestPriorityRole()
registerLuaCommand({
  command = "addobject",
  description = "DevOart",
  roleRequired = DEV.roleID
})

onPlayerCommandCallback(function(world, player, fullCommand)
  local command, args = fullCommand:match("^(%S+)%s*(.*)$")
  if command:lower() == "addobject" and player:hasRole(DEV.roleID) then
    local itemID = tonumber(args)
    if not itemID then
      player:onConsoleMessage("`4>> pls type the itemID..\n`oUsage: /" .. command .. " 242")
    else
      for i, tile in ipairs(world:getTiles()) do
        --  if i > 200 then break
        if tile:getTileForeground() == 0 or not tile:getTileForeground() then
          world:spawnItem(math.floor((tile:getPosX() / 32) * 32), math.floor((tile:getPosY() / 32) * 32), itemID, 1)
        end
      end
    end
    return true
  elseif command:lower() == "takeall" then
    local itemID = tonumber(args)
    if not itemID then
      player:onConsoleMessage("`4>> pls type the itemID..\n`oUsage: /" .. command .. " 242")
    else
      local npc = world:createNPC("test", player:getPosX(), player:getPosY())

      --- hide npc
      world:setClothing(npc, 1904) -- OneRing
      world:setClothing(npc, 3774) -- NoFace
      world:updateClothing(npc)
      for i, w_player in ipairs(world:getPlayers()) do
        w_player:sendVariant({ "OnNameChanged", "", "{}" }, 0, npc:getNetID())
      end
      local delay = 100
      for i, drop in ipairs(world:getDroppedItems()) do
        if drop:getItemID() == itemID then
          world:setPlayerPosition(npc, drop:getPosX(), drop:getPosY())
          --timer.setTimeout(0.2,function()
          world:removeDroppedItem(drop:getUID())
          world:useItemEffect(npc:getNetID(), itemID, player:getNetID(), 0)
          timer.setTimeout(0.4, function()
            world:removeNPC(npc)
          end)
          -- end)
        end
      end
    end
    return true
  end
end)
