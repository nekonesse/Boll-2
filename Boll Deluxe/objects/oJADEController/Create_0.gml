///@description Intialize
///Tools:
#macro EMPTY_SLOT -1
#macro SELECT_TOOL 0
#macro BRUSH_TOOL 1
#macro FILL_TOOL 2
#macro ERASE_TOOL 3
#macro PICKER_TOOL 4
#macro REFERENCE_TOOL 5
#macro ROTATE_TOOL 6
#macro MIRROR_TOOL 7
#macro FLIP_TOOL 8
#macro NODE_TOOL 9
#macro ROTATOR_TOOL 10
#macro LINK_TOOL 11

selected_mode=OBJECT_MODE;
selected_toolbar=0;
selected_tool=SELECT_TOOL;

reference_sprite = -1;
reference_sprite_element = -1;
reference_sprite_x = 0;
reference_sprite_y = 0;
reference_sprite_layer = layer_create(1000,"__JADEreferencesprite");

camera = view_camera[0]
guiw = window_get_width();
guih = window_get_height();
cursor_scale = max(min(floor(guiw/RESOLUTION_X),floor(guih/RESOLUTION_Y))/3,1)

camera_set_view_size(camera,guiw,guih);
view_set_wport(0,guiw)
view_set_hport(0,guih)

camera_set_view_pos(camera,0,room_height-camera_get_view_height(camera))

cam_x = camera_get_view_x(camera)
cam_y = camera_get_view_y(camera)
cam_w = camera_get_view_width(camera)
cam_h = camera_get_view_height(camera)

themeaccent1=scribble_rgb_to_bgr($0d1128)
themeaccent2=scribble_rgb_to_bgr($1c2348)
themeaccent3=scribble_rgb_to_bgr($3a4466)
themeaccent4=scribble_rgb_to_bgr($67739a)
themehighlight=c_white

clipboard = {};
clipboard.type = "none";
clipboard.contents = [];

JADE_initializeobj();

current_tileset="tTilesetMain"
deco_mode_type="";

GUIcanvas = surface_create(guiw,guih);

topbuttons = new JADEsmallbuttons(4,4,52,16)
topbuttons.add("File", function() {
	JADEdropdown(4,4+16,["New", "Open", "Open Autosave", "Save", "Save As", "Exit"], function(name,ind) {
		switch(ind) {
			case 0:
			//new file
				global.save_dir=""
				instance_destroy(oJADELayerProperties)
				var i=0;
				repeat(1) {
					ds_list_clear(object_layer_map[i])
					i++;
				}
				i=0
				repeat(1) {
					ds_list_clear(node_layer_map[i])
					i++;
				}
				
				current_tileset="tTilesetMain"
				deco_mode_type="";
				
				layerlist.wipe();
				layerlist.add(new JADElistunselectable("Objects"))
				layerlist.add(new JADElistunselectable("Piping Objects"))
				layerlist.add(new JADEtilelayer("Main Tiles", current_tileset))
				layerlist.add(new JADEbackgroundlayer("Main Tiles", obj_data[$ "spr_plains_bg_sky"]))
				layerlist.update_depths();
				
				object_place("oCollider",0,169*16,30,2)
				object_place("oPlayerSpawn",3*16,168*16,1,1)
			break;
			case 1:
			//open file
				var file = get_open_filename_ext("JADE File|*.jade", "", working_directory, "Load Level");
				if string_length(file) != 0 && (filename_ext(file) == ".jade") {
					global.save_dir=file
					JADE_load(file)
					displaytextdur=120;
					displaytext=$"Successfully open JADE file {filename_name(global.save_dir)}!"
					autosave_time = (60*30)
				}
			break;
			case 2:
			//open autosave file
				if (file_exists(game_save_id+"\\autosave.jade")) {
					global.save_dir=""
					JADE_load(game_save_id+"\\autosave.jade")
					displaytextdur=120;
					displaytext=$"Successfully opened autosave!"
					autosave_time = (60*30)
				} else {
					displaytextdur=120;
					displaytext=$"Autosave file not found."
				}
			break;
			case 3:
				if (global.save_dir != "") {
					displaytextdur=120;
					JADE_save(global.save_dir)
					displaytext=$"Successfully saved JADE file!"
				} else {
					var file = get_save_filename_ext("JADE File|*.jade", "", $"{working_directory}\mods\\level\\", "Save Level");
					if string_length(file) != 0 { 
						displaytextdur=120;
						global.save_dir=file
						JADE_save(file)
						displaytext=$"Successfully saved JADE file as {filename_name(global.save_dir)}!"
					}
				}
			break;
			case 4:
				var file = get_save_filename_ext("JADE File|*.jade", "", $"{working_directory}\mods\\level\\", "Save Level");
				if string_length(file) != 0 { 
					displaytextdur=120;
					global.save_dir=file
					JADE_save(file)
					displaytext=$"Successfully saved JADE file as {filename_name(global.save_dir)}!"
				}
			break;
			case 5:
			//exit editor
			room_goto(rMainMenu);
			global.jade_testing = false;
			break;
		}
		with(oJADEController) topbuttons.reset();
	})
});
topbuttons.add("Edit", function() {

});
topbuttons.add("View", function() {

});
topbuttons.add("Level", function() {
	with(oJADEGUIpar) {
		instance_destroy();
	}
	var inst = instance_create_depth(guiw/2,guih/2,oJADEController.depth-2,oJADELevelProperties)
	topbuttons.created_gui = inst;
});



selected_layer=noone
tilemap=-1;
tilemap_layer=-1;
layerlist = new JADElayerlisthandler(8,56,192-24,640, "selected_layer") 
layerlist.add(new JADElistunselectable("Objects"))
layerlist.add(new JADElistunselectable("Piping Objects"))
layerlist.add(new JADEtilelayer("Main Tiles", current_tileset))
layerlist.add(new JADEbackgroundlayer("Sky", obj_data[$ "spr_plains_bg_sky"]))
layerlist.update_depths();

update_layer = function(_layer) {
	var type=""
	if is_instanceof(_layer,JADEtilelayer) {
		current_tileset = _layer.tileset
		var info = tileset_get_info(_layer.tileset_info[1])
		default_grid_size = info.tile_width
		current_grid_size = default_grid_size
		tilemap=_layer.tilemap
		tilemap_layer=_layer.my_deco_layer
		type = "tile";
	} else if is_instanceof(_layer, JADEassetlayer) {
		type="asset";
	} else if is_instanceof(_layer, JADEbackgroundlayer) {
		type="background";
	}
	deco_mode_type=type;
}

modebuttons = new JADEsmallbuttons(272,4,86,16,8,false)
modebuttons.add("Object Mode", function() {
	selected_deco_obj = -1;
	drawing_node = -1;
	toolbarbuttons.set(toolbar[0])
	if (selected_mode != OBJECT_MODE) {
		selected_obj = -1;
		selected_tool = toolbarbuttons.buttons[0];
		selected_array = [];
	}
	with(layerlist) {
		var i=0;
		repeat(array_length(listcontents)) {
			var item = listcontents[i]
			if (is_instanceof(item, JADEtilelayer)) {
				layer_set_visible(item.my_layer, oJADEController.tile_layers_visible)
			} else if (is_instanceof(item, JADEassetlayer)) {
				layer_set_visible(item.my_layer, oJADEController.asset_layers_visible)
			} else if (is_instanceof(item, JADEtilelayer)) {
				layer_set_visible(item.my_layer, oJADEController.bg_layers_visible)
			}
			i++;
		}
	}
	selected_mode = OBJECT_MODE
	object_map = object_layer_map[selected_region]
});
modebuttons.add("Deco Mode", function() {
	drawing_node = -1;
	if is_instanceof(oJADEController.selected_layer,JADEtilelayer) {
		toolbarbuttons.set(toolbar[1])
		with(layerlist) {
			var i=0;
			repeat(array_length(listcontents)) {
				var item = listcontents[i]
				if (is_instanceof(item, JADEtilelayer)) {
					layer_set_visible(item.my_layer, oJADEController.tile_layers_visible)
				} else if (is_instanceof(item, JADEassetlayer)) {
					layer_set_visible(item.my_layer, oJADEController.asset_layers_visible)
				} else if (is_instanceof(item, JADEtilelayer)) {
					layer_set_visible(item.my_layer, oJADEController.tile_layers_visible)
				}
				i++;
			}
			layer_set_visible(oJADEController.selected_layer.my_layer, true)
		}
	} else if is_instanceof(oJADEController.selected_layer,JADEbackgroundlayer) {
		toolbarbuttons.set(toolbar[2])
		with(layerlist) {
			var i=0;
			repeat(array_length(listcontents)) {
				var item = listcontents[i]
				if (is_instanceof(item, JADEtilelayer)) {
					layer_set_visible(item.my_layer, oJADEController.tile_layers_visible)
				} else if (is_instanceof(item, JADEassetlayer)) {
					layer_set_visible(item.my_layer, oJADEController.asset_layers_visible)
				} else if (is_instanceof(item, JADEtilelayer)) {
					layer_set_visible(item.my_layer, oJADEController.tile_layers_visible)
				}
				i++;
			}
			layer_set_visible(oJADEController.selected_layer.my_layer, true)
		}
	} else if is_instanceof(oJADEController.selected_layer,JADEassetlayer) {
		toolbarbuttons.set(toolbar[3])
		with(layerlist) {
			var i=0;
			repeat(array_length(listcontents)) {
				var item = listcontents[i]
				if (is_instanceof(item, JADEtilelayer)) {
					layer_set_visible(item.my_layer, oJADEController.tile_layers_visible)
				} else if (is_instanceof(item, JADEassetlayer)) {
					layer_set_visible(item.my_layer, oJADEController.asset_layers_visible)
				} else if (is_instanceof(item, JADEtilelayer)) {
					layer_set_visible(item.my_layer, oJADEController.tile_layers_visible)
				}
				i++;
			}
			layer_set_visible(oJADEController.selected_layer.my_layer, true)
		}
	}
	if (selected_mode != DECO_MODE) {
		selected_obj = -1;
		selected_tool = toolbarbuttons.buttons[0];
		selected_array = [];
	}
	selected_mode = DECO_MODE
	update_layer(oJADEController.selected_layer)
	selected_obj = -1;
});
modebuttons.add("Gizmo Mode", function() {
	selected_deco_obj = -1;
	toolbarbuttons.set(toolbar[4])
	if (selected_mode != NODE_MODE) {
		selected_obj = -1;
		selected_tool = toolbarbuttons.buttons[0];
		selected_array = [];
	}
	with(layerlist) {
		var i=0;
		repeat(array_length(listcontents)) {
			var item = listcontents[i]
			if (is_instanceof(item, JADEtilelayer)) {
				layer_set_visible(item.my_layer, oJADEController.tile_layers_visible)
			} else if (is_instanceof(item, JADEassetlayer)) {
				layer_set_visible(item.my_layer, oJADEController.asset_layers_visible)
			} else if (is_instanceof(item, JADEtilelayer)) {
				layer_set_visible(item.my_layer, oJADEController.bg_layers_visible)
			}
			i++;
		}
	}
	selected_mode = NODE_MODE
	object_map = node_layer_map[selected_region]
});

modebuttons.selected_button = 0;

layeraddbutton = new JADEiconbutton(layerlist.x,layerlist.y+layerlist.height+16,spr_JADEaddicon,function() {
	JADEdropdown(layeraddbutton.x,layeraddbutton.y-56,["Add Tile Layer", "Add Asset Layer", "Add Background Layer"], function(optname,ind) {
		show_debug_message(ind)
		switch(ind) {
			case 0:
				var name = "New Layer 0"
				var i=0;
				var src=layerlist.get_contents();
				repeat (array_length(src)) {
					if layer_get_id(name)!=-1 {
						var name = "New Layer "+string(i)
					}
					i++;
				}
				layerlist.add(new JADEtilelayer(name,"tTilesetMain"))
			break;
			case 1:
				var name = "New Layer 0"
				var i=0;
				var src=oJADEController.layerlist.get_contents();
				repeat (array_length(src)) {
					if layer_get_id(name)!=-1 {
						var name = "New Layer "+string(i)
					}
					i++;
				}
				layerlist.add(new JADEassetlayer(name))
			break;
			case 2:
				var name = "New Layer 0"
				var i=0;
				var src=oJADEController.layerlist.get_contents();
				repeat (array_length(src)) {
					if layer_get_id(name)!=-1 {
						var name = "New Layer "+string(i)
					}
					i++;
				}
				layerlist.add(new JADEbackgroundlayer(name,-1))
			break;
		}
		layerlist.update_depths();
		layeraddbutton.reset();
	})
});

layerdeletebutton = new JADEiconbutton(layerlist.x+32,layerlist.y+layerlist.height+16,spr_JADEdeleteicon,function() {
	if !(is_struct(selected_layer)) {
		layerdeletebutton.reset();
		exit;
	}
	
	selected_layer.cleanup();
	array_delete(layerlist.listcontents,array_get_index(layerlist.listcontents,selected_layer),1);
	delete selected_layer;
	selected_layer = noone;
	instance_destroy(oJADELayerProperties);
	layerlist.update_depths();
	layerdeletebutton.reset();
	deco_mode_type="";
});

layereditbutton = new JADEiconbutton(layerlist.x+64,layerlist.y+layerlist.height+16,spr_JADEediticon,function() {
	if !(is_struct(selected_layer)) {
		layereditbutton.reset();
		exit;
	}
	
	with(oJADEGUIpar) {
		instance_destroy();
	}
	var inst = instance_create_depth(guiw/2,guih/2,oJADEController.depth-2,oJADELayerProperties)
	inst.selected_layer = selected_layer
	layereditbutton.created_gui = inst;
});

playtestbutton = new JADEiconbutton(196,26+36,spr_JADEplaytestbutton,function() {
	JADEdropdown(playtestbutton.x,playtestbutton.y+playtestbutton.height,oGlobals._charmList, function(optname,ind) {
		if ind!=-1 {
			JADE_save();
			global._playerChars=[oGlobals._charmList[ind]];
		
			global.nextlevel=game_save_id+"\save.jade" //the level the game will load
			global.jade_testing = true;
		
			i = 0;
			repeat(4) {
				global.lives[i]=5
				i++
			}
			room_goto(rGame)
		}
		playtestbutton.reset();
	})
});

tilepicker = new JADEtilepicker(guiw-216-14,56, 220, 320)

bgalignbuttons = new JADEsmallbuttons(guiw-216-14,550,52,16,8,false,false,true)
bgalignbuttons.add("Align X", function() {
	with(selected_layer) {
		off_x = other.cam_x+(other.cam_w/2)-(selected_bg.width/2);
		layer_x(my_layer,off_x);
	}
	bgalignbuttons.reset();
});

bgalignbuttons.add("Align Y", function() {
	with(selected_layer) {
		off_y = other.cam_y+(other.cam_h/2)-(selected_bg.height/2);
		layer_y(my_layer,off_y);
	}
	bgalignbuttons.reset();
});

objects_visible = true;
gizmos_visible = true;
tile_layers_visible = true;
asset_layers_visible = true;
bg_layers_visible = true;

objectvisibility = new JADEiconbutton(guiw-240-160,26+36,spr_JADElayerobjectvisibility, function() {
	objects_visible = !objects_visible
	objectvisibility.button_image_index = !objects_visible
}, true, false, true)

gizmovisibility = new JADEiconbutton(guiw-240-128,26+36,spr_JADElayergizmovisibility, function() {
	gizmos_visible = !gizmos_visible
	gizmovisibility.button_image_index = !gizmos_visible
}, true, false, true)

tilelayervisibility = new JADEiconbutton(guiw-240-96,26+36,spr_JADElayertilevisibility, function() {
	tile_layers_visible = !tile_layers_visible
	tilelayervisibility.button_image_index = !tile_layers_visible
	with(layerlist) {
		var i=0;
		repeat(array_length(listcontents)) {
			var item = listcontents[i]
			if (is_instanceof(item, JADEtilelayer)) {
				layer_set_visible(item.my_layer, oJADEController.tile_layers_visible)
			}
			i++;
		}
		if is_struct(oJADEController.selected_layer) && oJADEController.selected_mode == DECO_MODE
		layer_set_visible(oJADEController.selected_layer.my_layer, true)
	}
}, true, false, true)

assetlayervisibility = new JADEiconbutton(guiw-240-64,26+36,spr_JADElayerassetvisibility, function() {
	asset_layers_visible = !asset_layers_visible
	assetlayervisibility.button_image_index = !asset_layers_visible
	with(layerlist) {
		var i=0;
		repeat(array_length(listcontents)) {
			var item = listcontents[i]
			if (is_instanceof(item, JADEassetlayer)) {
				layer_set_visible(item.my_layer, oJADEController.asset_layers_visible)
			}
			i++;
		}
		if is_struct(oJADEController.selected_layer) && oJADEController.selected_mode == DECO_MODE
		layer_set_visible(oJADEController.selected_layer.my_layer, true)
	}
}, true, false, true)

bglayervisibility = new JADEiconbutton(guiw-240-32,26+36,spr_JADElayerbgvisibility, function() {
	bg_layers_visible = !bg_layers_visible
	bglayervisibility.button_image_index = !bg_layers_visible
	with(layerlist) {
		var i=0;
		repeat(array_length(listcontents)) {
			var item = listcontents[i]
			if (is_instanceof(item, JADEbackgroundlayer)) {
				layer_set_visible(item.my_layer, oJADEController.bg_layers_visible)
			}
			i++;
		}
		if is_struct(oJADEController.selected_layer) && oJADEController.selected_mode == DECO_MODE
		layer_set_visible(oJADEController.selected_layer.my_layer, true)
	}
}, true, false, true)

//Modes:
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
toolbar[0][4]=REFERENCE_TOOL
//Tile
toolbar[1][0]=SELECT_TOOL
toolbar[1][1]=BRUSH_TOOL
toolbar[1][2]=FILL_TOOL
toolbar[1][3]=ERASE_TOOL
toolbar[1][4]=PICKER_TOOL
toolbar[1][5]=ROTATE_TOOL
toolbar[1][6]=MIRROR_TOOL
toolbar[1][7]=FLIP_TOOL
toolbar[1][8]=REFERENCE_TOOL
//Background
toolbar[2][0]=SELECT_TOOL
toolbar[2][1]=REFERENCE_TOOL
//Asset
toolbar[3][0]=SELECT_TOOL
toolbar[3][1]=BRUSH_TOOL
toolbar[3][2]=ERASE_TOOL
toolbar[3][3]=PICKER_TOOL
toolbar[3][4]=MIRROR_TOOL
toolbar[3][5]=FLIP_TOOL
toolbar[3][7]=REFERENCE_TOOL
//Node
toolbar[4][0]=SELECT_TOOL
toolbar[4][1]=BRUSH_TOOL
toolbar[4][2]=ERASE_TOOL
toolbar[4][3]=NODE_TOOL
toolbar[4][4]=ROTATOR_TOOL
toolbar[4][5]=REFERENCE_TOOL

toolbarbuttons = new JADEtoolbar(196,26)

toolbarbuttons.set(toolbar[0])

selected_tile_layer=2;

not_on_gui = false

displaytext="";
displaytextdur=0;

is_typing = -1;
autosave_time = (60*30);

disable_tool = false;

default_grid_size = 16;
current_grid_size = default_grid_size;
changed_grid_size = false;

selection_grab = false;
selection_grab_x = 0;
selection_grab_y = 0;
selected_array = [];
selection_box = false;
selection_box_x = 0;
selection_box_y = 0;
resizing = 0;
resizing_x = 0;
resizing_y = 0;
resizing_x2 = 0;
resizing_y2 = 0;
resizing_initial_w=0;
resizing_initial_h=0;

current_tile_id[0][0] = 0
tile_drag = false;
tile_sel_width = 0
tile_sel_height = 0
tile_sel_last_x = 0
tile_sel_last_y = 0
tile_fill_last_x = 0
tile_fill_last_y = 0
tile_fill = false

selected_region = 0;
object_layer_map[0] = ds_list_create();
node_layer_map[0] = ds_list_create();
object_map = object_layer_map[0];

gotoroom=rGame

curs_x=mouse_x
curs_y=mouse_y

selected_obj=-1;
selected_deco_obj=-1;

view_grab=0 //view panning
view_grabx=0
view_graby=0
initial_viewx=0;
initial_viewy=0;

zoom_level = 1;
zoom_goto = 1;
zoom_x = 0;
zoom_y = 0;
ui_opacity = 0.5;

drawing_node=-1;
draw_node_x=0;
draw_node_y=0;

drawing_rotator=-1;
draw_rotator_x=0;
draw_rotator_y=0;

selection_box_fr=0

properties_tab_active = false;
property_dropdown_index = -1;
property_object_index = -1;

pressed_dropdown = false;

check_colliding_object = function(_x,_y,_map=object_map) {
	var i=0;
	repeat(ds_list_size(_map)) {
		var obj=_map[| i]
		var data = obj_data[$ obj[0]]
		if point_in_rectangle(_x,_y,obj[1],obj[2],obj[1]+(data.width*obj[3])-1,obj[2]+(data.height*obj[4])-1) {
			return i+1
		}
		i++;
	}
}

check_colliding_tile = function(_x, _y) {
	if !ds_exists(tilemap,ds_type_list) exit;
	
	var i=0;
	repeat(ds_list_size(tilemap)) {
		var tile=tilemap[| i]
		var tilesetinf = tileset_get_info(selected_layer.tileset_info[1])
		if point_in_rectangle(_x,_y,tile[1]*16,tile[2]*16,tile[1]*16+tilesetinf.tile_width,tile[2]*16+tilesetinf.tile_height) {
			return i+1
		}
		i++;
	}
}

check_colliding_asset = function(_x, _y) {
	if selected_layer == noone exit;
	if !ds_exists(selected_layer.assetmap,ds_type_list) exit;
	
	var i=0;
	repeat(ds_list_size(selected_layer.assetmap)) {
		var asset=selected_layer.assetmap[| i]
		var data = obj_data[$ asset[0]]
		var _sprite = asset_get_index(asset[0])
		var _ax = layer_sprite_get_x(asset[1]) - sprite_get_xoffset(_sprite)
		var _ay = layer_sprite_get_y(asset[1]) - sprite_get_yoffset(_sprite)
		var _width = data.width
		var _height = data.height
		if point_in_rectangle(_x,_y,_ax,_ay,_ax+_width,_ay+_height) {
			return i+1
		}
		i++;
	}
}

object_place = function(_uuid, _x, _y, _xscale, _yscale) {
	var obj = [_uuid, _x, _y, _xscale, _yscale]
	var data = obj_data[$ obj[0]]
	var arr = properties.getDefaultValues(_uuid)
	obj[5] = [];
	var o=0;
	repeat (array_length(arr)) { //god Damn.
		if is_array(arr[o]) {
			obj[5][o] = array_create(1,0)
			array_copy(obj[5][o],0,arr[o],0,array_length(arr[o]))
		}
		o++;
	}
	obj[6] = data.xoff;
	obj[7] = data.yoff;
	obj[8] = data.sizex;
	obj[9] = data.sizey;
	obj[10] = []; //nodes arr
	obj[11] = [2,0,false,false,false,true]; //node property arr
	obj[12] = []; //rotator arr
	obj[13] = [0,0,180,0,4,true,false,false]
	//add other data stuff here later
	ds_list_add(object_map, obj)
}

asset_place = function(_uuid, _x, _y, _xscale, _yscale, _layer=selected_layer) {
	var data = obj_data[$ _uuid];
	var inst = layer_sprite_create(_layer.my_layer,_x+data.xoff,_y+data.yoff,asset_get_index(_uuid));
	layer_sprite_xscale(inst,_xscale);
	layer_sprite_yscale(inst,_yscale);
	layer_sprite_speed(inst, 0);
	var obj = [_uuid, inst];
	var arr = properties.getDefaultValues(_uuid)
	obj[2] = [];
	var o=0;
	repeat (o < array_length(arr)) { //god Damn.
		if is_array(arr[o]) {
			obj[2][o] = array_create(1,0)
			array_copy(obj[2][o],0,arr[o],0,array_length(arr[o]))
		}
		o++;
	}
	//add other data stuff here later
	ds_list_add(_layer.assetmap, obj);
}


tile_update_properties = function() {
	if !ds_exists(tilemap,ds_type_list) exit;
	
	var list=tilemap
	var size = ds_list_size(list)
	var i=size-1;
	while (i > 0) {
		var data=list[| i]
		
		if is_undefined(data) {
			ds_list_delete(list,i)
			i--;
			continue
		}

		var fetched=tilemap_get(tilemap_layer,data[1],data[2])
		
		if (data[0]!=fetched) { //If data does not match the tile at place
			ds_list_delete(list, i) //remove if tile has changed
		} else if (tile_get_empty(data[0])) {
			ds_list_delete(list, i) //remove if tile is empty
		}
		
		i--;
	}
}


object_place("oCollider",0,169*16,30,2)
object_place("oPlayerSpawn",3*16,168*16,1,1)

JADE_load();