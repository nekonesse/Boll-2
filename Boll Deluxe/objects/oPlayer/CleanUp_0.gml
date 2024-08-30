/// @description Insert description here
// You can write your code in this editor

for (var i = 0; i < array_length(global.powerups); i += 1) {
	if sprite_exists(player_sheets[$ global.powerups[i]]) {
		show_debug_message($"cleaned player sheet {charmName} {global.powerups[i]}")
		sprite_delete(player_sheets[$ global.powerups[i]])
	}
}
delete player_sheets;