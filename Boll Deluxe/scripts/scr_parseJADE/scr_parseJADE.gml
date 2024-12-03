function parse_level(dir="\save.jade") {
	var file = dir
	if !file_exists(file) {
		show_message($"Level does not exist at {dir}! make sure you've saved first!")
		room_goto(rMainMenu)
	}
	var loaded = buffer_load(file)
	var save_file = buffer_decompress(loaded)
	var array = json_parse(buffer_read(save_file,buffer_string))
	show_debug_message($"Loading JADE level from: {file}")
	var size = array_length(array[0]) //read amount of objects
	var nodesize = array_length(array[2]) //read amount of objects (on the node layer)
	var tilesize = array_length(array[1]) //read amount of tiles

	for (var i = 0; i < size; ++i) { //load objects
        var data = array[0][i]
		show_debug_message($"Parsing JADE object with name: {data[0]}")
		var obj = instance_create_depth((data[1]*16), (data[2]*16), 0, asset_get_index(data[0]))
		if instance_exists(obj) {
			obj.image_xscale=data[3]
			obj.image_yscale=data[4]
			obj.x+=sprite_get_xoffset(object_get_sprite(asset_get_index(data[0])))*obj.image_xscale;
			obj.y+=sprite_get_yoffset(object_get_sprite(asset_get_index(data[0])))*obj.image_yscale;
			if array_length(data[11]) {
				var temparr = []
				array_copy(temparr,0,data[11],0,array_length(data[11]))
				variable_instance_set(obj, "pathing", temparr);
				if is_array(data[12]) {
					variable_instance_set(obj, "pathspd", data[12][0]);
					variable_instance_set(obj, "pathcanrev", data[12][1]);
					variable_instance_set(obj, "pathnum", data[12][2]);
					variable_instance_set(obj, "pathcanfall", data[12][3]);
					variable_instance_set(obj, "pathdraw", data[12][4]);
					if array_length(data[12]) > 5
					variable_instance_set(obj, "pathstarted", data[12][5]);
					else variable_instance_set(obj, "pathstarted", true);
				}	
			}
			
			for (var j = 0; j < array_length(data[10]); j++) {
				if is_array(data[10][j]) {
					variable_instance_set(obj, data[10][j][0], data[10][j][2]);
					show_debug_message($"set object {obj} ({object_get_name(obj.object_index)})'s variable '{data[10][j][0]}' to '{data[10][j][2]}'.");
				}
			}
			with(obj) {event_user(15)}
		}
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
		 10: properties array
		*/
	}
	for (var i = 0; i < nodesize; ++i) { //load objects
        var data = array[2][i]
		show_debug_message($"Parsing JADE object with name: {data[0]}")
		var obj = instance_create_depth((data[1]*16), (data[2]*16), 0, asset_get_index(data[0]))
		if instance_exists(obj) {
			obj.image_xscale=data[3]
			obj.image_yscale=data[4]
			obj.x+=sprite_get_xoffset(object_get_sprite(asset_get_index(data[0])))*obj.image_xscale;
			obj.y+=sprite_get_yoffset(object_get_sprite(asset_get_index(data[0])))*obj.image_yscale;
			if array_length(data[11]) {
				var temparr = []
				array_copy(temparr,0,data[11],0,array_length(data[11]))
				variable_instance_set(obj, "pathing", temparr);
				if is_array(data[12]) {
					variable_instance_set(obj, "pathspd", data[12][0]);
					variable_instance_set(obj, "pathcanrev", data[12][1]);
					variable_instance_set(obj, "pathnum", data[12][2]);
					variable_instance_set(obj, "pathcanfall", data[12][3]);
					variable_instance_set(obj, "pathdraw", data[12][4]);
					if array_length(data[12]) > 5
					variable_instance_set(obj, "pathstarted", data[12][5]);
					else variable_instance_set(obj, "pathstarted", true);
				}	
			}
			
			for (var j = 0; j < array_length(data[10]); j++) {
				if is_array(data[10][j]) {
					variable_instance_set(obj, data[10][j][0], data[10][j][2]);
					show_debug_message($"set object {obj} ({object_get_name(obj.object_index)})'s variable '{data[10][j][0]}' to '{data[10][j][2]}'.");
				}
			}
			with(obj) {event_user(15)}
		}
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
		 10: properties array
		*/
	}
	if array_length(array) >= 4 {
		var tilelayersize = array_length(array[3]) //read amount of tile layers
		for (var i = 0; i < tilelayersize; ++i) {
			var tile_layer = layer_create(array[3][i][1],array[3][i][0])
			var tilemap = layer_tilemap_create(tile_layer,0,0,array[3][i][2],ceil(room_width/16),ceil(room_height/16))
			if array_length(array[1][i])
			for (var j = 0; j < array_length(array[1][i]); ++j) { //loading tiles
				var data = array[1][i][j]
				var tiledata = tilemap_get(tilemap, data[1], data[2]);
				tiledata = tile_set_index(tiledata, data[0])
				tilemap_set(tilemap, tiledata, data[1], data[2]) //set tile at place
			}
		}
	} else { //legacy tile conversion
		var tile_layer = layer_create(100,"MainTiles")
		var tilemap = layer_tilemap_create(tile_layer,0,0,tTilesetMain,ceil(room_width/16),ceil(room_height/16))
		for (var j = 0; j < array_length(array[1]); ++j) { //loading tiles
			var data = array[1][j]
			var tiledata = tilemap_get(tilemap, data[1], data[2]);
			tiledata = tile_set_index(tiledata, data[0])
			tilemap_set(tilemap, tiledata, data[1], data[2]) //set tile at place
		}
	}
	buffer_delete(loaded)
	buffer_delete(save_file)
	show_debug_message($"Successfully loaded JADE level from: {file}!")
}