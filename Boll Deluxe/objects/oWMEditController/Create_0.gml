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
toolbar[0][2]=FILL_TOOL
toolbar[0][3]=ERASE_TOOL
toolbar[0][4]=PICKER_TOOL
toolbar[0][5]=REFERENCE_TOOL
//Tile
toolbar[1][0]=BRUSH_TOOL
toolbar[1][1]=FILL_TOOL
toolbar[1][2]=ERASE_TOOL
toolbar[1][3]=PICKER_TOOL
toolbar[1][4]=ROTATE_TOOL
toolbar[1][5]=MIRROR_TOOL
toolbar[1][6]=FLIP_TOOL
toolbar[1][7]=REFERENCE_TOOL
//Background
toolbar[2][0]=SELECT_TOOL
toolbar[2][1]=BRUSH_TOOL
toolbar[2][2]=ERASE_TOOL
toolbar[2][3]=PICKER_TOOL
toolbar[2][4]=MIRROR_TOOL
toolbar[2][5]=FLIP_TOOL
toolbar[2][6]=COLOR_TOOL
toolbar[2][7]=REFERENCE_TOOL
//Asset
toolbar[3][0]=SELECT_TOOL
toolbar[3][1]=BRUSH_TOOL
toolbar[3][2]=ERASE_TOOL
toolbar[3][3]=PICKER_TOOL
toolbar[3][4]=MIRROR_TOOL
toolbar[3][5]=FLIP_TOOL
toolbar[3][6]=COLOR_TOOL
toolbar[3][7]=REFERENCE_TOOL
//Node
toolbar[4][0]=SELECT_TOOL
toolbar[4][1]=BRUSH_TOOL
toolbar[4][2]=NODE_TOOL
toolbar[4][3]=ROTATOR_TOOL
toolbar[4][4]=ERASE_TOOL
toolbar[4][5]=REFERENCE_TOOL

WM_initializeobj();

tilesets={}
tilesets[$ "tTilesetMain"]=[spr_TilesetMain, tTilesetMain, "Floragrande Tiles"]
tilesets[$ "tTilesetPipes"]=[spr_TilesetPipes, tTilesetPipes, "Pipe Tiles"]
tilesets[$ "tTilesetMainDeco"]=[spr_TilesetMainDeco, tTilesetMainDeco, "Floragrande Decoration"]
tilesets[$ "tTilesetWorld5"]=[spr_TilesetWorld5, tTilesetWorld5, "Frigid Dark Tiles"]
selected_tileset=0;
current_tileset="tTilesetMain"

layers[0]=layer_create(-200,"EditorTiles_FG")
layers[1]=layer_create(-100,"EditorTiles_FGDeco")
layers[2]=layer_create(100,"EditorTiles_Main")
layers[3]=layer_create(150,"EditorTiles_Misc")
layers[4]=layer_create(200,"EditorTiles_Deco")
layers[5]=layer_create(300,"EditorTiles_Semi")
layers[6]=layer_create(400,"EditorTiles_BG")

tile_layer[0] = layer_tilemap_create(layers[0],0,0,asset_get_index(current_tileset),ceil(room_width/16),ceil(room_height/16))
tile_layer[1] = layer_tilemap_create(layers[1],0,0,asset_get_index(current_tileset),ceil(room_width/16),ceil(room_height/16))
tile_layer[2] = layer_tilemap_create(layers[2],0,0,asset_get_index(current_tileset),ceil(room_width/16),ceil(room_height/16))
tile_layer[3] = layer_tilemap_create(layers[3],0,0,asset_get_index(current_tileset),ceil(room_width/16),ceil(room_height/16))
tile_layer[4] = layer_tilemap_create(layers[4],0,0,asset_get_index(current_tileset),ceil(room_width/16),ceil(room_height/16))
tile_layer[5] = layer_tilemap_create(layers[5],0,0,asset_get_index(current_tileset),ceil(room_width/16),ceil(room_height/16))
tile_layer[6] = layer_tilemap_create(layers[6],0,0,asset_get_index(current_tileset),ceil(room_width/16),ceil(room_height/16))
selected_tile_layer=2;
tilemap = tile_layer[2]
object_layer_map = ds_list_create()
node_layer_map = ds_list_create()

not_on_gui = false

savetextdur=0;

selected_mode=OBJECT_MODE;
selected_toolbar=0;
selected_tool=SELECT_TOOL;

selected_obj=ds_list_find_value(obj_name, 0)
selection = false
selection_id = NaN
selection_x = [0]
selection_y = [0]
selection_box = false
selection_box_x = 0
selection_box_y = 0
temp_mode=0;
temp_toolbar=0;

current_tile_id[0][0] = 0
tile_drag = false;
tile_sel_width = 0
tile_sel_height = 0
tile_sel_last_x = 0
tile_sel_last_y = 0
tile_fill_last_x = 0
tile_fill_last_y = 0
tile_fill = false

gotoroom=rWorldMap

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
var guiw=window_get_width()
var guih=window_get_height()

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
repeat (NODE_MODE+1) {
    var j=0;
	repeat (array_length(jade_cats)) {
		object_list_scroll_pos[i][j] = 0
		current_obj_id[i][j] = 0
		j++;
	}
	i++;
}
current_cat = 0
#endregion

mouse_in_setting_slot = function(numb) {
	var guiw=window_get_width();
	return point_in_rectangle(curs_x,curs_y,(guiw-28)-(32*numb),4,(guiw-28)-(32*numb)+24,28)
}

mouse_in_toolbar_slot = function(numb) {
	var guiw=window_get_width();
	if toolbar[selected_mode][numb] != EMPTY_SLOT
	return point_in_rectangle(curs_x,curs_y,(guiw-12)-(32*14)+(32*numb),4,(guiw-12)-(32*14)+(32*numb)+32,28)
	else return 0
}

mouse_in_mode_slot = function(numb) {
	var guih=window_get_height();
	return point_in_rectangle(curs_x,curs_y,4,((guih/4)-4)+32*numb,28,(((guih/4)-4)+32*numb)+24)
}

selection_box_fr=0
is_typing=0;
temptypingstring="";
open_dropmenu=0;

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
	ds_list_add(object_layer_map, [uuid, _x, _y, xscale, yscale, 0])//add object to list at place
	var obj = ds_list_find_value(object_layer_map, ds_list_size(object_layer_map)-1)
	var sprite = ds_map_find_value(obj_data,obj[0])
	if !is_undefined(obj) {
		obj[6] = sprite[3]*xscale //set correct hitbox for the collider
		obj[7] = sprite[4]*yscale //set correct hitbox for the collider
		obj[8] = 0
		obj[9] = 0
		obj[10] = []
		obj[11] = []
		obj[12] = [2,false,0,false,true,true] //node properties
		obj[13] = [];
		obj[14] = [2,false,false,false] //rotator properties
		if is_array(sprite[8]) && array_length(sprite[8]) {
			var o=0;
			repeat (o < array_length(sprite[8])) { //god Damn.
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

tile_update_properties = function() {
	var i=0;
	var list=tile_layer_map[selected_tile_layer]
	while (i < ds_list_size(list)) {
		var data=list[| i]
		if data==undefined {
			ds_list_delete(list,i) 
			continue
		}
		
		var fetched=tilemap_get(tilemap,data[1],data[2])
		show_debug_message($"checked: {data[0]} got: {fetched}")
		
		if (data[0]!=fetched) { //If data does not match the tile at place
			ds_list_delete(list, i) //remove if tile has changed
			continue
		}
		i++;
	}
}