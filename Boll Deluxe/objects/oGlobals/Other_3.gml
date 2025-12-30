global.settings[$ "keybinds"] = input_player_export()

var _json=json_stringify(global.settings); //compile all saved things
var save_file = buffer_create(string_byte_length(_json), buffer_grow, 1);
buffer_write(save_file, buffer_string, _json); //save compilation into a buffer
var compressed = buffer_compress(save_file, 0, buffer_tell(save_file))
buffer_save(compressed, game_save_id+"\settings.ini"); //save buffer into the save file
buffer_delete(save_file)
buffer_delete(compressed)

if file_exists(game_save_id+"\save.jade") file_delete(game_save_id+"\save.jade")