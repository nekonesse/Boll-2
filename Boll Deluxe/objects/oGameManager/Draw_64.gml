///@description Game HUD

var guiw = window_get_width();
var guih = window_get_height();
if !os_is_paused() && guiw>0 && guih>0 {
	if !surface_exists(HUDsurface) {
		HUDsurface=surface_create(RESOLUTION_X,RESOLUTION_Y)
	}
	if !surface_exists(gameoversurface) {
		gameoversurface=surface_create(RESOLUTION_X,RESOLUTION_Y)
	}
}

var guiw=RESOLUTION_X;
var guih=RESOLUTION_Y;

if surface_exists(HUDsurface) {
	surface_set_target(HUDsurface);
	draw_clear_alpha(c_black,0);

	var yy = 16;
	var xx = 26;
	
	var yoff = 4*(HUDcoinflash/2)
	
	draw_set_font(global.hudFont);
	draw_set_valign(fa_center);
	
	//Coins
	draw_sprite(spr_coinhudicon,0,16,yy)
	var _coins=string_replace_all(string_format(global.coins_collected,3,0)," ","0");
	draw_text(xx,yy-yoff+2,$"x{_coins}");
	if (HUDcoinflash > 0.0) {
		draw_text_color(xx,yy-yoff+2,$" {_coins}",c_yellow,c_yellow,c_yellow,c_yellow,HUDcoinflash);
	}
	
	HUDcoinflash=max(HUDcoinflash-0.1,0);
	
	//Timer
	var time_sec = floor(game_timer);
	var time_csec = floor(game_timer * 100);
	var minute = string_format(time_sec div 60 mod 60,2,0);
	var second = string_format(time_sec mod 60,2,0);
	var centisecond = string_format(time_csec mod 100,2,0);
	var timestr = string_replace_all(minute + ":" + second + ":" + centisecond," ","0");
	var timewidth = string_width(timestr);
	draw_text(guiw-timewidth-8,yy,timestr);
	draw_sprite(spr_clockhudicon,0,guiw-timewidth-20,yy);
	
	//Lives
	yy += 24;
	
	var i=0;
	repeat (array_length(global._playerChars)) {
		var spr=oGameManager.PlayerColl.GetImageInfo($"spr_{global._playerChars[i]}_HUDicon")
	    if CollageIsImage(spr) {
			CollageDrawImage(spr,0,16+32*i,yy)
		}
		var _lives=string_replace_all(string_format(global.lives[i],2,0)," ","0");
		draw_text(xx+32*i,yy+2,$"x{_lives}");
		i++;
	}
	
	//Item Reserve
	yy += 24;
	
	if (reserved_item != noone) {
		var sprite = object_get_sprite(reserved_item);
		
		if (reserved_item == oThunderFlower) {
			pal_swap_set(spr_thunderflowerpal,1,false);
		}

		var scale = (1*reserve_timer);
		
		draw_sprite_ext(sprite,0,xx-4,yy,1-scale,1-scale,0,c_white,1);
		
		if (reserved_item == oThunderFlower) {
			pal_swap_reset();
		}
	}
	
	draw_sprite(spr_huditemreserve,0,xx-4,yy);
	draw_sprite(spr_Vbuttonprompt,bool(reserved_item==noone),xx-4+10,yy+10)

	surface_reset_target();
	draw_set_valign(fa_top);
	
	draw_surface_ext(HUDsurface,1,1,1,1,0,c_black,0.66);
	draw_surface(HUDsurface,0,0)
}

if (surface_exists(gameoversurface)) {
	draw_surface(gameoversurface,0,0)
	surface_set_target(gameoversurface);
	draw_clear_alpha(c_black, 0);
	surface_reset_target()
}
