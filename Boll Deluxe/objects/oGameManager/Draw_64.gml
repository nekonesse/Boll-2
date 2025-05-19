///@description Game HUD
if !surface_exists(HUDsurface) exit;
var guiw=camera_get_view_width(view_camera[0]);
var guih=camera_get_view_height(view_camera[0]);

surface_set_target(HUDsurface);
draw_clear_alpha(c_black,0);

draw_set_font(global.smallBoldFont)
var i=0;
repeat (array_length(global._playerChars)) {
	var spr=oGameManager.PlayerColl.GetImageInfo($"spr_{global._playerChars[i]}_HUDicon")
    if CollageIsImage(spr) {
		CollageDrawImage(spr,0,16+32*i,guih-16)
	}
	var _lives=string_repeat("0", 2-string_length(string(global.lives[i]))) + string(global.lives[i])
	draw_text(26+32*i,guih-16,$"*{_lives}")
	i++;
}
draw_sprite(spr_coinhudicon,0,16,16)
var _coins=string_repeat("0", 3-string_length(string(global.coins_collected))) + string(global.coins_collected)
draw_text(26,12,$"*{_coins}")

surface_reset_target();

draw_surface_ext(HUDsurface,1,1,1,1,0,c_black,0.66)
draw_surface(HUDsurface,0,0)