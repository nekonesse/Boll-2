egg = "3"

window_set_cursor(cr_none)

ysc = 0
xsc = 0
hsp = 0
frame = 0

if (egg == "3") {
	sprite_prefetch(sBlast1)
	
	game_set_speed(30,gamespeed_fps)
	sprite_index = sBlast1                       //the smaller the multiplier, the larger the image 
	ysc = sprite_get_height(sprite_index) * 1.75 //the division at draw makes it larger instead of smaller
	                                             //multiplying by 1 will stretch the image 3 times vertically
	xsc = sprite_get_width(sprite_index)
	hsp = sprite_get_info(sprite_index).num_subimages
}