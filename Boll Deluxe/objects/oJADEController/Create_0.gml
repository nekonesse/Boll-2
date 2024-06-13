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
toolbar[2][8]=COLOR_TOOL
toolbar[2][9]=REFERENCE_TOOL
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

selected_mode=0;
selected_toolbar=0;
selected_tool=SELECT_TOOL
temp_mode=0;
temp_toolbar=0;

curs_x=mouse_x
curs_y=mouse_y

function mouse_in_setting_slot(numb) {
	var guiw=display_get_gui_width();
	return point_in_rectangle(curs_x,curs_y,(guiw-28)-(32*numb),4,(guiw-28)-(32*numb)+24,28)
}

function mouse_in_mode_slot(numb) {
	var guih=display_get_gui_height();
	return point_in_rectangle(curs_x,curs_y,4,((guih/4)-4)+32*numb,28,(((guih/4)-4)+32*numb)+24)
}