function parse_level(dir=working_directory+"\save.jade") {
	var file = dir
	if !file_exists(file) {
		throw "Level does not exist at given directory! make sure you've saved first!"
	}
	var save_file = file_text_open_read(file)
	show_debug_message($"Loading JADE level from: {file}")
	var size = unreal(file_text_read_string(save_file), 0) //read amount of objects
	file_text_readln(save_file)
	var tilesize = unreal(file_text_read_string(save_file), 0) //read amount of tiles
	file_text_readln(save_file)
	for (var i = 0; i < size; ++i) { //load objects
        var data = json_parse(file_text_read_string(save_file));
		show_debug_message($"Parsing JADE object with name: {data[0]}")
		var obj = instance_create_depth((data[1]*16), (data[2]*16), 0, asset_get_index(data[0]))
		obj.image_xscale=data[3]
		obj.image_yscale=data[4]
		obj.x+=sprite_get_xoffset(object_get_sprite(asset_get_index(data[0])));
		obj.y+=sprite_get_yoffset(object_get_sprite(asset_get_index(data[0])));
        file_text_readln(save_file);
		/*OBJECT STAT LIST
		 0: name
		 1: grid x
		 2: grid y
		 3: scale x
		 4: scale y
		 5: selected
		 6: box x
		 7: box y
		 8: offset x
		 9: offset y
		*/
	}
	var tile_layer = layer_get_id("Ground_Tiles")
	var tilemap = layer_tilemap_get_id(tile_layer)
    for (var i = 0; i < tilesize; ++i) { //loading tiles
		var data = json_parse(file_text_read_string(save_file));
		var tiledata = tilemap_get_at_pixel(tilemap, data[1], data[2]);
		tiledata = tile_set_index(tiledata, data[0])
		tilemap_set(tilemap, tiledata, data[1], data[2]) //set tile at place
		file_text_readln(save_file);
	}
	file_text_close(save_file);
	show_debug_message($"Successfully loaded JADE level from: {file}!")
}