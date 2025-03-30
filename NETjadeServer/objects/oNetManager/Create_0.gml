#macro PORT 4126
#macro MAX_CLIENTS 1000
global.onlinebuffer = buffer_create(16384, buffer_grow, 1)

server = network_create_server(network_socket_tcp, PORT, MAX_CLIENTS)
clients = ds_map_create();
current_clients = ds_map_create();
action_timers = ds_map_create();
action_amounts = ds_map_create();
sockets = ds_list_create();
ips = ds_list_create();
cursors = {};
room_goto(rEditor)

exception_unhandled_handler(function(ex)
{
	VinylPlay(snd_gamecrash)
	
	var key = ds_map_find_first(clients);
	for (var i = 0; i < ds_map_size(clients); ++i) {
	    var _struct = {
				type: "server_crash"		
		}
		send_struct(_struct, clients[? key])
		key = ds_map_find_first(clients);
	}
	
    // Print some messages to the output log
    show_debug_message( "--------------------------------------------------------------");
    show_debug_message( "Unhandled exception " + string(ex) );
    show_debug_message( "--------------------------------------------------------------");
	
    // Show the error message (for debug purposes only)
    show_message(ex.longMessage);
	
    return 0;
});