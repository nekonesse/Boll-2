#region Scaler drawing
if array_length(selected_array)==1 {
	switch(selected_mode) {
		case OBJECT_MODE:
		case NODE_MODE:
			var obj=object_map[| selected_array[0]]
			var data=obj_data[$ obj[0]]
			if (resizing != 1)
			draw_sprite(spr_JADE4scaler,0,obj[1],obj[2])
			else draw_sprite_ext(spr_JADE4scaler,0,obj[1],obj[2],1.5,1.5,0,c_white,1)
			if (resizing != 2)
			draw_sprite(spr_JADE4scaler,1,obj[1]+(data.width*obj[3]),obj[2])
			else draw_sprite_ext(spr_JADE4scaler,1,obj[1]+(data.width*obj[3]),obj[2],1.5,1.5,0,c_white,1)
			if (resizing != 3)
			draw_sprite(spr_JADE4scaler,2,obj[1],obj[2]+(data.height*obj[4]))
			else draw_sprite_ext(spr_JADE4scaler,2,obj[1],obj[2]+(data.height*obj[4]),1.5,1.5,0,c_white,1)
			if (resizing != 4)
			draw_sprite(spr_JADE4scaler,3,obj[1]+(data.width*obj[3]),obj[2]+(data.height*obj[4]))
			else draw_sprite_ext(spr_JADE4scaler,3,obj[1]+(data.width*obj[3]),obj[2]+(data.height*obj[4]),1.5,1.5,0,c_white,1)
		break;
		case DECO_MODE:
			if (deco_mode_type == "asset") {
				var asset=selected_layer.assetmap[| selected_array[0]]
				var data = obj_data[$ asset[0]]
				var _sprite = asset_get_index(asset[0]);
				var _xsc = layer_sprite_get_xscale(asset[1]);
				var _ysc = layer_sprite_get_yscale(asset[1]);
				var _ax = layer_sprite_get_x(asset[1]) - (sprite_get_xoffset(_sprite) * _xsc);
				var _ay = layer_sprite_get_y(asset[1]) - (sprite_get_yoffset(_sprite) * _ysc);
				var _width = data.width * _xsc
				var _height = data.height * _ysc
				if (resizing != 1)
				draw_sprite(spr_JADE4scaler,0,_ax,_ay)
				else draw_sprite_ext(spr_JADE4scaler,0,_ax,_ay,1.5,1.5,0,c_white,1)
				if (resizing != 2)
				draw_sprite(spr_JADE4scaler,1,_ax+_width,_ay)
				else draw_sprite_ext(spr_JADE4scaler,1,_ax+_width,_ay,1.5,1.5,0,c_white,1)
				if (resizing != 3)
				draw_sprite(spr_JADE4scaler,2,_ax,_ay+_height)
				else draw_sprite_ext(spr_JADE4scaler,2,_ax,_ay+_height,1.5,1.5,0,c_white,1)
				if (resizing != 4)
				draw_sprite(spr_JADE4scaler,3,_ax+_width,_ay+_height)
				else draw_sprite_ext(spr_JADE4scaler,3,_ax+_width,_ay+_height,1.5,1.5,0,c_white,1)
			}
		break;
	}
}
#endregion

if (selected_mode == DECO_MODE && array_length(selected_array)) {
	switch(deco_mode_type) {
		case "tile":
			if !(selection_grab) {
				var i=0
				repeat(array_length(selected_array)) {
					var tile = ds_list_find_value(tilemap,selected_array[i])
					draw_rect(tile[1]*16,tile[2]*16,16,16,$ff5a2a,0.5)
					i++;
				}
			} else {
				var i=0
				repeat(array_length(selected_array)) {
					var tile = ds_list_find_value(tilemap,selected_array[i])
					var x_diff = (tile[1]*16 - selection_grab_x)
					var y_diff = (tile[2]*16 - selection_grab_y)
					draw_tile(selected_layer.tileset_info[1],tile[0],0,floor((mouse_x+x_diff)/16)*16,floor((mouse_y+y_diff)/16)*16)
					draw_rect(floor((mouse_x+x_diff)/16)*16,floor((mouse_y+y_diff)/16)*16,16,16,$ff5a2a,0.5)
					i++;
				}
			}
		break;
		case "asset":
			var i=0
			repeat(array_length(selected_array)) {
				var asset=selected_layer.assetmap[| selected_array[i]]
				var data = obj_data[$ asset[0]]
				var _sprite = asset_get_index(asset[0]);
				var _xsc = layer_sprite_get_xscale(asset[1]);
				var _ysc = layer_sprite_get_yscale(asset[1]);
				var _ax = layer_sprite_get_x(asset[1]) - (sprite_get_xoffset(_sprite) * _xsc);
				var _ay = layer_sprite_get_y(asset[1]) - (sprite_get_yoffset(_sprite) * _ysc);
				var _width = data.width * _xsc
				var _height = data.height * _ysc
				draw_rect(_ax,_ay,_width,_height,$ff5a2a,0.5)
				i++;
			}
		break;
	}
}

#region Cursor Drawing
//Draw object
if (not_on_gui && !disable_tool) {
	switch(selected_mode) {
		case OBJECT_MODE:
		case NODE_MODE:
		if (selected_tool == BRUSH_TOOL || selected_tool == FILL_TOOL) {
			var obj = selected_obj
			var drawx = gridx*current_grid_size
			var drawy = gridy*current_grid_size
			if (is_struct(obj)) {
				draw_sprite_ext(obj.sprite,0,drawx+obj.xoff,drawy+obj.yoff,(1*obj.sizex),(1*obj.sizey),0,c_white,0.5);
			}
		}
		break;
		case DECO_MODE:
		if (selected_tool == BRUSH_TOOL || selected_tool == FILL_TOOL) && !tile_fill {
			switch(deco_mode_type) {
				case "tile":
					var t_spr = global.tilesets[$ current_tileset][0]
					var t_width = sprite_get_width(t_spr)
					var i=0;
					repeat(tile_sel_width+1) {
						var j=0;
						repeat(tile_sel_height+1) {
							var _data = current_tile_id[i][j]
							if _data != 0 {
								var t_x = ((_data mod (t_width / 16)) * 16)
								var t_y = (floor(_data / (t_width/16)) * 16)
								draw_sprite_part_ext(t_spr, 0, t_x, t_y, 16, 16, (gridx+i)*16,(gridy+j)*16, 1, 1, c_white, 0.25)	
							}
							j++;
						}
						i++;
					}
				break;
				case "asset":
					var obj = selected_deco_obj
					var drawx = gridx*current_grid_size
					var drawy = gridy*current_grid_size
					if (is_struct(obj)) {
						draw_sprite_ext(obj.sprite,0,drawx+obj.xoff,drawy+obj.yoff,(1*obj.sizex),(1*obj.sizey),0,c_white,0.5);
					}
				break;
			}
		}
		break;
	}
	
	//reference tool sprite outline
	if (selected_tool == REFERENCE_TOOL) && sprite_exists(reference_sprite) {
		var width = sprite_get_width(reference_sprite)
		var height = sprite_get_height(reference_sprite)
		if (point_in_rectangle(mouse_x,mouse_y,reference_sprite_x,reference_sprite_y,reference_sprite_x+width,reference_sprite_y+height)) {
			draw_rect(reference_sprite_x,reference_sprite_y,width,height,$54b9fb,1,true);
		}
	}
}
#endregion

if (drawing_node) {
	
}

if keyboard_check_pressed(vk_f5) show_debug_message(selected_array)