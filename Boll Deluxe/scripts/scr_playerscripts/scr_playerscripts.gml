function skin_setting(_sett) {
	var File =file_text_open_read($"{working_directory}/_vanilla/character/{charmName}/config.ini");
		
	var Line =file_text_read_string(File);
	while (!string_starts_with(Line, _sett+"=")) && (!file_text_eof(File)) {
		file_text_readln(File);
		Line =file_text_read_string(File);
	}
		
	var _string = string_delete(Line, 1, string_length(_sett+"="));
		
	file_text_close(File);
		
	return unreal(_string,0);
}

function skin_getstring(_sett) {
	var File =file_text_open_read($"{working_directory}/_vanilla/character/{charmName}/config.ini");
		
	var Line =file_text_read_string(File);
	while (!string_starts_with(Line, _sett+"=")) && (!file_text_eof(File)) {
		file_text_readln(File);
		Line =file_text_read_string(File);
		if (file_text_eof(File) && !string_pos(_sett+"=",Line)) {
			file_text_close(File);
			return ""
		}
	}
		
	var _string = string_delete(Line, 1, string_length(_sett+"="));
		
	file_text_close(File);
		
	return _string
}

function skin_getarray(_sett) {
	var File =file_text_open_read($"{working_directory}/_vanilla/character/{charmName}/config.ini");
	var Line =file_text_read_string(File);
	while (!string_starts_with(Line, _sett+"=")) && (!file_text_eof(File)) {
		file_text_readln(File);
		Line =file_text_read_string(File);
	}
	if (!file_text_eof(File)) {
		file_text_readln(File);
		var _string = string_delete(Line, 1, string_length(_sett+"="));
		file_text_close(File);
		return split_string(_string,",");
	}
	file_text_close(File);
}

function config_setting(_sett, dir) {
	var File =file_text_open_read($"{dir}/config.ini");
		
	var Line =file_text_read_string(File);
	while (!string_starts_with(Line, _sett+"=")) && (!file_text_eof(File)) {
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
	while (!string_starts_with(Line, _sett+"=")) && (!file_text_eof(File)) {
		file_text_readln(File);
		Line =file_text_read_string(File);
	}
		
	var _string = string_delete(Line, 1, string_length(_sett+"="));
		
	file_text_close(File);
		
	return _string
}

function config_getarray(_sett, dir) {
	var File =file_text_open_read($"{dir}/config.ini");
	var Line =file_text_read_string(File);
	while (!string_starts_with(Line, _sett+"=")) && (!file_text_eof(File)) {
		file_text_readln(File);
		Line =file_text_read_string(File);
	}
	if (!file_text_eof(File)) {
		file_text_readln(File);
		var _string = string_delete(Line, 1, string_length(_sett+"="));
		file_text_close(File);
		return split_string(_string,",");
	}
	file_text_close(File);
}

function get_spriteindex() { //returns the array index of the player's current sprite
	var ind=0;
	for (var i = 0; i < array_length(spriteEvents); ++i) {
	    if (spriteEvents[i]==spriteEvent) {
			ind=i;
			break;
		}
	}
	var key=ds_map_find_value(spriteMap,$"{size} {spriteEvents[i]}")
	return $"spr_{charmName}_{size}_{key}"
}

function skin_animationdata(slot,name,list) {
	var t,spr;

	for (var j = 0; j < array_length(global.powerups); ++j) {
		for (var g = 0; g < array_length(spriteEvents); ++g) {
			var _getspr=skin_getstring($"{global.powerups[j]}{spriteEvents[g]}")
			if (_getspr=="") {
				_getspr=string(skin_getstring($"{spriteEvents[g]}"))
			}
			if !(_getspr=="") {
				ds_map_add(spriteMap,$"{global.powerups[j]} {spriteEvents[g]}",_getspr)
			}
		}
		for (var i=0;i<array_length(list);i+=1) {
		    spr=list[i]
		    //read frame count list
		    //the below code was mega simplified since we don't have to deal with the commas for different sizes.
		    //I'm utilizing the defaults of nozerounreal here so that in the case that it doesn't actually find the tag it just goes for a non size specific version. i.e, one without a tag.s  ||  lazy 8am moster here Thank You.		
			frames_list[i]=nozerounreal(skin_setting(global.powerups[j]+" "+string(spr)+" frames"),skin_setting(string(spr)+" frames"))
	    
			//read animation speed
		    t=nozerounreal(skin_setting(global.powerups[j]+" "+string(spr)+" speed"),skin_setting(string(spr)+" speed")) 
		    if !(ceil(t)) t=1
	    
			speed_list[i]=t
		
		    //read animation loop
		    loops_list[i]=max(1,nozerounreal(skin_setting(global.powerups[j]+" "+string(spr)+" loop"),skin_setting(string(spr)+" loop")))
      

			//read frametimes
			if is_array(skin_getarray(string(spr)+" frametimes"))
			times_list[i]=skin_getarray(string(spr)+" frametimes")
			else
			times_list[i]=array_create(frames_list[i], 1)
		}
	
		offset_x_list[j]=nozerounreal(skin_setting(global.powerups[j]+" offset x"),skin_setting("offset x"))
		offset_y_list[j]=nozerounreal(skin_setting(global.powerups[j]+" offset y"),skin_setting("offset y"))
		animspd_list[j]=median(0,nozerounreal(skin_setting(global.powerups[j]+" animation speed"),skin_setting("animation speed")))
		poleoffx[j]=nozerounreal(skin_setting(global.powerups[j]+" pole center offset"),skin_setting("pole center offset"))
	}
}

function init_sounds() {
	var dir=$"{working_directory}\\_vanilla\\character\\{charmName}\\sfx\\"
	audioExtWavScan(dir)
	for (var i=0; i < array_length(sound_list); ++i;) {
		if file_exists(dir+$"{charmName}{sound_list[i]}.wav") {
			var snd=audioExtSoundGet($"{charmName}{sound_list[i]}")
			VinylSetupSound(audioExtSoundGetSoundID(snd))
			
			if (string(checkSnd) = "{ length : 0 }") { // lame ass hack, check above function for info
				show_debug_message($"Found sound ID: {charmName}{sound_list[i]}, but failed to load it?")
			} else {
				show_debug_message($"Loaded sound ID: {charmName}{sound_list[i]}")
			}
		} else {
			show_debug_message($"Failed to load sound ID: {charmName}{sound_list[i]}, is your file missing?")
		}
	}
}

function playsfx(sound,pitch=1,loop=0,gain=1) {
	if audioExtSoundExists(sound) {
		var snd=audioExtSoundGet(sound)
		VinylPlay(audioExtSoundGetSoundID(snd),loop,gain,pitch)
	}
}

function stopsfx(sound) {
	if audioExtSoundExists(sound) {
		var snd=audioExtSoundGet(sound)
		VinylStop(audioExtSoundGetSoundID(snd))
	}
}

function init_player() { //make this load animation data later
	spriteEvents=["idle"];
	spriteMap=ds_map_create();
	sound_list=[]; //failsafe
	txr_exec(global.scripts[? $"{charmName}_datalist"]); //sprite list
	frames_list=[1];
	loops_list=[1];
	times_list[0]=1;
	speed_list=[1];
	offset_x_list[0]=0;
	offset_y_list[0]=0;
	animspd_list[0]=0;
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
	
	skin_animationdata(pNum,charmName,spriteEvents);
	init_sounds();
}

function draw_player() {
	//if (flash) exit
	var spr=oGameManager.PlayerColl.GetImageInfo(get_spriteindex())
	if CollageImageExists(spr) {
		CollageDrawImageExt(
			spr, 
			fr,
			floor(x) - (floor(offset_x)) * -xsc, 
			floor(y) - (floor(offset_y) - (6) - (hit_sizey)) * -ysc,
			xsc,
			ysc,
			sprite_angle*xsc,
			col,
			alpha
		)
	}
	/*draw_sprite_general(
		sheet,0,
		8+floor(frame)*(box_width+1)+margin,
		top_margin+8+fry*(box_height+1)+(margin*2),
		box_width-margin*2,
		box_height-margin*2, //might need to add some lengthdir bullshit to make it rotate on offset properly
		//kms -moster
		floor(x) + lengthdir_x(((margin - offset_x - cx) * xsc), sprite_angle * xsc) + lengthdir_x(((margin + dy - (5 + offset_y + cy)) * ysc), (sprite_angle - 90) * ysc) - floor(offset_x) * -xsc,
		floor(y) + lengthdir_y(((margin - offset_x - cx) * xsc), sprite_angle * xsc) + lengthdir_y(((margin + dy - (5 + offset_y + cy)) * ysc), (sprite_angle - 90) * ysc) - floor(offset_y) - (11) - (hit_sizey) * -ysc,
		xsc,ysc,
		sprite_angle*xsc,
		col,col,col,col,
		alpha
	)			*/
}

function animate_player() {
	//animation manager specifically for player characters
	
	oldspr=get_spriteindex()

	txr_exec(global.scripts[? $"{charmName}_draw"]);
	
	//this one handles drawing order inside multiplayer, or rather, the way it switches so that both are flashing when on top of one another.
	//if ((depth=0 || depth=1) && pNum=gamemanager.plrsort) depth=!depth
	 
	//Growing and hurting size changes.
	mem = size;
	
	if (grow && (global.roomTimer mod 6 < 3)) {
		size = oldsize;
	}

	if (get_spriteindex()!=oldspr) frame=0
	
	show_debug_message(global.player_spritelists[pNum])
	var spri=array_get_index(global.player_spritelists[pNum], ds_map_find_value(spriteMap,$"{size} {spriteEvent}"))
	show_debug_message(ds_map_find_value(spriteMap,$"{size} {spriteEvent}"))
	show_debug_message(spri)
	if spri!=-1 {
		frn=frames_list[spri] //frame number
		frs=(frspd*animf*speed_list[spri])/max(1,times_list[spri,floor(frame)]) //(game speed * percent * sprite speed) / frame time
		frl=loops_list[spri]-1 //loop point  
		//if (water && !cantslowanim) frs*=wf                       
		if (piped!=2) frame+=frs
		if (frame<0) frame+=frn
		if (frame>=frn) {frame=frame-frn if (frl<frn) frame=frl}
		frame=modulo(frame,0,frn)
		for (var sizeNum = 0; sizeNum < array_length(global.powerups); sizeNum += 1) { //temporary size count, could replace with better method later maybe? works for now though -moster
			if global.powerups[sizeNum]==size {
				offset_x=offset_x_list[sizeNum]
				offset_y=offset_y_list[sizeNum]
				animf=animspd_list[sizeNum]
				break
			}
		}
	}
	
	if (size != mem) {
		size = mem;
	}
}

function finish_death() {
	room_restart();
}	