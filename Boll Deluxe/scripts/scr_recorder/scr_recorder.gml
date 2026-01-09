function player_recorder_setup(){
	record_timer = 0;
	record_x = [];
	record_y = [];
	record_old_x = [];
	record_old_y = [];
	record_sprite = [];
	record_frame = [];
	record_xscale = [];
	record_yscale = [];
	record_angle = [];
}

function player_recorder(){
	//Add recorder timer
	record_timer += 1;
	var spr=oGameManager.PlayerColl.GetImageInfo(get_spriteindex())
	
	//Record position
	record_x[record_timer mod 60] = floor(x);
	record_y[record_timer mod 60] = floor(y);
	record_old_x[record_timer mod 60] = floor(xprevious);
	record_old_y[record_timer mod 60] = floor(yprevious);
	
	
	//Record animation
	record_sprite[record_timer mod 60] = spr;
	record_frame[record_timer mod 60] = frame;
	
	//Recording visual
	record_xscale[record_timer mod 60] = xsc;
	record_yscale[record_timer mod 60] = ysc;
	record_angle[record_timer mod 60] = sprite_angle;
	
}