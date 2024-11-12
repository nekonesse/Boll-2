///@description Game HUD
if !surface_exists(HUDsurface) exit;

surface_set_target(HUDsurface);
draw_clear_alpha(c_black,0);

draw_set_font(global.smallBoldFont)
for (var i = 0; i < array_length(global._playerChars); ++i) {
	var spr=oGameManager.PlayerColl.GetImageInfo($"spr_{global._playerChars[i]}_HUDicon")
    if CollageIsImage(spr)
	CollageDrawImage(spr,0,16+18*i,27)
	var _lives=string_repeat("0", 2-string_length(string(global.lives[i]))) + string(global.lives[i])
	draw_text(24+24*i,25,$"*{_lives}")
	draw_text(10+24*i,8,string_lower(global._playerChars[i]))
}
draw_sprite(spr_coinhudicon,0,16,46)
var _coins=string_repeat("0", 3-string_length(string(global.coins_collected))) + string(global.coins_collected)
draw_text(24,44,$"*{_coins}")

surface_reset_target();

draw_surface_ext(HUDsurface,1,1,1,1,0,c_black,0.66)
draw_surface(HUDsurface,0,0)