print('(example-kits) for GTPS Cloud | by Nperma')
--- /kits

local Configuration = {
  xpPerBreakBlock = 20,
  xpPerPlaceBlock = 4,

  command = 'kits',

  dialog = {
    titleLabel = 'Kits Season',
    titleIcon = 2,
  },

  maxLevel = 100,
  data = {
    {
      --- @property level number
      --- @property icon itemID|number
      --- @property description item description
      --- @property prizes[]
      level = 5,
      icon = 1404,
      description = 'Super Capek',
      prizes = {
        --- @key itemID number
        --- @value amount number
        [3104] = 1
      }
    }, {
    level = 10,
    icon = 406,
    description = 'Best `#Consumeable`o of the Time!!',
    prizes = {
      [406] = 140
    }
  }, {
    level = 15,
    icon = 20584,
    description = 'Mostly `##Farmable',
    prizes = {
      [20584] = 160
    }
  },
    {
      level = 20,
      icon = 10838,
      description = 'Fishing Pack\nGive some fishing starter Packs',
      prizes = {
        [3042] = 1,
        [2912] = 1,
        [3016] = 16
      }
    }, {
    level = 25,
    icon = 528,
    description = 'Buff and MUltiple',
    prizes = {
      [528] = 1,
      [4604] = 2,
      [1474] = 5
    }
  }, {
    level = 35,
    icon = 20700,
    description = 'Cheat buff\ngained some `#Buff',
    prizes = {
      [20700] = 1,
      [20648] = 1
    }
  }, {
    level = 45,
    icon = 4992,
    description = 'Anti Gravity',
    prizes = {
      [4992] = 1
    }
  }, {
    level = 55,
    icon = 4994,
    description = 'Idk',
    prizes = {
      [4994] = 1
    }
  }
  }
}

local player_db, player_table = loadStringFromServer('nperma_player_db'), {}

if player_db then
  player_table = json.decode(player_db)
end

local function calcRequireExp(level)
  return 100 + (level * 50)
end

local function getKitData(player)
  local uid = tostring(player:getUserID())
  if not player_table[uid] then
    player_table[uid] = {}
  end

  if not player_table[uid].kits then
    player_table[uid].kits = {
      level = 0,
      exp = 0,
      requireExp = calcRequireExp(0),
      claimed = {}
    }
  end

  return player_table[uid].kits
end

local function giveKit(player, kit)
  for itemID, amount in pairs(kit.prizes) do
    if not player:changeItem(itemID, amount, 0) then
      player:changeItem(itemID, amount, 1)
    end
  end
end

local function checkKitReward(player, kitData)
  for _, kit in ipairs(Configuration.data) do
    if kitData.level >= kit.level and not kitData.claimed[kit.level] then
      giveKit(player, kit)
      kitData.claimed[kit.level] = true
      player:onConsoleMessage(
        '`#KIT UNLOCKED!`\nLevel ' .. kit.level .. '\n' .. kit.description
      )
      -- checkKitReward(player, kitData)
    end
  end
end

local function addExp(player, amount)
  local kitData = getKitData(player)
  kitData.exp = kitData.exp + amount

  while kitData.exp >= kitData.requireExp and kitData.level < Configuration.maxLevel do
    kitData.exp = kitData.exp - kitData.requireExp
    kitData.level = kitData.level + 1
    kitData.requireExp = calcRequireExp(kitData.level)

    player:onConsoleMessage('`#LEVEL UP!` Level ' .. kitData.level)
  end
end

onTileBreakCallback(function(world, player, tile)
  addExp(player, Configuration.xpPerBreakBlock)
end)

onTilePlaceCallback(function(world, player, tile)
  addExp(player, Configuration.xpPerPlaceBlock)
end)

registerLuaCommand({
  command = Configuration.command,
  description = 'kits commmand',
  roleRequired = 0
})

local function kitDialog(player)
  local kitData = getKitData(player)
  local dialog = {
    'set_default_color|`o',
    ('add_custom_button|iconID|icon:' .. Configuration.dialog.titleIcon .. ';margin:0.5,0;state:disabled|'),
    ('add_progress_bar|' .. Configuration.dialog.titleLabel .. '|big||' .. kitData.exp .. '|' .. calcRequireExp(kitData.level) .. '|' .. kitData.level .. ' (' .. kitData.exp .. '/' .. calcRequireExp(kitData.level) .. ')|4294967295|'),
    'reset_placement_x|',
    'add_spacer|small|'
  }

  dialog[#dialog + 1] = 'add_label|small|Kits are `2unlocked `oby reaching the required kit levels:|left|'
  dialog[#dialog + 1] =
  'add_label|small|`4NOTE`o: You don\'t have access to claim any Kits, `9tap on a reward `oto request|left|'
  dialog[#dialog + 1] = 'add_spacer|small|'
  dialog[#dialog + 1] = 'text_scaling_string|kuontoleqwoe|'


  for i, item in ipairs(Configuration.data) do
    dialog[#dialog + 1] = ('add_button_with_icon|kit_' .. i .. '|' .. ((not kitData.claimed[item.level] and kitData.level >= item.level) and ('`2' .. math.min(kitData.level, item.level) .. '/' .. item.level) or (kitData.claimed[item.level] and kitData.level >= item.level) and '`oclaimed' or ('`4' .. math.min(kitData.level, item.level) .. '/' .. item.level)) .. '|' .. ((not kitData.claimed[item.level] and kitData.level >= item.level) and 'staticYellowFrame' or (kitData.claimed[item.level] and kitData.level >= item.level) and 'staticBlueFrame' or 'staticGreyFrame') .. (((not kitData.claimed[item.level] and kitData.level >= item.level) and ',enabled' or (kitData.claimed[item.level] and kitData.level >= item.level) and ',visibled' or ',disabled')) .. '|' .. item.icon .. '||')
  end
  dialog[#dialog + 1] = 'add_button_with_icon||END_LIST|noflags|0||'
  dialog[#dialog + 1] = 'add_spacer|small|'
  dialog[#dialog + 1] = 'add_smalltext|`4Note`o: Kit XP entirely separate from regular XP...|'
  dialog[#dialog + 1] =
  'add_smalltext|To get kit XP (not via gems like regular XP), you can do one of the following activities:|'
  dialog[#dialog + 1] = 'add_smalltext|- Breaking Blocks|'
  dialog[#dialog + 1] = 'add_smalltext|- Placing Blocks|'
  dialog[#dialog + 1] = 'end_dialog|kits|Thanks for the info||'
  player:onDialogRequest(table.concat(dialog, '\n'))
end

onPlayerCommandCallback(function(world, player, fullCommand)
  local command, args = fullCommand:match("^(%S+)%s*(.*)$")
  if command:lower() == 'kits' then
    kitDialog(player)
    return true
  end
end)

onPlayerDialogCallback(function(world, player, data)
  if data['dialog_name'] == 'kits' then
    local button = data['buttonClicked']

    if button ~= nil then
      local idx = button:match('^kit_(%d+)$')

      if idx ~= nil then
        local index = tonumber(idx)
        local kitData = getKitData(player)
        local kit = Configuration.data[index]

        if kit ~= nil then
          if kitData.level >= kit.level then
            if kitData.claimed[kit.level] ~= true then
              giveKit(player, kit)
              kitData.claimed[kit.level] = true
              player:onConsoleMessage(
                '`2KIT CLAIMED!`\nLevel ' .. kit.level .. '\n' .. kit.description
              )
            else
              player:onConsoleMessage('`4Kit already claimed')
            end
          else
            player:onConsoleMessage(
              '`4Required Level `o' .. kit.level .. '`4, your level is `o' .. kitData.level
            )
          end
        end
      end
    end

    --kitDialog(player)
    return true
  end
end)

onAutoSaveRequest(function()
  saveStringToServer('nperma_player_db', player_table)
end)
