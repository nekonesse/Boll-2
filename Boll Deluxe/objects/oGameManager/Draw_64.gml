///@description Game HUD
surface_set_target(HUDsurface);
draw_clear_alpha(c_black,0);

draw_set_font(global.smallBoldFont)
for (var i = 0; i < array_length(global._playerChars); ++i) {
	var spr=oGameManager.PlayerColl.GetImageInfo($"spr_{global._playerChars[i]}_HUDicon")
    if CollageIsImage(spr)
	CollageDrawImage(spr,0,12+18*i,21)
	var _lives=string_repeat("0", 2-string_length(string(global.lives[i]))) + string(global.lives[i])
	draw_text(19+24*i,19,$"*{_lives}")
	draw_text(6+24*i,2,string_lower(global._playerChars[i]))
}
draw_sprite(spr_coinhudicon,0,12,39)
var _coins=string_repeat("0", 3-string_length(string(global.coins_collected))) + string(global.coins_collected)
draw_text(19,38,$"*{_coins}")

surface_reset_target();

draw_surface_ext(HUDsurface,1,1,1,1,0,c_black,0.66)
draw_surface(HUDsurface,0,0)