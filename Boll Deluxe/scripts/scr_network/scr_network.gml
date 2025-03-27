function send_struct(_struct, _socket) {
	var buff = buffer_create(16384, buffer_grow, 1)
	buffer_seek(buff, buffer_seek_start, 0);
	buffer_write(buff, buffer_string, json_stringify(_struct));
	network_send_packet(_socket, buff, buffer_tell(buff));
	buffer_delete(buff)
}