//egg=string(floor(random(3) + 0.5)) sorry im disabling this for now because its unfinished and also might be a problem later on
if (egg == "3") {
	sprite_prefetch(sBlast1)
	
	game_set_speed(30,gamespeed_fps)
	sprite_index = sBlast1                       //the smaller the multiplier, the larger the image 
	ysc = sprite_get_height(sprite_index) * 1.75 //the division at draw makes it larger instead of smaller
	                                             //multiplying by 1 will stretch the image 3 times vertically
	xsc = sprite_get_width(sprite_index)
	hsp = sprite_get_info(sprite_index).num_subimages
}
//boll = makeboll()
bollStruct = {
	xsc : 1, 
	ysc : 1, 
	x : 0, 
	y : 0, 
	z : -32, 
	xsp : 0, 
	ysp : 0, 
	zsp : 0, 
	biggestZ : -40
}