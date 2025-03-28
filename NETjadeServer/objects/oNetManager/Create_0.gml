#macro PORT 4126
#macro MAX_CLIENTS 1000
global.onlinebuffer = buffer_create(16384, buffer_grow, 1)

server = network_create_server(network_socket_tcp, PORT, MAX_CLIENTS)
clients = ds_map_create();
current_clients = ds_map_create();
action_timers = ds_map_create();
action_amounts = ds_map_create();
sockets = ds_list_create();
cursors = {};
room_goto(rEditor)