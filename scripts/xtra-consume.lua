local itemIDs = {
  -- key: itemID, value: maximumInput
  [5706] = true
}

onPlayerConsumableCallback(function(world, player, tile, clickedPlayer, itemID)
  if itemIDs[itemID] ~= nil then
    local amount = player:getItemAmount(itemID)
    player:onDialogRequest(table.concat({
      'set_default_color|`o',
      ('add_label_with_icon|big|Consume|left|' .. itemID .. '|'),
      'add_spacer|small|',
      'add_smalltext|`#(Input amount you want to consume)|',
      ('add_text_input|amount|amount|' .. amount .. '|3'),
      'add_spacer|small|',
      'add_button|submit|Submit|noflags|0|0|',
      'add_quick_exit|',
      'end_dialog|xtra_consume||'
    }, '\n'), 1, function(world, player, data)
      local inputAmount = tonumber(data[1]) or 1
      if inputAmount < 1 then
        inputAmount = 1
      end
      if inputAmount > amount then
        inputAmount = amount
      end
      for i = 1, inputAmount do
        world:useConsumable(player, tile, itemID, 1)
      end
      return true
    end)
    return true
  end
end)
