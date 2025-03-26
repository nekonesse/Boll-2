#macro PORT 4126
room_goto(rEditor)

name=""
while string_length(string_lettersdigits(name))<3 {
	name=string_copy(get_string("What is your username?", ""),0,18)
	if string_length(string_lettersdigits(name))<3 show_message("Invalid username!")
}
global.client = true;
global.socket = network_create_socket(network_socket_tcp);
	
network_connect(global.socket, "68.10.90.59", PORT)