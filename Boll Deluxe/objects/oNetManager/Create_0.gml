#macro PORT 4126
global.username=""
var badname = false;
while string_length(string_lettersdigits(global.username))<3 || string_length(string_lettersdigits(global.username))>18 || (badname) {
	global.username=string_copy(get_string("What is your username?", ""),0,18)
	badname=false;
	var i=0;
	repeat(array_length(global.chatBannedWords)) {
		if string_count(global.chatBannedWords[i], global.username) {
			show_message("Inappropriate username!")
			badname=true;
			break;
		}
		i++;
	}
	if string_length(string_lettersdigits(global.username)) == 0 {
		game_end(); 
		return;
	}
	if string_length(string_lettersdigits(global.username))<3 show_message("Username too short!")
	if string_length(string_lettersdigits(global.username))>18 show_message("Username too long!")
}
global.client = true;
global.socket = network_create_socket(network_socket_tcp);
global.actions_left = 5;

connected=false;
cursors={};
cursorexclusion=0;
levelstruct={};

doing_ping = false
ping_time = 0
last_ping_time = 0
breaking_ping = 0

server=network_connect(global.socket, "localhost", PORT)
alarm[2]=60;
time=-1;