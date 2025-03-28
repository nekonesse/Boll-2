var i=0;
var size = ds_map_size(action_timers);
var key = ds_map_find_first(action_timers);
repeat (size) {
	if action_timers[? key]>=0 {
		action_timers[? key]=max(action_timers[? key]-1,0);
		if !(action_timers[? key]) {
			action_timers[? key]=-1;
			var size = ds_map_size(clients);
			var key = ds_map_find_first(clients);
			repeat (size)
			{
			    if (ds_map_find_value(clients,key)!=sockets[| i])
			    {
			        key = ds_map_find_next(clients, key);
			    } else {
					action_amounts[? key]=5;
					var _struct = {
						type: "sync_actions",
						time: -1,
						actions: 5
					}
					send_struct(_struct, sockets[| i])
					break;
				}
				i++;
			}
		}
	}
	key = ds_map_find_next(clients, key);
	i++;
}