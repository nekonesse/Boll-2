#macro PORT 4126
#macro MAX_CLIENTS 10
global.onlinebuffer = buffer_create(16384, buffer_grow, 1)

server = network_create_server(network_socket_tcp, PORT, MAX_CLIENTS)
clients = ds_map_create();
sockets = ds_list_create();
room_goto(rEditor)