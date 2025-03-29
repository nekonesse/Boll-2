///@description Intialize
///Tools:
#macro EMPTY_SLOT -1
#macro SELECT_TOOL 1 //region, object, background, node
#macro BRUSH_TOOL 2 //object, tile, background
#macro FILL_TOOL 3 //object, tile
#macro ERASE_TOOL 4 //object, tile, background, node
#macro PICKER_TOOL 5 //object, tile, background
#macro REFERENCE_TOOL 6 //object, tile, background, node
#macro ROTATE_TOOL 7 //tile, background
#macro MIRROR_TOOL 8 //tile, background
#macro FLIP_TOOL 9 //tile, background
#macro COLOR_TOOL 10 //tile, background
#macro NODE_TOOL 11 //node
#macro ROTATOR_TOOL 12 //region

JADE_initializeobj();

tilesets={}
tilesets[$ "tTilesetMain"]=[spr_TilesetMain, tTilesetMain, "Floragrande Tiles"]
tilesets[$ "tTilesetPipes"]=[spr_TilesetPipes, tTilesetPipes, "Pipe Tiles"]
tilesets[$ "tTilesetMainDeco"]=[spr_TilesetMainDeco, tTilesetMainDeco, "Floragrande Decoration"]
tilesets[$ "tTilesetWorld5"]=[spr_TilesetWorld5, tTilesetWorld5, "Frigid Dark Tiles"]
selected_tileset=0;
current_tileset="tTilesetMain"

layers[0]=layer_create(-100,"EditorTiles_FGDeco")
layers[1]=layer_create(-200,"EditorTiles_FG")
layers[2]=layer_create(100,"EditorTiles_Main")
layers[3]=layer_create(150,"EditorTiles_Misc")
layers[4]=layer_create(200,"EditorTiles_Deco")
layers[5]=layer_create(300,"EditorTiles_Semi")
layers[6]=layer_create(400,"EditorTiles_BG")

tile_layer[0] = layer_tilemap_create(layers[0],0,0,tTilesetMain,ceil(room_width/16),ceil(room_height/16))
tile_layer[1] = layer_tilemap_create(layers[1],0,0,tTilesetMain,ceil(room_width/16),ceil(room_height/16))
tile_layer[2] = layer_tilemap_create(layers[2],0,0,tTilesetMain,ceil(room_width/16),ceil(room_height/16))
tile_layer[3] = layer_tilemap_create(layers[3],0,0,tTilesetPipes,ceil(room_width/16),ceil(room_height/16))
tile_layer[4] = layer_tilemap_create(layers[4],0,0,tTilesetMainDeco,ceil(room_width/16),ceil(room_height/16))
tile_layer[5] = layer_tilemap_create(layers[5],0,0,tTilesetMain,ceil(room_width/16),ceil(room_height/16))
tile_layer[6] = layer_tilemap_create(layers[6],0,0,tTilesetMain,ceil(room_width/16),ceil(room_height/16))
selected_tile_layer=2;
tilemap = tile_layer[2]
object_layer_map = ds_list_create()
node_layer_map = ds_list_create()

savetextdur=0;

curs_x=mouse_x
curs_y=mouse_y

view_grab=0 //view panning
view_grabx=0
view_graby=0
initial_viewx=0;
initial_viewy=0;

zoom_level = 1;

var i=0;
repeat (array_length(tile_layer)) {
	tile_layer_map[i]=ds_list_create();
	layer_script_begin(layers[i], tile_layer_alpha_check);
	var shadreset = function() {
		shader_reset()
	}
	layer_script_end(layers[i], shadreset);
	i++;
}

//add preset layout
camera_set_view_pos(view_camera[0],0,room_height-camera_get_view_height(view_camera[0]))

place_object = function(uuid,_x,_y,xscale=1,yscale=1) {
	var sprite = ds_map_find_value(obj_data,uuid)
	ds_list_add(object_layer_map, [uuid, _x, _y, ((xscale*16)/sprite[3])*sprite[11], ((yscale*16)/sprite[4])*sprite[12], 0])//add object to list at place
	var obj = ds_list_find_value(object_layer_map, ds_list_size(object_layer_map)-1)
	if !is_undefined(obj) {
		obj[6] = sprite[3]*xscale
		obj[7] = sprite[4]*yscale
		obj[8] = (sprite[1] = 0) ? 0 : sprite[1] + (sprite[3]/2) * obj[3] 
		obj[9] = (sprite[2] = 0) ? 0 : sprite[2] + (sprite[4]/2) * obj[4]
		obj[10] = []
		obj[11] = []
		obj[12] = [2,false,0,false,true,true] //node properties
		if is_array(sprite[8]) && array_length(sprite[8]) {
			var o=0;
			repeat (array_length(sprite[8])) { //god Damn.
				if is_array(sprite[8][o]) {
					obj[10][o] = array_create(1,0)
					array_copy(obj[10][o],0,sprite[8][o],0,array_length(sprite[8][o]))
					if is_array(sprite[8][o][4]) {
						obj[10][o][4] = array_create(1,0)
						array_copy(obj[10][o][4],0,sprite[8][o][4],0,array_length(sprite[8][o][4]))	
					}
				}
				o++;
			}
		}
	}
}

place_node_object = function(uuid,_x,_y,xscale=1,yscale=1) { 
	var sprite = ds_map_find_value(obj_data,uuid)
	ds_list_add(node_layer_map, [uuid, _x, _y, xscale*sprite[11], yscale*sprite[12], 0])//add object to list at place
	var obj = ds_list_find_value(node_layer_map, ds_list_size(node_layer_map)-1)
	if !is_undefined(obj) {
		obj[6] = sprite[3]*xscale
		obj[7] = sprite[4]*yscale
		obj[8] = (sprite[1] = 0) ? 0 : sprite[1] + (sprite[3]/2) * obj[3] 
		obj[9] = (sprite[2] = 0) ? 0 : sprite[2] + (sprite[4]/2) * obj[4]
		obj[10] = []
		obj[11] = []
		obj[12] = [2,false,0,false,true,true] //node properties
		if is_array(sprite[8]) && array_length(sprite[8]) {
			var o=0;
			repeat(array_length(sprite[8])) { //god Damn.
				if is_array(sprite[8][o]) {
					obj[10][o] = array_create(1,0)
					array_copy(obj[10][o],0,sprite[8][o],0,array_length(sprite[8][o]))
					if is_array(sprite[8][o][4]) {
						obj[10][o][4] = array_create(1,0)
						array_copy(obj[10][o][4],0,sprite[8][o][4],0,array_length(sprite[8][o][4]))	
					}
				}
				o++;
			}
		}
	}
}

place_tile = function(_id,_layer,_x,_y) {
	var data = tilemap_get(tile_layer[_layer], _x, _y)
	if tile_get_index(data) != _id { //prevent tile overlapping (mainly a problem with the list)
		data = tile_set_index(data, _id)
		data = tile_set_flip(data, 0)
		data = tile_set_mirror(data, 0)
		data = tile_set_rotate(data, 0)
		tilemap_set(tile_layer[_layer], data, _x, _y);
		ds_list_add(tile_layer_map[_layer], [data, _x, _y])
		tile_update_properties(_layer);
	}
}

tile_update_properties = function(_layer) {
	var i=0;
	var list=tile_layer_map[_layer]
	while (i < ds_list_size(list)) {
		var data=list[| i];
		if data==undefined {
			ds_list_delete(list,i) 
			continue
		}
		
		var fetched=tilemap_get(tile_layer[_layer],data[1],data[2])
		
		if (data[0]!=fetched) { //If data does not match the tile at place
			ds_list_delete(list, i) //remove if tile has changed
			continue
		}
		i++;
	}
}

place_object("oCollider",0,167,30,2)
place_object("oPlayerSpawn",3,166)