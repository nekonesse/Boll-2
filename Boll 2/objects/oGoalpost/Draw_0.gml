draw_self();

var signpost_side = 4;
var signpost_width = 22;
var signpost_side_width = 20;

var __signpost_y = round(signpost_y);

if (global.debug) {
	draw_text(x+24,__signpost_y,signpost_angle);
	draw_text(x+24,__signpost_y+12,signpost_spd);
	
	var x1 = x+24;
	var y1 = __signpost_y;
	var x2 = x1+lengthdir_x(12,signpost_angle);
	var y2 = y1+lengthdir_y(12,signpost_angle);
	
	draw_line(x1,y1,x2,y2);
}

#region Signpost
draw_sprite(spr_signpostoverlay,0,x,__signpost_y);

if !within(signpost_angle,345,365) && !within(signpost_angle,0,15) && !within(signpost_angle,165,195) {
	var _xsc = ternary(within(signpost_angle,90,270),-1,1);
	
	if within(signpost_angle,0,180) {
		//Left Side
		draw_sprite_ext(spr_signpostside,2,x + clamp(signpost_width * dsin(signpost_angle - 90),-signpost_side_width,signpost_side_width),__signpost_y,_xsc,1,0,c_white,1);
	} else {
		//Right Side
		draw_sprite_ext(spr_signpostside,0,x + clamp(signpost_width * dsin(signpost_angle + 90),-signpost_side_width,signpost_side_width),__signpost_y,_xsc,1,0,c_white,1);
	}
}

//Back Side
draw_sprite_ext(spr_signpostframe,0,x+signpost_side * dsin(signpost_angle),__signpost_y,max(dcos(signpost_angle), 0),1,0,c_white,1);
draw_sprite_ext(spr_signpostbowser,0,x+signpost_side * dsin(signpost_angle),__signpost_y,max(dcos(signpost_angle), 0),1,0,c_white,1);
//Front Side
draw_sprite_ext(spr_signpostframe,0,x+signpost_side * dsin(signpost_angle+180),__signpost_y,max(dcos(signpost_angle+180), 0),1,0,c_white,1);
if (CollageIsImage(signpost_sprite)) {
	CollageDrawImageExt(signpost_sprite,0,x+signpost_side * dsin(signpost_angle+180),__signpost_y,max(dcos(signpost_angle+180), 0),1,0,c_white,1);
}

if (signpost_angle > 75 && signpost_angle < 105) {
	//Left Side
	draw_sprite_ext(spr_signpostside,1,x + signpost_width * dsin(signpost_angle - 90),__signpost_y,1,1,0,c_white,1);
} else if (signpost_angle > 255 && signpost_angle < 285) {
	//Right Side
	draw_sprite_ext(spr_signpostside,1,x + signpost_width * dsin(signpost_angle + 90),__signpost_y,1,1,0,c_white,1);
}
#endregion

#region Bell
	var range = 25; // 15px, give or take
	draw_sprite_ext(spr_goalbell,0,x,bbox_top+4,1,1,sin(belltimer) * (range) * (clamp(belltimer, 0, (belltimer_max * 0.05)) / (60 * 0.05)), c_white, 1)
#endregion
