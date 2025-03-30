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
refreshed_actions = 0;

server=network_connect(global.socket, "localhost", PORT)
alarm[2]=60;
time=-1;
UUID="";
if file_exists(game_save_id+"/profile.uid") {
	var loaded=buffer_load(game_save_id+"/profile.uid")
	var compressed=buffer_decompress(loaded);
	if (compressed==-1) {
		show_message("Error when recieving client UUID!\nTry deleting your profile.uid!");
		game_end(false);
	}
	UUID=buffer_read(compressed,buffer_string);
	buffer_delete(loaded)
	buffer_delete(compressed);
}
var _struct = {
	type: "join",
	_version: "afd2025",
	_uuid: UUID
}
send_struct(_struct, global.socket);

exception_unhandled_handler(function(ex)
{	
	var buff=buffer_create(string_byte_length(oNetManager.UUID), buffer_grow, 1);
	buffer_seek(buff, buffer_seek_start, 0);
	buffer_write(buff, buffer_string, oNetManager.UUID);
	var compressed=buffer_compress(buff, 0, buffer_tell(buff));
	buffer_save(compressed, game_save_id+"/profile.uid");
	buffer_delete(buff);
	buffer_delete(compressed);
	
    // Print some messages to the output log
    show_debug_message( "--------------------------------------------------------------");
    show_debug_message( "Unhandled exception " + string(ex) );
    show_debug_message( "--------------------------------------------------------------");
	
    // Show the error message (for debug purposes only)
    show_message(ex.longMessage);
	
    return 0;
});