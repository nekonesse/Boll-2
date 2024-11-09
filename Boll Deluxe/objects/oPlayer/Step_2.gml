if !dead && !no_step {
	txr_exec(global.scripts[? $"{charmName}_endstep"]);
}

/// @description poly collision hell
player_poly_collision();