var buff=buffer_create(string_byte_length(UUID), buffer_grow, 1);
buffer_seek(buff, buffer_seek_start, 0);
buffer_write(buff, buffer_string, UUID);
var compressed=buffer_compress(buff, 0, buffer_tell(buff));
buffer_save(compressed, game_save_id+"/profile.uid");
buffer_delete(buff);
buffer_delete(compressed);