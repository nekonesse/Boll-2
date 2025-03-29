var i=0;
var size = ds_map_size(action_timers);
var key = ds_map_find_first(action_timers);
repeat (size) {
	if action_timers[? key]>=0 {
		action_timers[? key]=max(action_timers[? key]-1,0);
		if !(action_timers[? key]) {
			action_timers[? key]=-1;
			action_amounts[? key]=5;
			var j=0;
			repeat (ds_list_size(sockets)){
			    if (ds_map_find_value(clients,key)==sockets[| j]) {
					var _struct = {
						type: "sync_actions",
						time: -1,
						actions: 5
					}
					send_struct(_struct, sockets[| j])
					break;
				}
				j++
			}
		}
	}
	key = ds_map_find_next(action_timers, key);
	i++;
}