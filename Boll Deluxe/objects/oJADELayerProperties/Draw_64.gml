draw_gui(x-3,y-3,image_xscale+6,image_yscale+6,oJADEController.themeaccent4,1,true)

draw_rect(x-2,y+16,image_xscale+4,2,oJADEController.themeaccent3,1)

exitbutton.draw();

if !is_struct(selected_layer) exit;

draw_set_font(global.rulerGold)

if is_instanceof(selected_layer, JADEtilelayer) {
	draw_text(x,y+2,$"{selected_layer.name} - Tile Layer Properties")

	selected_layer.name = JADEstringinput(x,y+24,"Layer Name", selected_layer.name, 201,128)

	draw_set_font(global.rulerGold)

	draw_text(x,y+50,$"Tileset: {selected_layer.tileset_info[2]}")

	tilesetselector.draw();

	//preview
	var width = 256;
	var height = 256;
	draw_rect(x-1,y-1+86,width+2,height+2,c_white,1,true)
	draw_rect(x,y+86,width,height,oJADEController.themeaccent2,1,false)
		
	var scissor = gpu_get_scissor();
	gpu_set_scissor(x,y+86,width,height)
		
	draw_sprite(selected_layer.sprite,0,x,y+86)
	gpu_set_scissor(scissor);
}

if is_instanceof(selected_layer, JADEassetlayer) {
	
	draw_text(x,y+2,$"{selected_layer.name} - Asset Layer Properties")

	selected_layer.name = JADEstringinput(x,y+24,"Layer Name", selected_layer.name, 201,128)
	
	draw_set_font(global.rulerGold)
	
	selected_layer.parallax_x = JADEnumberinput(x,y+56,"Parallax X", selected_layer.parallax_x, 202)
	selected_layer.parallax_y = JADEnumberinput(x,y+86,"Parallax Y", selected_layer.parallax_y, 203)
}

if is_instanceof(selected_layer, JADEbackgroundlayer) {
	
	draw_text(x,y+2,$"{selected_layer.name} - Background Layer Properties")

	selected_layer.name = JADEstringinput(x,y+24,"Layer Name", selected_layer.name, 201,128)
	
	draw_set_font(global.rulerGold)
	
	var prev_parx = selected_layer.parallax_x
	var prev_pary = selected_layer.parallax_x
	var prev_tileh = selected_layer.tiled_h
	var prev_tilev = selected_layer.tiled_v
	var prev_attachx = selected_layer.attach_x
	var prev_attachy = selected_layer.attach_y
	
	selected_layer.parallax_x = JADEnumberinput(x,y+56,"Parallax X", selected_layer.parallax_x, 202)
	selected_layer.parallax_y = JADEnumberinput(x,y+86,"Parallax Y", selected_layer.parallax_y, 203)
	selected_layer.tiled_h = JADEcheckbox(x,y+116,"Tile Horizontally", selected_layer.tiled_h)
	selected_layer.tiled_v = JADEcheckbox(x,y+146,"Tile Vertically", selected_layer.tiled_v)
	selected_layer.attach_x = JADEcheckbox(x,y+176,"Attach X", selected_layer.attach_x)
	selected_layer.attach_y = JADEcheckbox(x,y+206,"Attach Y", selected_layer.attach_y)

	if (prev_parx!=selected_layer.parallax_x) 
	|| (prev_pary!=selected_layer.parallax_y)
	|| (prev_tileh!=selected_layer.tiled_h)
	|| (prev_tilev!=selected_layer.tiled_v) 
	|| (prev_attachx!=selected_layer.attach_x) 
	|| (prev_attachy!=selected_layer.attach_y) {
		selected_layer.update_settings();
	}
}