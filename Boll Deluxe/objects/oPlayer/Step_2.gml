if !dead && !no_step {
	txr_exec(global.scripts[? $"{charmName}_step_end"]);
}

/// @description poly collision hell
//player_poly_collision();

if !(pollenated) && part_system_exists(pollenPart) {
	part_system_destroy(pollenPart)
}