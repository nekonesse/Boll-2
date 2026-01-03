var guiw=camera_get_view_width(view_camera[0]);
var guih=camera_get_view_height(view_camera[0]);
draw_set_font(global.matosseFont)
//global.titlebigFont
var charm_text = global.animdat[0][0][$ "name"] + " IN: ... " 
var stage_name_text = text



//application_surface

if (counter < 180){
	asset_y[0] = max(asset_y[0] - 1.5, guih - sprite_get_height(spr_titlecard_1))
	asset_y[2] = min(asset_y[2] + 1, sprite_get_height(spr_titlecard_2) + 8)
	asset_x[1] = max(asset_x[1] - 2.5, guiw - sprite_get_width(spr_titlecard_sidebanner))
	asset_x[3] = min(asset_x[3] + 8, 5)
	
	if (counter > 25){
		oGameManager.fadeprog = min(oGameManager.fadeprog + 0.082, 3.0)
		if asset_x[4] < 96 {
		asset_x[4] += dcos(counter - 25) * 2
		} else {
			asset_x[4] += 1
		}
		if asset_x[5] > 256 {
			asset_x[5] -= dcos((counter- 25) * 1.2) * 6
		} else {
			asset_x[5] -= 1
		}
	}
	
	if counter > 45 {
		if (bounce_stages < 2) {
			counter_ball ++
		}
		switch bounce_stages {
			case 0:
			asset_y[6] = abs(dcos((counter_ball)*4)) * 256
			if counter_ball*4 >= 90 {
				bounce_stages += 1	
				//counter_ball = 90 
			}
			break;
			case 1:
			asset_y[6] = abs(dcos((counter_ball)*4)) * 75
			if counter_ball*4 >= 270 {
				bounce_stages += 1	
			}
			break;
		}
	}
} else {
	oGameManager.enable_app_surf_redraw = false
	if counter == 180 {
		oPlayer.input_enable = true	
		bounce_stages = 1
		//counter_ball = 270 / 4
	}
	asset_y[0] += 4 
	asset_y[2] -= 4
	asset_x[1] += 6
	asset_x[4] += 8
	asset_x[5] -= 8
	if (counter > 200) {
		asset_x[3] += 12
	}
	
	if asset_x[3] > guiw {
		instance_destroy()	
	}
	
	counter_ball--
	switch bounce_stages {
		case 0:
		asset_y[6] = abs(dcos((counter_ball)*4)) * 256
		if counter_ball*4 <= 0 {
			bounce_stages--	
			//counter_ball = 90 
		}
		break;
		case 1:
		asset_y[6] = abs(dcos((counter_ball)*4)) * 75
		if counter_ball*4 <= 90 {
			bounce_stages-- 	
		}
		break;
	}
}

/*

asset_x[2] = (asset_x[2] - 1) % string_width(charm_text)

draw_sprite_ext(spr_titlecard_checkerboard, 0,floor(asset_x[4]),0,1,1,0,c_white,0.4)
draw_sprite_ext(spr_titlecard_checkerboard, 0,floor(asset_x[5]),0,1,1,0,c_white,0.4)

draw_sprite(spr_titlecard_2,0,0,floor(asset_y[2]))

pal_swap_set(spr_matossepal,2,false)
draw_text(asset_x[2],floor(asset_y[2]) - 16, charm_text)
for (var i = 1; i < round(guiw/string_width(charm_text)) + 1; ++i) {
    draw_text(asset_x[2] + (string_width(charm_text) * i),floor(asset_y[2]) - 16, charm_text)
}
pal_swap_reset();

draw_sprite(spr_worldicon,0,floor(asset_x[3]),32)
draw_sprite_ext(spr_titlecard_levelnamebacking,0,floor(asset_x[3]),58, scribble(stage_name_text).get_width()/sprite_get_width(spr_titlecard_levelnamebacking),1,0,c_white,1)
draw_text_scribble(floor(asset_x[3])+ 12, 48, stage_name_text);

draw_sprite(spr_titlecard_sidebanner,0,floor(asset_x[1]),0)

draw_sprite(spr_titlecard_1,0,0,floor(asset_y[0]))

if counter > 45 {
	draw_sprite(spr_titlecard_lives,0,270,161-floor(asset_y[6]))
	draw_set_font(global.titlelivesFont)
	draw_text(287,180-floor(asset_y[6]), "x" + string(global.lives[0]))
}
draw_set_font(global.matosseFont)
draw_text(4,floor(asset_y[0]) + 35, "i dont know how to speak japanese!")
