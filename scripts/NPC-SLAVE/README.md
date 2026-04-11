# NPC-SLAVE

This documentation explains the concept and workflow of the `npc-slave.lua` script without publishing the full source code.

## Purpose

The script implements a temporary NPC summon system where players can summon an NPC by paying Gems. The NPC acts as a "slave" with assigned roles such as AutoFarmer, Harvester, and Planter.

## Main Features

- Player command: `summonnpc`
- Three NPC types:
  - `AutoFarmer`
  - `Harvester`
  - `Planter`
- Payment using Gems to summon NPCs
- NPCs use different outfits based on their type
- NPCs have a limited lifetime and expire automatically
- Players can manage summoned NPCs via wrench interaction
- NPC data is stored temporarily and saved during auto-save

## Workflow

1. When the script loads, NPC data is loaded from the server using `loadStringFromServer('npc-slave')`.
2. The `summonnpc` command opens a dialog for the player to choose the NPC type.
3. If the player selects an NPC and has enough Gems, the NPC is created at the player position.
4. The NPC is given a custom visual name and outfit based on its type.
5. On every world tick (`onWorldTick`), the script checks whether each NPC has expired.
6. If the NPC duration is over, the NPC is removed from the world and its internal data is cleaned up.
7. Players can open NPC management dialogs by wrenching their own NPC.
8. During auto-save, NPC data is saved back to the server.

## Data Structure

The script stores NPC data in a nested structure organized by:

- `world`
- `player`
- `npc_id`

Each NPC entry includes:

- NPC type
- NPC name
- enabled/disabled status
- selected target item
- spawn location
- despawn time

## Player Interaction

- `summonnpc`: opens the NPC selection dialog
- Choose a button to summon the desired NPC type
- The NPC appears at the player's location and remains active for a fixed duration
- Use a wrench on the NPC to open the management menu

## Development Notes

This documentation describes the creation and flow of the script. Possible enhancements include:

- Implementing actual NPC behavior for AutoFarmer, Harvester, and Planter
- Adding NPC inventory storage
- Limiting the number of NPCs per player or per world
- Adding notifications when NPC tasks are completed
- Adding NPC upgrade options

## Notes

- This script is intended for a world system that supports event hooks and custom dialogs.
- NPC data is stored on the server and reloaded when the script is active.
- The goal of this documentation is to describe the functionality without exposing the full implementation.
