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

///Modes:
//0: Region
//1: Objects
//2: Tiles
//3: Backgrounds
//4: Nodes
//Mode is first, tool is second
//Object
toolbar[0][0]=SELECT_TOOL
toolbar[0][1]=BRUSH_TOOL
toolbar[0][2]=ERASE_TOOL
toolbar[0][3]=PICKER_TOOL
//Tile
toolbar[1][0]=BRUSH_TOOL
toolbar[1][1]=ERASE_TOOL
toolbar[1][2]=PICKER_TOOL
toolbar[1][3]=ROTATE_TOOL
toolbar[1][4]=MIRROR_TOOL
toolbar[1][5]=FLIP_TOOL
//Node
toolbar[2][0]=SELECT_TOOL
toolbar[2][1]=BRUSH_TOOL
toolbar[2][2]=NODE_TOOL
toolbar[2][3]=ERASE_TOOL

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


not_on_gui = false

savetextdur=0;

selected_mode=OBJECT_MODE;
selected_toolbar=0;
selected_tool=SELECT_TOOL;

selected_obj=ds_list_find_value(obj_name, 1)
selection_id = NaN
selection_x = [0]
selection_y = [0]
selection_box = false
selection_box_x = 0
selection_box_y = 0
drawing_object=-1;
drawing_object_x=0;
drawing_object_y=0;

current_tile_id = 0
tile_drag = false;
tile_sel_width = 0
tile_sel_height = 0
tile_sel_last_x = 0
tile_sel_last_y = 0
tile_fill_last_x = 0
tile_fill_last_y = 0
tile_fill = false
fill_circle = false



curs_x=mouse_x
curs_y=mouse_y

view_grab=0 //view panning
view_grabx=0
view_graby=0
initial_viewx=0;
initial_viewy=0;

zoom_level = 1;
ui_opacity = 0.5;

drawing_node=-1;
draw_node_x=0;
draw_node_y=0;

drawing_rotator=-1;
draw_rotator_x=0;
draw_rotator_y=0;

#region tileset picker variables
var guiw=display_get_gui_width()
var guih=display_get_gui_height()

show_tileset = false
on_tile_picker = false
tile_zoom = 1;
tileset_picker_x = (guiw-(sprite_get_width(tilesets[$ current_tileset][0]) / 3))
tileset_picker_y = ((guih/2) - (sprite_get_height(tilesets[$ current_tileset][0]) / 3) /2) - 8
#endregion

object_list = ds_list_create();

#region object list variables
on_object_list=false
show_object_list=true
object_list_active = 1
properties_tab_active = 0

object_list_area_width = 96*3
object_list_area_height = 128*3
object_list_area_x = (guiw-object_list_area_width/3)
object_list_area_y = ((guih/2)-(object_list_area_height/3)/2)
object_list_area_surface = surface_create(object_list_area_width, object_list_area_height)

var i=0;
repeat (3) {
    var j=0;
	repeat (array_length(jade_cats[j])) {
		object_list_scroll_pos[i][j] = 0
		current_obj_id[i][j] = 0
		j++;
	}
	i++;
}
current_cat = 0
#endregion

mouse_in_toolbar_slot = function(numb) {
	var guiw=display_get_gui_width();
	if toolbar[selected_mode][numb] != EMPTY_SLOT
	return point_in_rectangle(curs_x,curs_y,(guiw-12)-(32*14)+(32*numb),4,(guiw-12)-(32*14)+(32*numb)+32,28)
	else return 0
}

mouse_in_mode_slot = function(numb) {
	var guih=display_get_gui_height();
	return point_in_rectangle(curs_x,curs_y,4,((guih/3)-4)+32*numb,28,((guih/3)-4+24)+32*numb)
}

selection_box_fr=0
is_typing=0;
temptypingstring="";
open_dropmenu=0;

var i=0;
repeat (array_length(tile_layer)) {
	layer_script_begin(layers[i], tile_layer_alpha_check);
	var shadreset = function() {
		shader_reset();
	}
	layer_script_end(layers[i], shadreset);
	i++;
}

//add preset layout
camera_set_view_pos(view_camera[0],0,room_height-camera_get_view_height(view_camera[0]))

place_object = function(uuid,_x,_y,xscale=1,yscale=1) {
	var sprite = ds_map_find_value(obj_data,uuid)
	ds_list_add(object_layer_map, [uuid, _x, _y, xscale*sprite[11], yscale*sprite[12], 0])//add object to list at place
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
	ds_list_add(node_layer_map, [uuid, _x, _y, xscale*sprite[11], yscale*sprite[12], 0])//add object to list at place
	var obj = ds_list_find_value(node_layer_map, ds_list_size(node_layer_map)-1)
	var sprite = ds_map_find_value(obj_data,uuid)
	if !is_undefined(obj) {
		obj[6] = sprite[3]*xscale
		obj[7] = sprite[4]*yscale
		obj[8] = (sprite[1] = 0) ? 0 : sprite[1] + (sprite[3]/2) * obj[3] 
		obj[9] = (sprite[2] = 0) ? 0 : sprite[2] + (sprite[4]/2) * obj[4]
		obj[3] = obj[8]
		obj[4] = obj[9]
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
	}
}

mouse_x_prev=mouse_x;
mouse_y_prev=mouse_y;
tool_previous=selected_tool;