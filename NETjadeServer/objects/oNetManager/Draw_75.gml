draw_set_font(global.omiFont)
draw_text(2,2,$"Players connected: {ds_list_size(sockets)}")

var i = 0;
var key = ds_map_find_first(action_timers);
repeat(ds_map_size(action_timers)){
	draw_text(2,9 + (i * 8),$"Player: {action_timers[? key]}")
	key = ds_map_find_next(action_timers,key)
	i++;
}