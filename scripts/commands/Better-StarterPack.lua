print('(Better-StarterPack) for GTPS Cloud | by Nperma')

local Command = require('command-handler')

Command.register({
  name = 'starter',
  description = 'Get a better starter pack',
}, function(world, player, data)
  local args = data.args
  local dialog = {}

  if args[1] then
    local option = args[1]:lower()
    if not player:isDev() then
    elseif option == 'manage' then

    elseif option == 'test' then
    end
    return true
  end


  return true
end)
