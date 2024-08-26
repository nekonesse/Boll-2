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

function get_spriteindex() { //returns the array index of the player's current sprite
	var _f = function(_element, _index)
	{
		return (sprite_list[_index] == sprite);
	}
	var _index = array_find_index(sprite_list,_f)
	return _index
}

function skin_animationdata(slot,name,list,size) {
	var i,j,p,t,spr,sizename;

	switch (size){
	    case 0: sizename="basic" break;
	    case 1: sizename="big" break;
	    case 2: sizename="fire" break;
	    case 3: sizename="feather" break;
	    case 4: sizename="extra" break;
	    default: sizename=string(size) break;
	}

	for (i=0;i<array_length(list);i+=1) {
	    //k=16+128*i //1d array :P
	    /*
	        k value table
	        k+0 animation name
	        k+1 frames
	        k+2 speed
	        k+3 loop
	        k+4... frame times
	    */

	    spr=list[i]
	    //read frame count list
	    //the below code was mega simplified since we don't have to deal with the commas for different sizes.
	    //I'm utilizing the defaults of nozerounreal here so that in the case that it doesn't actually find the tag it just goes for a non size specific version. i.e, one without a tag.s  ||  lazy 8am moster here Thank You.		
		frames_list[i]=nozerounreal(skin_setting(sizename+" "+string(spr)+" frames"),skin_setting(string(spr)+" frames"))
	    
		//read animation speed
	    t=nozerounreal(skin_setting(sizename+" "+string(spr)+" speed"),skin_setting(string(spr)+" speed")) 
	    if (t=0) t=1 
	    
		speed_list[i]=t
		
	    //read animation loop
	    loops_list[i]=max(1,nozerounreal(skin_setting(sizename+" "+string(spr)+" loop"),skin_setting(string(spr)+" loop")))
      

		//read frametimes
		if is_array(skin_getarray(string(spr)+" frametimes"))
		times_list[i]=skin_getarray(string(spr)+" frametimes")
		else
		times_list[i]=array_create(frames_list[i])
	}
	box_width=max(2,nozerounreal(skin_setting(sizename+" box width"),skin_setting("box width")))-1
	box_height=max(2,nozerounreal(skin_setting(sizename+" box height"),skin_setting("box height")))-1
	offset_x=unreal(skin_setting(sizename+" offset x"),skin_setting("offset x"))
	offset_y=unreal(skin_setting(sizename+" offset y"),skin_setting("offset y"))
	animf=median(0,nozerounreal(skin_setting(sizename+" animation speed"),skin_setting("animation speed")))
	poleoffx=nozerounreal(skin_setting(sizename+" pole center offset"),skin_setting("pole center offset"))
}

function init_sounds() {
	var dir=$"{working_directory}\\_vanilla\\character\\{charmName}\\sfx\\"
	audioExtWavScan(dir)
	for (var i=0; i < array_length(sound_list); ++i;) {
		if file_exists(dir+$"{charmName}{sound_list[i]}.wav") {
			var snd=audioExtSoundGet($"{charmName}{sound_list[i]}")
			VinylSetupSound(audioExtSoundGetSoundID(snd))
			show_debug_message($"Loaded sound ID: {charmName}{sound_list[i]}")
		} else {
			show_debug_message($"Failed to load sound ID: {charmName}{sound_list[i]}, is your file missing?")
		}
	}
}

function playsfx(sound,pitch=1,loop=0,gain=1) {
	var snd=audioExtSoundGet(sound)
	VinylPlay(audioExtSoundGetSoundID(snd),loop,gain,pitch)
}

function stopsfx(sound) {
	var snd=audioExtSoundGet(sound)
	VinylStop(audioExtSoundGetSoundID(snd))
}

function init_player() { //make this load animation data later
	sprite_list=["stand"];
	sound_list=[]; //failsafe
	txr_exec(global.scripts[? $"{charmName}_datalist"]); //sprite list
	frames_list=[1];
	loops_list=[1];
	times_list[0]=1;
	speed_list=[1];
	fr=0;
	sprite="idle";
	xsc=1;
	ysc=1;
	sprite_angle=0;
	col=c_white;
	alpha=1;
	top_margin=120;
	dy=0;
	
	for (var sizeNum = 0; sizeNum < array_length(global.powerups); sizeNum += 1) { //temporary size count, could replace with better method later maybe? works for now though -moster
		skin_animationdata(pNum,charmName,sprite_list,sizeNum);
	}
	init_sounds();
}

function get_player_sheet() {
	mem = size;
	if (grow && (global.roomTimer mod 6 < 3)) {
		size = oldsize;
	}
	var mysheet = player_sheets[$ string(size)]
	if (sprite_exists(mysheet)) {
		if (sheet != mysheet) {
			sheet = mysheet;
		}
	} else if (sheet != player_sheets[$ "basic"]) { //fall back to basic if sheet doesn't exist for some reason
		sheet = player_sheets[$ "basic"];
	}
	if (size != mem) {
		size = mem;
	}
}

function draw_player() {
	//if (flash) exit
	var margin=1/256;
	var fry=get_spriteindex()
	draw_sprite_general(
		sheet,0,
		8+floor(frame)*(box_width+1)+margin,
		top_margin+8+fry*(box_height+1)+margin,
		box_width-margin*2,
		box_height-margin*2, //might need to add some lengthdir bullshit to make it rotate on offset properly
		floor(x)+lengthdir_x((margin)*xsc,sprite_angle)+lengthdir_x((margin+dy)*ysc,sprite_angle-90)-floor(offset_x)+(box_width/2)*-xsc,
		floor(y)+lengthdir_y((margin)*xsc,sprite_angle)+lengthdir_y((margin+dy)*ysc,sprite_angle-90)-floor(offset_y)-(11)+(box_height/2)*-ysc,
		xsc,ysc,
		sprite_angle,
		col,col,col,col,
		alpha
	)			
}

function animate_player() {
	//animation manager specifically for player characters, if you want one for enemies make a different script.
	
	oldspr=sprite
	//This makes the spr manager not run under certain circumstances.
	// if (!piped && !codeblock_stopsprmanager)
	txr_exec(global.scripts[? $"{charmName}_sprmanager"]);
	
	//this one handles drawing order inside multiplayer, or rather, the way it switches so that both are flashing when on top of one another.
	//if ((depth=0 || depth=1) && pNum=gamemanager.plrsort) depth=!depth
	 
	//Growing and hurting size changes.
	//commented out old code right now, also taking damage doesnt exist yet so its not there. also used the room timer 4 the flash honestly because i dont care rn -moster
	mem = size;
	//if (((hurt || fall=6) && hk<4) || (grow && /gk mod 6<3)) size=oldsize
	
	if (grow && (global.roomTimer mod 6 < 3)) {
		size = oldsize;
	}

	//if (global.tpose) {sprite="stand" frame=0}

	if (sprite!=oldspr) frame=0
	
	var spri=get_spriteindex()
	//show_message($"list - {frames_list}\nspriteindex - {sprite}") - debug shit :)
	frn=frames_list[spri] //frame number
	frs=(frspd*animf*speed_list[spri])/max(1,times_list[spri,floor(frame)]) //(game speed * percent * sprite speed) / frame time
	frl=loops_list[spri]-1 //loop point  
	//if (water && !cantslowanim) frs*=wf                       
	if (piped!=2) frame+=frs
	if (frame<0) frame+=frn
	if (frame>=frn) {frame=frame-frn if (frl<frn) frame=frl}
	frame=modulo(frame,0,frn)  

	//below is the old code that deals with taking damage, as well as growing, commented out just in case rn
	/*if (!super) if (((hurt || fall=6) && hk<4) || ((grow && gk mod 6<3)) size=mem*/ 
	
	if (size != mem) {
		size = mem;
	}
}

