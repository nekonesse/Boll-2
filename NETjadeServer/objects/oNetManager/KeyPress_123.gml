var _struct = {
	type: "server_disconnect"
};
var i=0;
repeat(ds_list_size(sockets)) {
	var p=sockets[| i]
	send_struct(_struct, p)
	i++;
}

game_end(false);