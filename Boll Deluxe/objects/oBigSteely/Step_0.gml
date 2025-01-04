ball_movement();
ball_interactions();
player_collision();

xsc=esign(hsp,xsc)

image_angle -= (hsp+gsp)*2

//image_speed=(hsp+gsp)*2

if place_meeting(x,y,oDeactivationRegion) && !on_screen_xy(sprite_width,sprite_height) {
	instance_destroy();
}