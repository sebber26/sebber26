local util = require("util")

local created_items = function()
  return
  {
    ["iron-plate"] = 8,
    ["wood"] = 1,
    ["pistol"] = 1,
    ["firearm-magazine"] = 10,
    ["burner-mining-drill"] = 1,
    ["stone-furnace"] = 1
  }
end

local respawn_items = function()
  return
  {
    ["pistol"] = 1,
    ["firearm-magazine"] = 10
  }
end

local on_player_created = function(event)
  local player = game.players[event.player_index]
  util.insert_safe(player, global.created_items)

  local r = global.chart_distance or 200
  player.force.chart(player.surface, {{player.position.x - r, player.position.y - r}, {player.position.x + r, player.position.y + r}})

  if not global.skip_intro then
    if game.is_multiplayer() then
      player.print({"msg-intro"})
    else
      game.show_message_dialog{text = {"msg-intro"}}
    end
  end
end

local on_player_respawned = function(event)
  local player = game.players[event.player_index]
  util.insert_safe(player, global.respawn_items)
end

local freeplay = {}

freeplay.events =
{
  [defines.events.on_player_created] = on_player_created,
  [defines.events.on_player_respawned] = on_player_respawned,
}

freeplay.on_configuration_changed = function(event)
  global.created_items = global.created_items or created_items()
  global.respawn_items = global.respawn_items or respawn_items()
end

freeplay.on_init = function()
  global.created_items = created_items()
  global.respawn_items = respawn_items()
end

freeplay.add_remote_interface = function()
  remote.add_interface("freeplay",
  {
    get_created_items = function()
      return global.created_items
    end,
    set_created_items = function(map)
      global.created_items = map
    end,
    get_respawn_items = function()
      return global.respawn_items
    end,
    set_respawn_items = function(map)
      global.respawn_items = map
    end,
    set_skip_intro = function(bool)
      global.skip_intro = bool
    end,
    set_chart_distance = function(value)
      global.chart_distance = tonumber(value)
    end
  })
end

return freeplay
