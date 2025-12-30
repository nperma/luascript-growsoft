print("Winterfest Special Edition by @Nperma")

---- Log Dev
-- Diamond Builder ID = 10450
-- Special Winter Wish ID = 10536
-- Winter Wish ID = 10538

local BingoConfiguration = {
  card= {
    currency=242, -- itemID, default World Lock
    multiple=5, -- Multiple Card
    maximum=250, -- Maximum Reset Card Price
    resetTemporary=86400, -- second, default 1day
  },
  quests = { -- string[] = QuestArray
    -- key<string> = itemID, value<boolean,boolean,boolean>
    ["11538"] = {true,false,false}, -- index-1=WinterWishBoolean,index-2=CrackerBoolean<Coming Soon>,index-3=DiamondBuilderBoolean
    ["10404"] = {true,false,false},
    ["10422"] = {true,false,false},
    ["15086"] = {true,false,false},
    ["13018"] = {true,false,false}, --
    ["10420"] = {true,false,false},
    ["11496"] = {true,false,false},
    ["10444"] = {true,false,false},
    ["12934"] = {true,false,false},
    ["14122"] = {true,false,false}, --
    ["14114"] = {true,false,false},
    ["14120"] = {true,false,false},
    ["14118"] = {true,false,false},
    ["11454"] = {true,false,false},
    ["10412"] = {true,false,false}, --
    ["7398"] = {true,false,false},
    ["10466"] = {false,false,true},
    ["14998"] = {false,false,true},
    ["11528"] = {false,false,true},
    ["15000"] = {false,false,true}, --
    ["10458"] = {false,false,true},
    ["10470"] = {false,false,true},
    ["10464"] = {false,false,true},
    ["14134"] = {false,false,true},
    ["12950"] = {false,false,true}, --
    ["12948"] = {false,false,true}
  },
 rewards ={ -- int[] = RewardArray
   -- key<string> = itemID, value<int,number> = amount,chance
   ["12958"] = {1,1},
   ["20552"] = {1,0.1},
   ["15538"] = {1,0.5},
   ["14624"] = {1,2},
   ["14992"] = {1,1},
   ["15842"] = {1,0.1},
   ["13826"] = {1,5},
   ["14086"] = {1,2},
   ["15826"] = {1,1},
   ["15082"] = {1,10},
   ["15022"] = {1,10},
   ["10450"] = {1,20},
   ["10536"] = {{1,5},30}, -- randomizeIndex-1
   ["10538"] = {{3,5},30}
 }
}

------------ FORBIDDEN SPOT

local wse_db = loadDataFromServer("winterfest_event") or {}
local bingo_db = loadDataFromServer("bingo_winterfest_nperma") or {}
local wse_table = {}
local bingo_table = {}

if wse_db ~= nil then wse_table = wse_db end
if bingo_db ~= nil then bingo_table = bingo_db end

local function LogMessage(p, msg, use)
    use = use or 0
    if use ~= 1 then p:onTalkBubble(p:getNetID(), msg, 1) end
    if use ~= 2 then p:onConsoleMessage(msg) end
end

local function formatTime(t)
    local remaining = t - os.time()
    if remaining <= 0 then
        return "Temporary Inactive"
    end

    local h = math.floor(remaining / 3600)
    local m = math.floor((remaining % 3600) / 60)
    local s = remaining % 60

    if h > 0 then
        return string.format("%d Hour %d Minute %d Second left", h, m, s)
    end
    if m > 0 then
        return string.format("%d Minute %d Second left", m, s)
    end
    return string.format("%d Second left", s)
end

local function spawnParticle(player,particleID)
 for i=80,100 do
  player:sendVariant({v1="OnParticleEffect",v2=i,v3={x=player:getPosX(),y=player:getPosY()}},0,player:getNetID())
  LogMessage(player,'particle '..particleID)
 end
end

local WinterFestivalEventData = {
    id = 22,
    title = "`3Winter Festival`",
    description = "During Winter Festival, Bingo Event has started!",
    message = "`8It's time for the `3Winter Festival!```"
}

registerLuaEvent(WinterFestivalEventData)

onEventChangedCallback(function(newEventID, oldEventID)
    if WinterFestivalEventData.id == newEventID then
        print(WinterFestivalEventData.title .. " Has started!")
    elseif WinterFestivalEventData.id == oldEventID then
        print(WinterFestivalEventData.title .. " Has ended!")
    end
end)

local wse_sidebar = {
    active = true,
    buttonAction = "winterfestivalmenu",
    buttonTemplate = "BaseEventButton",
    counter = 0,
    counterMax = 0,
    itemIdIcon = 9186,
    name = "WinterFestival",
    order = WinterFestivalEventData.id,
    rcssClass = "daily_challenge",
    text = "`#Winterfest Event`"
}

local bingo_sidebar = {
    active = true,
    buttonAction = "show_bingo_ui",
    buttonTemplate = "BaseEventButton",
    counter = 0,
    counterMax = 0,
    itemIdIcon = 9186,
    name = "WinterBingoButton",
    order = 49,
    rcssClass = "wf-bingo",
    text = ""
}

addSidebarButton(json.encode(wse_sidebar))
addSidebarButton(json.encode(bingo_sidebar))

onPlayerLoginCallback(function(player)
    player:sendVariant({
        "OnEventButtonDataSet",
        wse_sidebar.name,
        (getCurrentServerEvent() == WinterFestivalEventData.id) and 1 or 0,
        json.encode(wse_sidebar)
    })
  player:sendVariant({
        "OnEventButtonDataSet",
        bingo_sidebar.name,
        (getCurrentServerEvent() == WinterFestivalEventData.id) and 1 or 0,
        json.encode(bingo_sidebar)
    })
end)

onPlayerEnterWorldCallback(function(world, player)
  
    player:sendVariant({
        "OnEventButtonDataSet",
        wse_sidebar.name,
        (getCurrentServerEvent() == WinterFestivalEventData.id) and 1 or 0,
        json.encode(wse_sidebar)
    })
  player:sendVariant({
        "OnEventButtonDataSet",
        bingo_sidebar.name,
        (getCurrentServerEvent() == WinterFestivalEventData.id) and 1 or 0,
        json.encode(bingo_sidebar)
    })
end)

local function randomReward(usedRareRewards)
    usedRareRewards = usedRareRewards or {}

    local rarePool = {}
    local commonPool = {}

    for itemID, data in pairs(BingoConfiguration.rewards) do
        local amountData = data[1]
        local chance = data[2]
        local id = tonumber(itemID)

        local amount
        if type(amountData) == "table" then
            amount = math.random(amountData[1], amountData[2])
        else
            amount = amountData
        end

        local entry = {
            itemID = id,
            amount = amount,
            chance = chance
        }

        if chance < 20 then
            if not usedRareRewards[id] then
                table.insert(rarePool, entry)
            end
        else
            table.insert(commonPool, entry)
        end
    end

    if #rarePool > 0 then
        local pick = rarePool[math.random(#rarePool)]
        usedRareRewards[pick.itemID] = true
        return {
            itemID = pick.itemID,
            amount = pick.amount
        }
    end

    if #commonPool > 0 then
        local pick = commonPool[math.random(#commonPool)]
        return {
            itemID = pick.itemID,
            amount = pick.amount
        }
    end

    return {}
end


local function randomQuest()
    local pool = {}

    for itemID, flags in pairs(BingoConfiguration.quests) do
        local types = {}

        for i = 1, #flags do
            if flags[i] then
                table.insert(types, i)
            end
        end

        if #types > 0 then
            table.insert(pool, {
                itemID = tonumber(itemID),
                typeIndex = types
            })
        end
    end

    if #pool == 0 then
        return nil
    end

    return pool[math.random(#pool)]
end



local function randomVector2(sizeX, sizeY)
    local minX = math.min(0, sizeX)
    local maxX = math.max(0, sizeX)
    local minY = math.min(0, sizeY)
    local maxY = math.max(0, sizeY)
    local x = math.random(minX, maxX)
    local y = math.random(minY, maxY)
    return x, y
end

local function findSurfaceY(world, x, startY)
    if world:getTile(x/32, startY/32):getTileForeground() == 0 then
        return startY
    end
    local y = startY
    for _ = 1, 50 do
        y = y - 32
        if y < 0 then break end
        if world:getTile(math.floor(x/32), math.floor(y/32)):getTileForeground() == 0 then
            return y
        end
    end
    return startY
end

local function findValidDropPosition(world, sizeX, sizeY, playerY)
    for _ = 1, 40 do
        local x, y = randomVector2(sizeX, sizeY)
        if math.random() <= 0.5 then
            y = findSurfaceY(world, x, playerY)
        else
            local offsetY = playerY + (math.random(-2, 2) * 32)
            y = findSurfaceY(world, x, offsetY)
        end
        local tile = world:getTile(x/32, y/32)
        local drops = world:getTileDroppedItems(tile)
        local same = false
        for _, d in ipairs(drops) do
            if d:getItemID() == 9186 then
                same = true
                break
            end
        end
        if not same then return x, y end
    end
    return nil, nil
end

local function buildQuestPool()
    local pool = {}

    for itemID, flags in pairs(BingoConfiguration.quests) do
        local types = {}
        for i = 1, #flags do
            if flags[i] then table.insert(types, i) end
        end

        if #types > 0 then
            table.insert(pool, {
                itemID = tonumber(itemID),
                typeIndex = types
            })
        end
    end

    for i = #pool, 2, -1 do
        local j = math.random(i)
        pool[i], pool[j] = pool[j], pool[i]
    end

    return pool
end

local function checkBingoCompletion(player)
    local uid = player:getUserID()
    local pdata = bingo_table[uid]
    if not pdata or not pdata.quest or not pdata.reward or not pdata.layout then
        return {}
    end

    local result = {}

    for r = 0, 4 do
        local complete = true

        for c = 0, 4 do
            local index = (r * 5) + c
            local itemID = pdata.layout[index]

            if not itemID or pdata.quest[itemID] ~= true then
                complete = false
                break
            end
        end

        if complete and not pdata.reward.row[r].claimed then
            table.insert(result, {
                index = r,
                tipe = "row",
                reward = pdata.reward.row[r]
            })
        end
    end

    for c = 0, 4 do
        local complete = true

        for r = 0, 4 do
            local index = (r * 5) + c
            local itemID = pdata.layout[index]

            if not itemID or pdata.quest[itemID] ~= true then
                complete = false
                break
            end
        end

        if complete and not pdata.reward.col[c].claimed then
            table.insert(result, {
                index = c,
                tipe = "col",
                reward = pdata.reward.col[c]
            })
        end
    end

    return result
end



local function BingoWinterfestDialog(player)
    local uid = player:getUserID()
    local playerDataBingo = bingo_table[uid]
    if not playerDataBingo
      and type(playerDataBingo) ~= "table" then
        playerDataBingo = {
            quest = {},
            layout = {},
            card = playerDataBingo and playerDataBingo.card or 1,
            reward = { row = {}, col = {} }
        }

        local questPool = buildQuestPool()
          local poolIndex = 1
          
          for i = 0, 24 do
              if poolIndex > #questPool then
                  questPool = buildQuestPool()
                  poolIndex = 1
              end
          
              local q = questPool[poolIndex]
              poolIndex = poolIndex + 1
              playerDataBingo.layout[i] = q.itemID
              playerDataBingo.quest[q.itemID] = false
          end
          
      local usedRareRewards = {}
      
      for r = 0, 4 do
          local rw = randomReward(usedRareRewards)
            playerDataBingo.reward.row[r] = {
                itemID = rw.itemID,
                amount = rw.amount,
                claimed = false
            }
        end

        for c = 0, 4 do
          local rw = randomReward(usedRareRewards)
            playerDataBingo.reward.col[c] = {
                itemID = rw.itemID,
                amount = rw.amount,
                claimed = false
            }
        end

        bingo_table[uid] = playerDataBingo
    end

    local dialog = {}

    table.insert(dialog, "add_label_with_icon|big|Winterfest Bingo|left|1360|")
    table.insert(dialog, "add_spacer|small|")
    table.insert(dialog, "add_textbox|Collect items across Winterfest to get prizes. Once you get 5 items in a row or column, you will be able to claim the prize displayed at the end of that row or column.|left|")
    table.insert(dialog, "add_spacer|small|")

    local questIndex = 0


    for row = 0, 4 do
        local yOffset = row == 0 and 0 or 89
        table.insert(dialog, string.format("add_custom_margin|x:10;y:%d|", yOffset))
    
        for col = 0, 4 do
            local itemID = playerDataBingo.layout[questIndex]
            local done = playerDataBingo.quest[itemID] == true
    
            table.insert(dialog,
                string.format(
                    "add_custom_button|bingoItem_%d|icon:%d;state:%s;border:%s;margin:0,0;|",
                    questIndex,
                    done and 6292 or itemID,
                    done and "disabled" or "enabled",
                    done and "grey" or "white"
                )
            )
    
            questIndex = questIndex + 1
        end
    
        local rr = playerDataBingo.reward.row[row]
        local rState = rr.claimed
    
        table.insert(dialog,
            string.format(
                "add_custom_button|rowRewardItem_%d|icon:%d;state:%s;border:%s;margin:30,0;|",
                row,
                rState and 6292 or rr.itemID,
                "disabled",
                BingoConfiguration.rewards[tostring(rr.itemID)][2] < 0 and "yellow" or "purple"
            )
        )
    
        table.insert(dialog,
            string.format(
                "add_custom_label|%d|target:rowRewardItem_%d;top:0.87;left:0.87;size:small;alignment:7|",
                rr.amount,
                row
            )
        )
    
        table.insert(dialog, "reset_placement_x|")
    end


    table.insert(dialog, string.format("add_custom_margin|x:10;y:%d|", 89 + 25))

    for col = 0, 4 do
        local cr = playerDataBingo.reward.col[col]
        local cState = cr.claimed
        local chance = BingoConfiguration.rewards[tostring(cr.itemID)][2]
        table.insert(dialog,
            string.format(
                "add_custom_button|columnRewardItem_%d|icon:%d;state:%s;border:%s;margin:0,0;|",
                col,
                cState and 6292 or cr.itemID,
                "disabled",
                (chance < 0 or chance % 1 ~= 0) and "yellow" or "purple"
            )
        )

        table.insert(dialog,
            string.format(
                "add_custom_label|%d|target:columnRewardItem_%d;top:0.87;left:0.87;size:small;alignment:7|",
                cr.amount,
                col
            )
        )
    end
    
    local bingoPrize = checkBingoCompletion(player)
    
    if #bingoPrize == 0 then
    table.insert(dialog, table.concat({
      "add_custom_break|",
      "reset_placement_x|",
      "add_spacer|small|",
      string.format("add_button|reset_card|Reset Card for %d %ss|noflags|0|0|",math.min((BingoConfiguration.card.multiple*(playerDataBingo.card or 1)),BingoConfiguration.card.maximum),getItem(BingoConfiguration.card.currency):getName()),
      "add_spacer|small|",
      "add_textbox|`oThe cost will increase with each Reset until you claim a reward. Resetting the card will discard all the progress you have on the current card and give new items to collect and new rewards to achieve. Any unachieved rewards will be lost.|",
      "add_spacer|small|"
    },"\n"))
  else end

    table.insert(dialog, "add_quick_exit|")
    table.insert(dialog, "end_dialog|bingo_winterfest_ui|close|")

    player:onDialogRequest(table.concat(dialog, "\n"))
end

onTilePunchCallback(function(world, player, tile)
    if tile:getTileID() == 10450 then

        local uid = player:getUserID()
        local BingoPlayerData = bingo_table[uid]

        if BingoPlayerData and BingoPlayerData.quest then
            timer.setTimeout(0.3, function()

                local drops = world:getTileDroppedItems(tile)

                if drops then

                    if #drops > 0 then
                        for _, drop in ipairs(drops) do
                            local dropID = drop:getItemID()

                            local questState = BingoPlayerData.quest[dropID]

                            if questState == false then
                                BingoPlayerData.quest[dropID] = true
                                
                            end
                        end
                    end
                end

            end)
        end

    end
end)

local p_qwtsy={}
onPlayerConsumableCallback(function(_, player, __, ___, itemID)
  if itemID==10536 or itemID==10538 then p_qwtsy[player:getUserID()]=true end
end)

onPlayerVariantCallback(function(player, variant, delay, netID)
  if variant[1] == 'OnConsoleMessage' and p_qwtsy[player:getUserID()] then
    p_qwtsy[player:getUserID()] = false

    local amount, itemName = variant[2]:match("^You got (%d+) (.+)$")
    local uid = player:getUserID()
    local BingoPlayerData = bingo_table[uid]

    if BingoPlayerData and BingoPlayerData.quest then
     for itemID,_ in pairs(BingoPlayerData.quest) do
      local questItemName=getItem(itemID):getName()
      if itemName==questItemName then
        local questState = BingoPlayerData.quest[itemID]

       if questState and questState == false then
        LogMessage(player,itemName..' bingo')
        BingoPlayerData.quest[itemID] = true
       end
      end
     end
    end
  end
end)


onPlayerActionCallback(function(world, player, data)
    local action = data["action"]
    local pdata = wse_table[player:getUserID()]
    if action == wse_sidebar.buttonAction then
    if getCurrentServerEvent() == WinterFestivalEventData.id then

    if world:getOwner():getUserID() ~= player:getUserID() then
        LogMessage(player, "`4You can't start Event in this world")
        return true
    end

    if not wse_table[player:getUserID()] then
        wse_table[player:getUserID()] = {temporary = os.time(), list = {}, countdownInterval = os.time()}
    end

    local pdata = wse_table[player:getUserID()]
    local allFound = true

    for _, v in pairs(pdata.list) do
        if not v[3] then allFound = false break end
    end

    if pdata.countdownInterval > os.time() and not allFound then
        LogMessage(player, "`eEvent already running")
        return true
    end

    if pdata.temporary > os.time() then
        LogMessage(player, string.format("`eEvent Cooldown, wait `o%s",formatTime(pdata.temporary)))
        return true
    end

    pdata.temporary = os.time() + 3600
    pdata.list = {}

    local sizeX = world:getWorldSizeX() * 32
    local sizeY = world:getWorldSizeY() * 32
    local playerY = player:getPosY()

    for i = 1, 5 do
        local x, y = findValidDropPosition(world, sizeX, sizeY, playerY)
        if not x then break end
        world:spawnItem(x, y or 0, 9186, 1)
        pdata.list[tostring((x/32) .. "-" .. (y/32))] = {x, y, false}
    end
    for _, pl in ipairs(world:getPlayers()) do
    pl:sendVariant({
        "OnAddNotification",
        "interface/large/special_event.rttex",
        "`2Royal Winter: `#Royal Winter Seals `ofor everyone! Be Quick you have `230 `oseconds to collect them!",
        "audio/hub_open.wav",
        0
    })
    end

    pdata.countdownInterval = os.time() + 30

    timer.setTimeout(30.0, function()
        local pdata2 = wse_table[player:getUserID()]
        if not pdata2 then return end

        local foundCount = 0
        for _, v in pairs(pdata2.list) do
            if v[3] then foundCount = foundCount + 1 end
        end

        if foundCount < 5 then
          for _, pl in ipairs(world:getPlayers()) do
            pl:sendVariant({
                "OnAddNotification",
                "interface/large/special_event.rttex",
                string.format("`2Royal Winter: `oTime's up! %d of %d items found.", foundCount, 5),
                "",
                0
            })
          end
          for _,drop in ipairs(world:getDroppedItems()) do 
            if drop:getItemID() == 9186 then world:removeDroppedItem(drop:getUID()) end
            end
        end
      end)
      return true
     end
     return true
    elseif action == bingo_sidebar.buttonAction then
      BingoWinterfestDialog(player)
     return true
    end
    return false
end)

local function BingoResetConfirmDialog(player, price)
    local currencyName = getItem(BingoConfiguration.card.currency):getName()
    local currencyCount = player:getItemAmount(BingoConfiguration.card.currency)

    local dialog = {}

    table.insert(dialog, "add_label_with_icon|big|Re-roll Card?|left|1360|")
    table.insert(dialog, "add_spacer|small|")
    table.insert(dialog, "add_textbox|You will lose all progress you have on the current card and replace all the prizes BING with new prizes.|left|")
    table.insert(dialog, "add_spacer|small|")

    table.insert(dialog,
        string.format(
            "add_button|reset_card_confirm|Pay %d %s|%s|0|0|",
            price,
            currencyName,
            price > currencyCount and "off" or "noflags"
        )
    )

    table.insert(dialog, "add_spacer|small|")
    table.insert(dialog, string.format("add_textbox|`oYou currently have : %s `o%s|left|",(price > currencyCount and "`4" or "`2")..currencyCount,currencyName))
    table.insert(dialog, "add_spacer|small|")

    table.insert(dialog, "add_spacer|small|")
    table.insert(dialog, "add_quick_exit|")
    table.insert(dialog, "end_dialog|bingo_reset_confirm|Cancel|")

    player:onDialogRequest(table.concat(dialog, "\n"))
end


onPlayerPickupItemCallback(function(world, player, itemID, itemCount)
  if itemID == 9186 and wse_table[player:getUserID()] and wse_table[player:getUserID()].countdownInterval > os.time() then
    timer.setTimeout(0.2, function()
        local pdata = wse_table[player:getUserID()]
        if not pdata then return end

        local list = pdata.list
        local drops = world:getDroppedItems()

        for _, drop in ipairs(drops) do
            local tx = math.floor(drop:getPosX() / 32)
            local ty = math.floor(drop:getPosY() / 32)
            local keys = {
                tostring(tx .. "-" .. ty),
                tostring((tx - 1) .. "-" .. ty),
                tostring((tx + 1) .. "-" .. ty)
            }
            for _, k in ipairs(keys) do
                if list[k] then
                    list[k][3] = true
                    break
                end
            end
        end

        for key, value in pairs(list) do
            if not value[3] then
                local ox, oy = value[1], value[2]
                local vx = math.floor(ox / 32)
                local vy = math.floor(oy / 32)
                local exists = false

                for _, drop in ipairs(drops) do
                    local dx = math.floor(drop:getPosX() / 32)
                    local dy = math.floor(drop:getPosY() / 32)
                    if dy == vy and (dx == vx or dx == vx - 1 or dx == vx + 1) then
                        exists = true
                        break
                    end
                end

                if not exists then
                    value[3] = true
                end
            end
        end

        local allFound = true
        for _, v in pairs(list) do
            if not v[3] then allFound = false break end
        end

        if allFound then
          for _, pl in ipairs(world:getPlayers()) do
            pl:sendVariant({
                "OnAddNotification",
                "interface/large/special_event.rttex",
                "`2Royal Winter: `#Royal Winter Seals `oSuccess! All items found.",
                "audio/success.wav",
                0
            })
            end
        end
    end)
  end
end)

onPlayerDialogCallback(function(world,player,data) 
    local dialog,button = data["dialog_name"], data["buttonClicked"]
    local uid = player:getUserID()
    local BingoPlayerData = bingo_table[uid]

    if dialog == "bingo_winterfest_ui" then 
        if button == "reset_card" then 
            BingoResetConfirmDialog(
                player,
                math.min(
                    BingoPlayerData.card * BingoConfiguration.card.multiple,
                    BingoConfiguration.card.maximum
                )
            )
        end
        return true
    end
    if dialog == "bingo_reset_confirm" then
        if button ~= "reset_card_confirm" then return true end
        if not BingoPlayerData then return true end

        local currencyID = BingoConfiguration.card.currency
        local price = math.min(
            BingoPlayerData.card * BingoConfiguration.card.multiple,
            BingoConfiguration.card.maximum
        )

        
        local have = player:getItemAmount(currencyID)
        
        if have < price then
            LogMessage(player, string.format("`4You don't have enough %s to reset the Bingo card.",getItem(currencyID):getName()))
            return true
        end
        
        player:changeItem(currencyID,-price,0)

        BingoPlayerData.quest = {}
        BingoPlayerData.layout = {}
        local questPool = buildQuestPool()
        local poolIndex = 1

        for i = 0, 24 do
            if poolIndex > #questPool then
                questPool = buildQuestPool()
                poolIndex = 1
            end

            local q = questPool[poolIndex]
            poolIndex = poolIndex + 1
            
            BingoPlayerData.layout[i] = q.itemID
            BingoPlayerData.quest[q.itemID] = false
        end
        
        BingoPlayerData.reward = { row = {}, col = {} }

        local usedRareRewards = {}

        for r = 0, 4 do
            local rw = randomReward(usedRareRewards)
            BingoPlayerData.reward.row[r] = {
                itemID = rw.itemID,
                amount = rw.amount,
                claimed = false
            }
        end

        for c = 0, 4 do
            local rw = randomReward(usedRareRewards)
            BingoPlayerData.reward.col[c] = {
                itemID = rw.itemID,
                amount = rw.amount,
                claimed = false
            }
        end

        BingoPlayerData.card = (BingoPlayerData.card or 1) + 1

        LogMessage(player, "`2Your Bingo card has been successfully reset!")

        BingoWinterfestDialog(player)
        return true
    end
end)


onAutoSaveRequest(function()
    saveDataToServer("winterfest_event", wse_table)
    saveDataToServer("bingo_winterfest_nperma", bingo_table)
end)