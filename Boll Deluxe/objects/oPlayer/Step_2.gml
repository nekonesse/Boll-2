if !dead && !no_step {
	catspeak_execute(global.scripts[? $"{charmName}_step_end"]);
}

/// @description poly collision hell
player_poly_collision();
player_grab();

if !(pollenated) && part_system_exists(pollenPart) {
	part_system_destroy(pollenPart)
}
player_recorder();