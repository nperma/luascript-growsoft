print('(loaded) buyassets script')
--- NOTE: you can modify the script but give the real source, dont sell the real source or you will get report unless that already major modify
--- WRITE BY NPERMA

registerLuaCommand({
  command = 'assets',
  description = 'Assets',
  roleRequired = 0
})

local RoleFlags = {
  ACCESS_ALL_WORLDS = bit.lshift(1, 0),
  ALLOW_DROPPING_UNTRADEABLE_ITEMS = bit.lshift(1, 1),
  ALLOW_FULL_ACCESS_BLAST_DESIGNER = bit.lshift(1, 2),
  BYPASS_ANTICHEAT = bit.lshift(1, 3),
  ALLOW_ENTER_NUKED_WORLDS = bit.lshift(1, 4),
  ALLOW_ENTER_ANY_WORLDS = bit.lshift(1, 5),
  INCREASE_BUILD_PUNCH_RANGE_SMALL = bit.lshift(1, 6),
  INCREASE_BUILD_PUNCH_RANGE_MEDIUM = bit.lshift(1, 7),
  INCREASE_BUILD_PUNCH_RANGE_UNLIMITED = bit.lshift(1, 8),
  BYPASS_ANTICHEAT_RANGE_CHECKS = bit.lshift(1, 9),
  DISABLE_ALL_COOLDOWN_EFFECTS = bit.lshift(1, 10),
  ALLOW_USE_SPK_COMMANDS = bit.lshift(1, 11),
  ALLOW_FIND_ALL_ITEMS = bit.lshift(1, 12),
  ALLOW_FIND_ALL_BLOCKS_AND_CLOTHES = bit.lshift(1, 13),
  BYPASS_BAD_WORDS_FILTER = bit.lshift(1, 14),
  BYPASS_BLOCKED_ITEMS_FILTER = bit.lshift(1, 15),
  BYPASS_ECONOMY_SCAN = bit.lshift(1, 16),
  ADVANCED_ECONOMY_ACCESS = bit.lshift(1, 17),
  ADVANCED_RENDER_ACCESS = bit.lshift(1, 18),
  DISABLE_SOME_COOLDOWN_EFFECTS = bit.lshift(1, 19),
  ALLOW_UNLIMITED_ZOOM = bit.lshift(1, 20),
  ALLOW_BREAKING_BEDROCK_AND_MAIN_DOOR = bit.lshift(1, 21),
  ALLOW_PULL_FROM_OTHER_WORLDS = bit.lshift(1, 22),
  SHOW_IN_MODS_LIST = bit.lshift(1, 23),
  BYPASS_BROADCAST_LEVEL_CHECK = bit.lshift(1, 24),
  GET_BONUS_XP = bit.lshift(1, 25),
  EXTRA_FISHING_ITEMS = bit.lshift(1, 26),
  REDUCE_TREE_GROWTIME = bit.lshift(1, 27)
}

local flagNames = {
  { RoleFlags.ACCESS_ALL_WORLDS,                    "Access All Worlds" },
  { RoleFlags.ALLOW_DROPPING_UNTRADEABLE_ITEMS,     "Can Drop Untradeable Items" },
  { RoleFlags.ALLOW_FULL_ACCESS_BLAST_DESIGNER,     "Full Access to Blast Designer" },
  { RoleFlags.BYPASS_ANTICHEAT,                     "Bypass Anti-Cheat Protection" },
  { RoleFlags.ALLOW_ENTER_NUKED_WORLDS,             "Can Enter Nuked Worlds" },
  { RoleFlags.ALLOW_ENTER_ANY_WORLDS,               "Can Enter Any World" },
  { RoleFlags.INCREASE_BUILD_PUNCH_RANGE_SMALL,     "Increased Build/Punch Range (Small)" },
  { RoleFlags.INCREASE_BUILD_PUNCH_RANGE_MEDIUM,    "Increased Build/Punch Range (Medium)" },
  { RoleFlags.INCREASE_BUILD_PUNCH_RANGE_UNLIMITED, "Unlimited Build/Punch Range" },
  { RoleFlags.BYPASS_ANTICHEAT_RANGE_CHECKS,        "Bypass Anti-Cheat Range Checks" },
  { RoleFlags.DISABLE_ALL_COOLDOWN_EFFECTS,         "Disable All Cooldowns" },
  { RoleFlags.ALLOW_USE_SPK_COMMANDS,               "Can Use Special SPK Commands" },
  { RoleFlags.ALLOW_FIND_ALL_ITEMS,                 "Can Find All Items" },
  { RoleFlags.ALLOW_FIND_ALL_BLOCKS_AND_CLOTHES,    "Can Find All Blocks & Clothes" },
  { RoleFlags.BYPASS_BAD_WORDS_FILTER,              "Bypass Chat Filter" },
  { RoleFlags.BYPASS_BLOCKED_ITEMS_FILTER,          "Bypass Blocked Items Filter" },
  { RoleFlags.BYPASS_ECONOMY_SCAN,                  "Bypass Economy Scan" },
  { RoleFlags.ADVANCED_ECONOMY_ACCESS,              "Advanced Economy Access" },
  { RoleFlags.ADVANCED_RENDER_ACCESS,               "Advanced Rendering Access" },
  { RoleFlags.DISABLE_SOME_COOLDOWN_EFFECTS,        "Disable Some Cooldowns" },
  { RoleFlags.ALLOW_UNLIMITED_ZOOM,                 "Unlimited Camera Zoom" },
  { RoleFlags.ALLOW_BREAKING_BEDROCK_AND_MAIN_DOOR, "Can Break Bedrock & Main Door" },
  { RoleFlags.ALLOW_PULL_FROM_OTHER_WORLDS,         "Can Pull Players Across Worlds" },
  { RoleFlags.SHOW_IN_MODS_LIST,                    "Visible in Moderators List" },
  { RoleFlags.BYPASS_BROADCAST_LEVEL_CHECK,         "Bypass Broadcast Level Requirement" },
  { RoleFlags.GET_BONUS_XP,                         "Receive Bonus XP" },
  { RoleFlags.EXTRA_FISHING_ITEMS,                  "Chance for Extra Fishing Items" },
  { RoleFlags.REDUCE_TREE_GROWTIME,                 "Reduced Tree Grow Time" }
}

local roles = getRoles()

table.sort(roles, function(a, b)
  return b.rolePriority > a.rolePriority
end)

local roleLookup = {}
for _, r in ipairs(roles) do
  roleLookup[r.roleID] = r
end

local dialog = {
  'set_bg_color|0,0,0,150|',
  'set_default_color|`o',
  'add_custom_button|iconID|state:disabled;icon:1366;margin:0.05,0;|',
  'add_label|big|Assets|left|',
  'add_smalltext|GrowP Assets List|',
  'add_custom_break|\nreset_placement_x|\nadd_spacer|small|',
  'add_smalltext|Ranks:|',
  'text_scaling_string|kuontoleqwoe|'
}

local role_map = {}
local item_map = {}

for i = 1, #roles do
  local role = roles[i]

  if role.roleID ~= getHighestPriorityRole().roleID and role.roleID ~= 10 then
    local roleCommands = role.allowCommands or {}

    local activeFlags = {}

    for j = 1, #flagNames do
      local flag, name = flagNames[j][1], flagNames[j][2]

      if bit.band(role.computedFlags, flag) ~= 0 then
        activeFlags[#activeFlags + 1] = name
      end
    end

    local highestRole = nil

    if role.allowCommandsFromRoles then
      for _, roleID in ipairs(role.allowCommandsFromRoles) do
        local r = roleLookup[roleID]

        if r then
          if not highestRole or r.rolePriority > highestRole.rolePriority then
            highestRole = r
          end
        end
      end
    end

    role_map[i] = {
      id = role.roleID,
      roleName = role.namePrefix .. role.roleName,
      flags = activeFlags,
      includes = highestRole and (highestRole.namePrefix .. highestRole.roleName) or nil,
      commands = roleCommands,
      rolePrice = role.rolePrice
    }

    dialog[#dialog + 1] =
        ('add_button_with_icon|role_' .. i .. '|' .. role_map[i].roleName .. '|staticPurpleFrame|5956||')

    if i % 5 == 0 then
      dialog[#dialog + 1] = 'add_button_with_icon||END_LIST|noflags|0||'
    end
  end
end

dialog[#dialog + 1] = 'reset_placement_x|\nadd_custom_break|\nadd_spacer|small|'
dialog[#dialog + 1] = 'add_smalltext|Items:|'

local itemEffects = getItemEffects()

table.sort(itemEffects, function(a, b)
  return (b.item_id > a.item_id)
end)

for i = 1, #itemEffects do
  local effect = itemEffects[i]

  item_map[i] = {
    itemID = effect.item_id,
    name = effect.item_id,
    description = {
      'Extra Gems: ' .. effect.extra_gems,
      'Extra XP: ' .. effect.extra_xp,
      ('One Hit: ' .. (effect.one_hit and 'Yes' or 'No')),
      'Break Range: ' .. effect.break_range,
      'Build Range: ' .. effect.build_range
    }
  }

  dialog[#dialog + 1] =
      ('add_button_with_icon|item_' .. i .. '||staticPurpleFrame|' .. effect.item_id .. '||')

  if i % 5 == 0 then
    dialog[#dialog + 1] = 'add_button_with_icon||END_LIST|noflags|0||'
  end
end

dialog[#dialog + 1] =
'add_button_with_icon||END_LIST||0||\nadd_quick_exit|\nend_dialog|assets_ui|Close||'


local function showAssetsDialog(world, player)
  player:onDialogRequest(table.concat(dialog, "\n"), 20, function(world, player, data)
    if data.dialog_name == "assets_ui" then
      local button = data.buttonClicked

      local r = button:match("role_(%d+)")
      if r then
        showRoleInfo(world, player, tonumber(r))
        return true
      end

      local it = button:match("item_(%d+)")
      if it then
        showItemInfo(world, player, tonumber(it))
        return true
      end
    end
  end)
end

function showItemInfo(world, player, idx) ---@diagnostic disable-line
  local info = item_map[idx]

  local ddd = {
    'set_bg_color|0,0,0,150|',
    'set_default_color|`o',
    'add_label_with_icon|big|Item Info|left|' .. info.itemID .. '|',
    'add_spacer|small|',
  }

  for i = 1, #info.description do
    ddd[#ddd + 1] = 'add_smalltext|' .. info.description[i] .. '|'
  end

  ddd[#ddd + 1] = 'add_spacer|small|'
  ddd[#ddd + 1] = 'add_custom_button|back|textLabel:Back;middle_colour:130154495;border_colour:130154495;|'
  ddd[#ddd + 1] = 'add_custom_break|\nadd_spacer|small|\nadd_quick_exit|\nend_dialog|item_info||'

  player:onDialogRequest(table.concat(ddd, "\n"), 20, function(world, player, e)
    if e.dialog_name == "item_info" then
      if e.buttonClicked == "back" then
        showAssetsDialog(world, player)
        return true
      end
    end
  end)
end

function showRoleInfo(world, player, idx) --- @diagnostic disable-line
  local info = role_map[idx]

  local ddd = {
    'set_bg_color|0,0,0,150|',
    'set_default_color|`o',
    'add_label|big|' .. info.roleName .. '|left|',
    'add_smalltext|price: ' .. (info.rolePrice > 0 and info.rolePrice .. ' ā' or 'nfs') .. '|',
    'add_spacer|small|'
  }

  if info.includes then
    ddd[#ddd + 1] = 'add_smalltext|`oIncludes commands from: `w' .. info.includes .. '|'
    ddd[#ddd + 1] = 'add_spacer|small|'
  end

  ddd[#ddd + 1] = 'add_label|small|`wAllowed Commands|left|'

  if info.commands and #info.commands > 0 then
    ddd[#ddd + 1] = 'add_smalltext|/' .. table.concat(info.commands, ', /') .. '|'
  else
    ddd[#ddd + 1] = 'add_smalltext|`oNo Commands|'
  end

  ddd[#ddd + 1] = 'add_spacer|small|'
  ddd[#ddd + 1] = 'add_label|small|`wPermission:|left|'

  if info.flags and #info.flags > 0 then
    for i = 1, #info.flags do
      ddd[#ddd + 1] = 'add_smalltext|`o- ' .. info.flags[i] .. '|'
    end
  else
    ddd[#ddd + 1] = 'add_smalltext|`oNo Flags|'
  end
  ddd[#ddd + 1] = 'add_custom_margin|x:0;y:8|'
  ddd[#ddd + 1] = 'add_custom_button|back|textLabel:Back;middle_colour:130154495;border_colour:130154495;|'
  if info.rolePrice ~= 0 then
    ddd[#ddd + 1] =
        string.format('add_custom_button|buy|textLabel:%sanchor:back;left:1.05;',
          not player:hasRole(info.id) and 'Purchase;middle_colour:431888895;border_colour:431888895;' or
          'Owned;middle_colour:0;border_colour:0;state:disabled;')
  end
  ddd[#ddd + 1] = 'add_custom_break|\nadd_quick_exit|\nend_dialog|role_info_' ..
      info.roleName .. '||'

  player:onDialogRequest(table.concat(ddd, '\n'), 20, function(world, player, eee)
    if eee['dialog_name'] == ('role_info_' .. info.roleName) then
      if eee['buttonClicked'] == 'back' then
        showAssetsDialog(world, player)
        return true
      elseif eee['buttonClicked'] == 'buy' then
        local price = info.rolePrice

        if price <= 0 then
          player:onTalkBubble(player:getNetID(), "This role is not for sale.", 0)
          return true
        end
        --- player:onConsoleMessage(tostring(info.id))
        if player:hasRole(info.id) then
          player:onTalkBubble(player:getNetID(), "You already have this role.", 0)
          return true
        end

        local gems = player:getCoins()
        if gems < price then
          player:onTalkBubble(player:getNetID(), "Not enough premium world lock.", 0)
          return true
        end


        player:removeCoins(price, 1)
        player:setRole(info.id)
        player:playAudio('achievement.wav')

        player:onTalkBubble(player:getNetID(),
          string.format("Successfully purchased role %s!", info.roleName),
          0
        )

        ---showAssetsDialog(world, player)
        return true
      end
    end
  end)
end

onPlayerCommandCallback(function(world, player, message)
  local cmd = message:match("^(%S+)")
  cmd = cmd:lower()
  if cmd == 'buy' or cmd == 'assets' then
    showAssetsDialog(world, player)
    return true
  end
end)
