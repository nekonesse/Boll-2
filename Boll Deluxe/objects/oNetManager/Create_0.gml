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
	if string_length(string_lettersdigits(global.username))<3 show_message("Username too short!")
	if string_length(string_lettersdigits(global.username))>18 show_message("Username too long!")
}
global.client = true;
global.socket = network_create_socket(network_socket_tcp);

connected=false;
cursors={};
cursorexclusion=0;
levelstruct={};

server=network_connect(global.socket, "68.10.90.59", PORT)
alarm[1]=500;
time=(60*60)