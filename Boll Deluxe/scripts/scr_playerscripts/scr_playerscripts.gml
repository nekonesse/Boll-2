function skin_setting(_sett) {
	var File =file_text_open_read($"{working_directory}/_vanilla/character/{charmName}/config.ini");
		
	var Line =file_text_read_string(File);
	while (!string_starts_with(Line, _sett+"=")) && !string_starts_with(Line,";") && (!file_text_eof(File)) {
		file_text_readln(File);
		Line =file_text_read_string(File);
	}
	
	if string_starts_with(Line,";") {
		file_text_close(File);
		return 0
	}
	var _string = string_delete(Line, 1, string_length(_sett+"="));
		
	file_text_close(File);
		
	return unreal(_string,0);
}

function skin_getstring(_sett) {
	var File =file_text_open_read($"{working_directory}/_vanilla/character/{charmName}/config.ini");
		
	var Line =file_text_read_string(File);
	while (!string_starts_with(Line, _sett+"=")) && !string_starts_with(Line,";") && (!file_text_eof(File)) {
		file_text_readln(File);
		Line =file_text_read_string(File);
		if (file_text_eof(File) && !string_pos(_sett+"=",Line)) {
			file_text_close(File);
			return ""
		}
	}
	if string_starts_with(Line,";") {
		file_text_close(File);
		return ""
	}	
	var _string = string_delete(Line, 1, string_length(_sett+"="));
		
	file_text_close(File);
		
	return _string
}

function skin_getarray(_sett) {
	var File =file_text_open_read($"{working_directory}/_vanilla/character/{charmName}/config.ini");
	var Line =file_text_read_string(File);
	while (!string_starts_with(Line, _sett+"=")) && !string_starts_with(Line,";") && (!file_text_eof(File)) {
		file_text_readln(File);
		Line =file_text_read_string(File);
	}
	if (!file_text_eof(File)) {
		file_text_readln(File);
		var _string = string_delete(Line, 1, string_length(_sett+"="));
		file_text_close(File);
		return split_string(_string,",");
	}
	if string_starts_with(Line,";") {
		file_text_close(File);
		return ""
	}
	file_text_close(File);
}

function config_setting(_sett, dir) {
	var File =file_text_open_read($"{dir}/config.ini");
		
	var Line =file_text_read_string(File);
	while (!string_starts_with(Line, _sett+"=")) && !string_starts_with(Line,";") && (!file_text_eof(File)) {
		file_text_readln(File);
		Line =file_text_read_string(File);
	}
		
	var _string = string_delete(Line, 1, string_length(_sett+"="));
		
	file_text_close(File);
		
	return unreal(_string,0);
}

function config_getstring(_sett, dir) {
	var File =file_text_open_read($"{dir}/config.ini");
		
	var Line =file_text_read_string(File);
	while (!string_starts_with(Line, _sett+"=")) && !string_starts_with(Line,";") && (!file_text_eof(File)) {
		file_text_readln(File);
		Line =file_text_read_string(File);
	}
	if (file_text_eof(File) && !string_pos(_sett+"=",Line)) {
		file_text_close(File);
		return ""
	}
	if string_starts_with(Line,";") {
		file_text_close(File);
		return ""
	}
		
	var _string = string_delete(Line, 1, string_length(_sett+"="));
		
	file_text_close(File);
		
	return _string
}

function config_getarray(_sett, dir) {
	var File =file_text_open_read($"{dir}/config.ini");
	var Line =file_text_read_string(File);
	while (!string_starts_with(Line, _sett+"=")) && !string_starts_with(Line,";") && (!file_text_eof(File)) {
		file_text_readln(File);
		Line =file_text_read_string(File);
	}
	if (!file_text_eof(File)) {
		file_text_readln(File);
		var _string = string_delete(Line, 1, string_length(_sett+"="));
		file_text_close(File);
		return split_string(_string,",");
	}
	if string_starts_with(Line,";") {
		file_text_close(File);
		return ""
	}
	file_text_close(File);
}

function get_spriteindex() { //returns the sprite name of the player's current sprite
	var mem=size;
	
	if (grow && (global.roomTimer mod 6 > 3)) {
		size = oldsize;
	}
	
	var spritedat = global.animdat[pNum][0]
	
	var sprite_yank = size
	if !is_undefined(spritedat[$ $"{size} override"])
	sprite_yank = spritedat[$ $"{size} override"]
	var _getspr=spritedat[$ $"{sprite_yank} {spriteEvent}"]
	var spr=$"spr_{charmName}_{sprite_yank}_{_getspr}"
	
	if (size != mem) {
		size = mem;
	}
	
	return spr
}

function get_size() { //returns the array index of the player's current sprite
	var mem = size;
	
	if (grow && (global.roomTimer mod 6 < 3)) {
		mem = oldsize;
	}
	
	return mem;
}

function skin_animationdata(slot,name,list) {
	var t,spr;

	var j=0;
	repeat (array_length(global.powerups)) {
		var sprite_yank = global.powerups[j]
		var spritedat = global.animdat[pNum][0]
		var animdat = global.animdat[pNum][1]
		if spritedat[$ $"{global.powerups[j]} override"] != undefined {
			sprite_yank = spritedat[$ $"{global.powerups[j]} override"]
		}
		var g=0;
		repeat (array_length(spriteEvents)) {
			var _getspr=spritedat[$ $"{sprite_yank} {spriteEvents[g]}"]
			if is_undefined(_getspr) {
				_getspr=spritedat[$ $"{spriteEvents[g]}"]
			}
			if !is_undefined(_getspr) {
				show_debug_message(_getspr)
				spriteMap[$ $"{global.powerups[j]} {spriteEvents[g]}"]=_getspr
			}
			g++;
		}
		var i=0;
		repeat (array_length(list)) {
		    spr=list[i]
		    //read frame count list
		    //the below code was mega simplified since we don't have to deal with the commas for different sizes.
		    //I'm utilizing the defaults of nozerounreal here so that in the case that it doesn't actually find the tag it just goes for a non size specific version. i.e, one without a tag.s  ||  lazy 8am moster here Thank You.		
			if !is_undefined(animdat[$ $"{global.powerups[j]} {spr} frames"])
			frames_list[i]=animdat[$ $"{global.powerups[j]} {spr} frames"]
			else if !is_undefined(animdat[$ $"{spr} frames"])
			frames_list[i]=animdat[$ $"{spr} frames"]
			else frames_list[i]=1
			//read animation speed
		    if !is_undefined(animdat[$ $"{global.powerups[j]} {spr} speed"])
			t=animdat[$ $"{global.powerups[j]} {spr} speed"]
			else if !is_undefined(animdat[$ $"{spr} speed"])
			t=animdat[$ $"{spr} speed"]
			else t=1
		    if !(ceil(t)) t=1
	    
			speed_list[i]=t
		
		    //read animation loop
			var loop;
			if !is_undefined(animdat[$ $"{global.powerups[j]} {spr} loop"])
			loop=animdat[$ $"{global.powerups[j]} {spr} loop"]
			else if !is_undefined(animdat[$ $"{spr} loop"])
			loop=animdat[$ $"{spr} loop"]
			else loop=1
		    loops_list[i]=max(1,loop)
      
			if !is_undefined(animdat[$ $"{global.powerups[j]} {spr} frametimes"]) && is_array(animdat[$ $"{global.powerups[j]} {spr} frametimes"])
			times_list[i]=animdat[$ $"{global.powerups[j]} {spr} frametimes"]
			else if !is_undefined(animdat[$ $"{spr} frametimes"]) && is_array(animdat[$ $"{spr} frametimes"])
			times_list[i]=animdat[$ $"{spr} frametimes"]
			else times_list[i]=array_create(frames_list[i],1)
			i++;
		}
		
		if !is_undefined(spritedat[$ $"{global.powerups[j]} offset x"])
		offset_x_list[j]=spritedat[$ $"{global.powerups[j]} offset x"]
		else if !is_undefined(spritedat[$ "offset x"])
		offset_x_list[j]=spritedat[$ "offset x"]
		else offset_x_list[j]=0
		
		if !is_undefined(spritedat[$ $"{global.powerups[j]} offset y"])
		offset_y_list[j]=spritedat[$ $"{global.powerups[j]} offset y"]
		else if spritedat[$ "offset y"]!=undefined
		offset_y_list[j]=spritedat[$ "offset y"]
		else offset_y_list[j]=0
		
		if !is_undefined(spritedat[$ $"{global.powerups[j]} animation speed"])
		animspd_list[j]=spritedat[$ $"{global.powerups[j]} animation speed"]
		else if spritedat[$ "animation speed"]!=undefined
		animspd_list[j]=spritedat[$ "animation speed"]
		else animspd_list[j]=1
		
		if !is_undefined(spritedat[$ $"{global.powerups[j]} pole center offset"])
		poleoffx_list[j]=spritedat[$ $"{global.powerups[j]} pole center offset"]
		else if spritedat[$ "pole center offset"]!=undefined
		poleoffx_list[j]=spritedat[$ "pole center offset"]
		else poleoffx_list[j]=0
		
		if !is_undefined(spritedat[$ $"{global.powerups[j]} palette"])
		my_palletes[j]=spritedat[$ $"{global.powerups[j]} palette"]
		else my_palletes[j]=1
		
		j++;
	}
}

function init_sounds() {
	var dir=$"{working_directory}\\_vanilla\\character\\{charmName}\\sfx\\"
	var i=0;
	repeat (array_length(sound_list)) {
		if file_exists(dir+$"{charmName}{sound_list[i]}.wav") {
			VinylSetupExternal(dir+$"{charmName}{sound_list[i]}.wav",$"{charmName}{sound_list[i]}",1,1,false,"sound effects")
			
			show_debug_message($"Loaded WAV sound ID: {charmName}{sound_list[i]}")
		} else if file_exists(dir+$"{charmName}{sound_list[i]}.ogg") {
			VinylSetupExternal(dir+$"{charmName}{sound_list[i]}.ogg",$"{charmName}{sound_list[i]}",1,1,false,"sound effects")
			
			show_debug_message($"Loaded OGG sound ID: {charmName}{sound_list[i]}")
		} else {
			show_debug_message($"Failed to load sound ID: {charmName}{sound_list[i]}, is your file missing?")
		}
		i++;
	}
}

function playsfx(sound,pitch=1,loop=0,gain=0.5) {
	if VinylPatternExists(sound) {
		VinylPlay(sound,loop,gain,pitch)
	} else {
		show_debug_message($"Attempted to play sound ID {sound} but it doesn't exist!")
	}
}

function stopsfx(sound) {
	if VinylPatternExists(sound) && VinylPatternIsPlaying(sound) {
		VinylPatternStop(sound)
	}
}

function init_player() {
	spriteEvents=["idle"];
	spriteMap={};
	sound_list=[]; //failsafe
	catspeak_execute(global.scripts[? $"{charmName}_datalist"]); //sprite list
	frames_list=[1];
	loops_list=[1];
	times_list[0]=1;
	speed_list=[1];
	offset_x_list[0]=0;
	offset_y_list[0]=0;
	animspd_list[0]=0;
	my_palletes[0]=0;
	animf=1;
	offset_x=0;
	offset_y=0;
	box_width=2;
	box_height=2;
	fr=0;
	sprite="idle";
	xsc=1;
	ysc=1;
	sprite_angle=0;
	col=c_white;
	alpha=1;
	top_margin=120;
	dy=0;
	oldSpriteEvent="idle";
	skin_animationdata(pNum,charmName,global.player_spritelists[pNum]);
	init_sounds();
}

function draw_player() {
	//if (flash) exit
	var yoff=(12-hit_sizey);
	
	var spr=oGameManager.PlayerColl.GetImageInfo(get_spriteindex())
	if CollageImageExists(spr) {
		CollageDrawImageExt(
			spr, 
			floor(frame),
			floor(x) - (lengthdir_x(offset_x,(sprite_angle-90)*xsc)) * -xsc, 
			floor(y) - (lengthdir_y(offset_y,(sprite_angle-90)*ysc) - dy - (6) - yoff) * -ysc,
			xsc,
			ysc,
			sprite_angle*xsc,
			col,
			alpha
		)
	}
}

function sprite_arrposition() {
	var spritedat = global.animdat[pNum][0]
	var curr_size = get_size();
	var sprite_yank = curr_size
	if !is_undefined(spritedat[$ $"{curr_size} override"])
	sprite_yank = spritedat[$ $"{curr_size} override"]
	var spri=array_get_index(global.player_spritelists[pNum], spriteMap[$ $"{sprite_yank} {spriteEvent}"])
	
	return spri 
}

function animate_player() {
	//animation manager specifically for player characters
	
	var oldspr=get_spriteindex()
	oldSpriteEvent=spriteEvent;

	catspeak_execute(global.scripts[? $"{charmName}_draw"]);
	 
	//Growing and hurting size changes.
	var spritedat = global.animdat[pNum][0]
	var sprite_yank = size
	if !is_undefined(spritedat[$ $"{size} override"])
	sprite_yank = spritedat[$ $"{size} override"]

	var spri=array_get_index(global.player_spritelists[pNum], spriteMap[$ $"{sprite_yank} {spriteEvent}"])
	
	var myspr=get_spriteindex()
	if myspr=-1 myspr=oldspr
	
	if (myspr!=oldspr) {
		frame=0
		fhaslooped = 0
	}
	
	if spri!=-1 {
		fhaslooped = 0
		frn=frames_list[spri] //frame number
		var times=times_list[spri]
		frs=(frspd*animf*(speed_list[spri]))/max(1,times[floor(frame)]) //(game speed * percent * sprite speed) / frame time
		if in_water() {
			frs*=0.45
		}
		frl=loops_list[spri]-1 //loop point  
		//if (water && !cantslowanim) frs*=wf                       
		if (piped!=2) frame+=frs
		if (frame<0) frame+=frn
		if (frame>=frn) {
			frame=frame-frn; 
			fhaslooped = 1;
			if (frl<frn) frame=frl;
			
		}
		frame=modulo(frame,0,frn)
		var sizeNum = array_get_index(global.powerups, get_size()); //not sure why this was a loop before. theres literally this same method above to get spri LOL
		offset_x=offset_x_list[sizeNum]
		offset_y=offset_y_list[sizeNum]
		animf=animspd_list[sizeNum]
		palette=my_palletes[sizeNum]
	}
	
	catspeak_execute(global.scripts[? $"{charmName}_upd_frame"]);
}

function finish_death() {
	oGameManager.enable_app_surf_redraw = true
	death_time = true
}	

function player_castlewalk() {
	if (finish && !dead) {
	    //player automation for ending cutscene directly ported from oe lol
    
	    up=0
	    down=0
	    left=0
	    right=0
	    flash=0
		
		ending = "flag" //dont care about the others rn -moster
		var viclength = 120
	
	    if (ending="flag") {
	        //if (skindat("walkin")) { //no such thing as a skindat. will change to config later but right now i want game work -moster
	        p = noone
	        d = 600
	        /*with (oThunderFlower) {
				if (abs(x-other.x) < other.d) { //MANSION. BASEMENT. FIND IT!!!
					other.p=id
					other.d=abs(x-other.x)
				} 
			}*/
	        if (p) {
	            right=(x<p.x-4)
	            left=(x>p.x+4)
	            if (abs(x-p.x)<=4 && !jump && !posed) {
	                catspeak_execute(global.scripts[? $"{charmName}_stop"]);
	                no_move=1
					no_step=1
	                posed=1
	                if (viclength) {
	                    alarm[6]=viclength
	                } else alarm[6]=1
	                playsfx(charmName+"win")        
					with (oGameManager) {
						fadein = true
						enable_app_surf_redraw = true
						fadeprog = 0
						alarm[1]=240
						alarm[11]=400
					}
	            }
	        }
	        //}
	        if (!p) {
				//so the camera doesnt move
				if (my_camera) {
					my_camera.locked = true;
				}
	            //walkoff
	            if (!posed) {
	                if (viclength) {
	                    if (!jump) {
	                        catspeak_execute(global.scripts[? $"{charmName}_stop"]);
	                        no_move=1
							no_step=1
	                        posed=1  
	                        alarm[2]=viclength
							alarm[4]=viclength
							with (oGameManager) {
								fadein = true
								enable_app_surf_redraw = true
								fadeprog = 0
								alarm[1]=240
								alarm[11]=400
							}
	                        playsfx(charmName+"win") 
	                    }
	                } else {
						posed=1
						//fadeprog += 0.042
					}
	            } else {
					right=(x<room_width)	
				}
	        } 
	    }
	    if (!posed || (!p && posed && right)) {
			apress = akey
	        akey=((jump && akey) || place_meeting(x + (16 * xsc), y, oEnemy) || !grounded)
			apress = (akey && !apress)
	        bkey=0
	        ckey=0
	    }
	}
}

function give_lives(player = 0, _x = x, _y = y, amount = 1, part = p1UP, sound = "snd_1up") {
	
	if (part != -4) 
		instance_create(_x, _y, part);
    if (sound != -4) {
		VinylStop(asset_get_index(sound));
		VinylPlay(asset_get_index(sound));
	}
	
	global.lives[player]+=amount
}

function hit_block(x1, y1, x2, y2, dir=-1, _id=id) {
	var blockcoll=collision_line(x1,y1,x2,y2, oHittable, false, true);
	if (blockcoll) && (blockcoll.hit == 0) && (blockcoll.amount != 0) && !(blockcoll.no_hit) {
		blockcoll.blockHit.Emit(dir, _id)
	}
}

function make_particle(obj,_x,_y,_depth=depth+5,xsc=1,hsp=0,vsp=0,grav=0,fric=0,ysc=1) {
	var i=instance_create_depth(_x, _y, _depth, obj);
	i.depth = _depth;
	i.image_xscale = xsc;
	i.image_yscale = ysc;
	i.hspeed=hsp
	i.vspeed=vsp;
	i.friction=fric;
	i.gravity=grav;
	
	return i
}

function increase_combo(_x,_y) {
	stompCombo=min(stompCombo+1,8)
	VinylPlay(snd_enemykick,false,1,0.9+(stompCombo/10))
			
	if (stompCombo>=8)
	give_lives(pNum, _x, _y)
	else
	instance_create_depth(_x,_y,5,pScoreText,{image_index : stompCombo})
}