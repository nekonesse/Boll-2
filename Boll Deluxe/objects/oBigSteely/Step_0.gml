ball_movement();
ball_interactions();
player_collision();

xsc=esign(hsp,xsc)

image_angle -= (hsp+gsp)*2

if collision_rectangle(x-hit_sizex,y-hit_sizey,x+hit_sizex,y+hit_sizey,oDeactivationRegion,false,true) && !on_screen(sprite_width,sprite_height) {
	instance_destroy();
}