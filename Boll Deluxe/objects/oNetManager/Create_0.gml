#macro PORT 4126
global.onlinebuffer = buffer_create(16384, buffer_grow, 1)

name=""
while string_length(string_lettersdigits(name))<3 {
	name=string_copy(get_string("What is your username?", ""),0,18)
	if string_length(string_lettersdigits(name))<3 show_message("Invalid username!")
}
global.client = true;
global.socket = network_create_socket(network_socket_tcp);
	
network_connect(global.socket, "127.0.0.1", PORT)

room_goto(rEditor)