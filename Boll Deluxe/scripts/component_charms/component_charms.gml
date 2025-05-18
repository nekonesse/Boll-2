function component_gravity_coneyor(){
	
	vsp = min(5.75, vsp + grav);
	canjump = max(0, canjump-1);
		
	// chearii: coneyor speed management
	if (abs(chsp * 100))
	{
		chsp *= 0.95;
			
		if (((chsp * 100) / 1) == 0)
		chsp = 0;
	}
}

function component_mario_crouch(){
	
	if (state == "") && (down) && !(piped) && !(skidding) {
			return true;
	} else {
		if (!check_collision_line(x-hit_sizex,y-hit_sizey-8,x+hit_sizex,y-hit_sizey-8,COL_TOP) || size=="basic") {
			return false;
		}
	}
}

function component_mario_skid(){
	
	if (((abs(gsp) >= 3) || skidding) && move != 0 && !check_signs_matching(gsp,move) && !crouch && !carrying) {
		if (!skidding) {
			skiddir = esign(move,xsc)
			dusttimer = 0;
			playsfx(charmName+"skid",1,1,0.75)
		}
		skidding = 1;
	}
	else if (skidding) {
		stopsfx(charmName+"skid")
		skidding=0
	}	
}

function component_mario_skidding_fx(){
	
	if ((ceil(abs(hsp))>3 || skidding) && grounded && state == "") {
	dusttimer = min(dusttimer + 1, (dusttimer + 1) mod 10);
		if (dusttimer == 1) {
			var part = pRunDust
			if (skidding) part = pSkidDust

			make_particle(part, x - (1 * xsc), y + hit_sizey, depth + 5, xsc, (2.25 - skidding) * -xsc, -0.1, -0.02, 0.2);
		}
	}
}

function component_mario_start_spinjump(startingJumpValue = 5.2){
	
	grounded=false;
	spinjump=1
	crouch=0
	playsfx(charmName+"spinjump")
	vsp=-(startingJumpValue+min(1,abs(hsp)/10))
	state = "jump"
	canstopjump=false
	make_particle(pJumpDust, x, y + hit_sizey, depth + 5, 1, 0, (y-yprevious)/1.5, 0, 0.2);
}

function component_mario_start_dive(speedX = 3.5, speedY = -2.7){
	
	stopsfx(charmName+"jump")
	crouch=0
	run=1.5
	runvar=1.5
	playsfx(charmName+"dive")
	make_particle(pSmoke, x, y, depth + 5, 1, 0.5*-xsc);
	vsp=-speedY
	hsp=speedX*esign(move,xsc)
	xsc=esign(move,xsc)
	state = "dive"
	canstopjump=false	
}

function component_mario_wallslide(slideSpeed = 1, jumpVSpeed = -5, jumpHSpeed = -2.5){
	
	vsp=slideSpeed;
	var coll=check_collision_line(x+((hit_sizex+1)*xsc),y-((hit_sizey-2)*ysc),x+((hit_sizex+1)*xsc),y-((hit_sizey-2)*ysc),COL_WALL)
	
	if (move == 0 || !coll){
		state = "";
	}
	
	if (apress) {
		hsp=esign(move,xsc)*jumpHSpeed
		frame=0;
		vsp=jumpVSpeed
		move=-move
		xsc=esign(hsp,xsc)
		no_move=true;
		alarm_set(2,12);
		playsfx(charmName+"jump",1,0,1)
		state = "jump";
		wallkick = true;
	}	
}

function component_mario_start_groundpound(){
	
		stopsfx(charmName+"jump")
		pound_timer = 10
		state = "pound"
		found_block = false;
		playsfx(charmName+"pound")
		pounding_block = true
}

function component_mario_groundpound(fallSpeed = 7){
	
	slopesliding = 0
	pound_timer = max(0,pound_timer-1);
	
	if (up) {
		state = "";
		pound_timer = 0;
	}
	
	if (pound_timer > 0) {
		hsp=0;
		grav=0;
		vsp = 0;
	} else {
		grav = defaultgrav;
		vsp = fallSpeed;
		pound_severity = vsp;
		hsp = 0;
	}
	
	//hittable block collision
	if (grounded) && (pound_timer <= 0) {
		var blocklist=ds_list_create();
		var num=collision_line_list(x-hit_sizex,y+hit_sizey+vsp+2,x+hit_sizex,y+hit_sizey+vsp+2, oHittable, false, true, blocklist, true)
		
		if (num > 0) {
			found_block = false;
			for (var i = 0; i < num; i+=1) {
				var blockcoll=ds_list_find_value(blocklist, i)
				if !(blockcoll.no_hit) && (pounding_block == true) && (blockcoll.amount != 0) {
					found_block=true;
					if (blockcoll.hit == 0) {
						signal_emit(blockcoll.blockHit, 1, id)
					}
				}
			}
			pounding_block = false
		}
		
		if !(found_block) {
			state = ""
			vsp = 0
			//create pound smoke
			make_particle(pSmoke, x-1, y + hit_sizey, depth + 5, 1, -3.25, -0.2, -0.04, 0.2);
			make_particle(pSmoke, x-1, y + hit_sizey, depth + 5, -1, 3.25, -0.2, -0.04, 0.2);
			pound_timer = 0;
		}
		
		if (down) {
			pounding_block = true
		}
		ds_list_destroy(blocklist)
	}
}

function component_sonic_start_spindash(){
	
	state = "spindash"
	spindashTotal = 0
	playsfx(charmName+"spindash",1+(spindashTotal/10))
}

function component_sonic_spindash(){
	
	no_move = true
	spindashTotal -= spindashTotal / 32
	if (apress || bpress || cpress) {
		frame = 0
		spindashTotal = min(spindashTotal + 2, 8)
		show_debug_message(spindashTotal)
		stopsfx(charmName+"spindash")
		playsfx(charmName+"spindash",1+(spindashTotal/10))
	}
		
	if (!down || !(abs(gsp) <= 0.5)) {
		state = "roll"
		gsp = (4 + (floor(spindashTotal) / 2.5)) * xsc
		//apply spindash speed based off amount of spindash presses
		stopsfx(charmName+"spindash")
		playsfx(charmName+"release")
	}
}

function component_sonic_start_jump(startingJumpValue = 6){
	
	state = "jump"
	grounded = false
	colangle = colangle * 0.9
	vsp = -startingJumpValue
	
	var vd=point_direction(0,0,hsp,vsp)+point_direction(0,0,1,colslope)
    var vm=point_distance(0,0,hsp,vsp)
    hsp=lengthdir_x(vm,vd)
    vsp=lengthdir_y(vm,vd)
    //adjust vsp and hsp to slope angle influence
	
	playsfx(charmName+"jump",1,0,1)
	canjump = 0;
	control_lock = 0;
}

function component_sonic_roll(){
	
	accel = 0
	if (sign(gsp) == move_dir) {
		if (sign(gsp) == -1){
			gsp = min(0, gsp + fric)
		}else{
			gsp = max(0, gsp - fric)
		}
	}
	fastaccel = 0.125
	fric = 0.0234375
	//taken from the sonic physics guide
	if abs(gsp) < 0.5 {
		state = ""
	}
}

function component_get_ground_friction(){
	
	if (grounded) {
		var i = instance_place(x, y + hit_sizey + 4,oCollider)
		if !is_undefined(i.my_friction) {
			friction_mult = i.my_friction;
		}
	}
}

function component_common_timer_values(){
	
	bonk=max(0,bonk-1)	
	grow = max(0, (grow - 1));
}
	