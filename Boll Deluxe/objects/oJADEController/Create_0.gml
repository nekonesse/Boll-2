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

JADE_intializeobj();

tile_layer = layer_get_id("EditorTiles_Main")
//tileset = tTilesetMain
tilemap = layer_tilemap_get_id(tile_layer)
object_layer_map = ds_list_create()
tile_layer_map = ds_list_create()

not_on_gui = false

//tile_layer_array[0,0]= 0

selected_mode=0;
selected_toolbar=0;
selected_tool=SELECT_TOOL
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

current_obj_id = 0
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
list_area_width = 64
list_area_height = 96
list_area_x = 64
list_area_y = 96
list_area_surface = surface_create(list_area_width, list_area_height)
list_area_color = make_color_hsv(0, 0, 240)

list_text_color = make_color_hsv(0, 0, 40)

list_scroll_pos = 0
list_scroll_scale = max(0, list_area_height)
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

function tile_layer_alpha_check() {
	//This makes the tile layer transparent if you arent in tile mode by using layer scripts
	if oJADEController.selected_mode!=TILE_MODE {
		shader_set(shd_alpha)
		var alpha = shader_get_uniform(shd_alpha, "alpha");
		shader_set_uniform_f(alpha,0.33)
		show_debug_message($"Changing Tile Layer Alpha to {alpha}")
	}
}

function tile_layer_shader_reset() {
	shader_reset();
}
layer_script_begin(tile_layer, tile_layer_alpha_check);
layer_script_end(tile_layer, tile_layer_shader_reset);