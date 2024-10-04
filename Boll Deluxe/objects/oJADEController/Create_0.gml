///@description Intialize
///Tools:
#macro EMPTY_SLOT -1
#macro SELECT_TOOL 1 //region, object, background, node
#macro BRUSH_TOOL 2 //object, tile, background
#macro FILL_TOOL 3 //object, tile
#macro ERASE_TOOL 4 //object, tile, background, node
#macro PICKER_TOOL 5 //object, tile, background
#macro REFERENCE_TOOL 6 //object, tile, background, node
#macro REGION_TOOL 7 //region
#macro ROTATE_TOOL 8 //tile, background
#macro MIRROR_TOOL 9 //tile, background
#macro FLIP_TOOL 10 //tile, background
#macro COLOR_TOOL 11 //tile, background
#macro NODE_TOOL 12 //node

///Modes:
//0: Region
//1: Objects
//2: Tiles
//3: Backgrounds
//4: Nodes
//Mode is first, tool is second
//Region
toolbar[0][0]=SELECT_TOOL
toolbar[0][1]=REGION_TOOL
toolbar[0][2]=ERASE_TOOL
//Object
toolbar[1][0]=SELECT_TOOL
toolbar[1][1]=BRUSH_TOOL
toolbar[1][2]=FILL_TOOL
toolbar[1][3]=ERASE_TOOL
toolbar[1][4]=PICKER_TOOL
toolbar[1][5]=REFERENCE_TOOL
//Tile
toolbar[2][0]=BRUSH_TOOL
toolbar[2][1]=FILL_TOOL
toolbar[2][2]=ERASE_TOOL
toolbar[2][3]=PICKER_TOOL
toolbar[2][4]=ROTATE_TOOL
toolbar[2][5]=MIRROR_TOOL
toolbar[2][6]=FLIP_TOOL
toolbar[2][7]=COLOR_TOOL
toolbar[2][8]=REFERENCE_TOOL
//Background
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
toolbar[4][3]=ERASE_TOOL
toolbar[4][4]=REFERENCE_TOOL

JADE_initializeobj();

tile_layer = layer_get_id("EditorTiles_Main")
//tileset = tTilesetMain
tilemap = layer_tilemap_get_id(tile_layer)
object_layer_map = ds_list_create()
tile_layer_map = ds_list_create()

not_on_gui = false

//tile_layer_array[0,0]= 0

selected_mode=OBJECT_MODE;
selected_toolbar=0;
selected_tool=SELECT_TOOL;

selected_obj=ds_list_find_value(obj_name, 0)
selected_tile = 0
selection = false
selection_id = NaN
selection_x = [0]
selection_y = [0]
selection_box = false
selection_box_x = 0
selection_box_y = 0
temp_mode=0;
temp_toolbar=0;

for (var i = 0; i < array_length(jade_cats); i++) {
	current_obj_id[i] = 0
}
current_tile_id = 0

curs_x=mouse_x
curs_y=mouse_y

view_grab=0 //view panning
view_grabx=0
view_graby=0
initial_viewx=0;
initial_viewy=0;

zoom_level = 1;

//tileset picker
show_tileset = false
tileset_picker_x=250;
tileset_picker_y=100;

total_objects=0;

object_list = ds_list_create();

#region object list variables
var guiw=display_get_gui_width()
var guih=display_get_gui_height()

on_object_list=false
show_object_list=true
object_list_active = 1
properties_tab_active = 0

object_list_area_width = 96*3
object_list_area_height = 128*3
object_list_area_x = (guiw-object_list_area_width/3)
object_list_area_y = ((guih/2)-(object_list_area_height/3)/2)
object_list_area_surface = surface_create(object_list_area_width, object_list_area_height)

for (i = 0; i < array_length(jade_cats); i++) {
	object_list_scroll_pos[i] = 0
}

current_cat = 0
#endregion

function mouse_in_setting_slot(numb) {
	var guiw=display_get_gui_width();
	return point_in_rectangle(curs_x,curs_y,(guiw-28)-(32*numb),4,(guiw-28)-(32*numb)+24,28)
}

function mouse_in_toolbar_slot(numb) {
	var guiw=display_get_gui_width();
	if toolbar[selected_mode][numb] != EMPTY_SLOT
	return point_in_rectangle(curs_x,curs_y,(guiw-12)-(32*14)+(32*numb),4,(guiw-12)-(32*14)+(32*numb)+32,28)
	else return 0
}

function mouse_in_mode_slot(numb) {
	var guih=display_get_gui_height();
	return point_in_rectangle(curs_x,curs_y,4,((guih/4)-4)+32*numb,28,(((guih/4)-4)+32*numb)+24)
}

selection_box_fr=0
is_typing=0;
temptypingstring="";
open_dropmenu=0;

function tile_layer_alpha_check() {
	//This makes the tile layer transparent if you arent in tile mode by using layer scripts
	if oJADEController.selected_mode!=TILE_MODE {
		shader_set(shd_alpha)
		var alpha = shader_get_uniform(shd_alpha, "alpha");
		shader_set_uniform_f(alpha,0.33)
	}
}

function tile_layer_shader_reset() {
	shader_reset();
}
layer_script_begin(tile_layer, tile_layer_alpha_check);
layer_script_end(tile_layer, tile_layer_shader_reset);

//for updating tile properties like flip, mirror, rotate etc
function tile_update_properties() {
	var data = tilemap_get(tilemap, gridx, gridy)
	var array = [gridx, gridy]
	for (var i=0; i<ds_list_size(tile_layer_map); i++;) {
		show_debug_message(data)
		var array_catched = ds_list_find_value(tile_layer_map,i)
		var array_match= []
		array_match[0] = array_catched[1]
		array_match[1] = array_catched[2]
		show_debug_message($"{array}, {array_match}")
		if array_equals(array,array_match) {
			ds_list_set(tile_layer_map,i,[data, gridx, gridy])
			break;
		}
	}
}

//add preset layout
camera_set_view_pos(view_camera[0],0,room_height-camera_get_view_height(view_camera[0]))

ds_list_add(object_layer_map, ["oCollider", 0, 167, 30, 2, 0])//add object to list at place
var obj = ds_list_find_value(object_layer_map, ds_list_size(object_layer_map)-1)
var sprite = ds_map_find_value(obj_data,obj[0])
if !is_undefined(obj) {
	obj[6] = sprite[3]
	obj[7] = sprite[4]
	obj[8] = 0
	obj[9] = 0	
	obj[10] = []
	if is_array(sprite[8]) && array_length(sprite[8]) {
		for (var o = 0; o < array_length(sprite[8]); o++) { //god Damn.
			array_copy(obj[10][o],0,sprite[8][o],0,array_length(sprite[8][o]))
			if is_array(obj[10][o][5]) {
				array_copy(obj[10][o][5],0,sprite[8][o][5],0,array_length(sprite[8][o][5]))	
			}
		}
	}
}