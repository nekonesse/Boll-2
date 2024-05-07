function load_animdat(){
//MODDED (all below)
MOD_PlayerSkins			=[];
MOD_SkinAnimSpeed		=[];
MOD_SkinAnimLoopPoint	=[];
MOD_SkinFrameCount		=[];
MOD_SkinDesc			=[];
MOD_SkinGSetts			=[];

var Frames		=0;
var OrgX		=0;
var OrgY		=0;
var AnimSpd		=0;
var LoopPnt		=0;
var StrArr		=[];
var SpdArr		=[];
var LoopArr		=[];
var FramesArr	=[];

//Make sure all directorys exist else make them
if (!directory_exists($"{working_directory}/_vanilla/character/")) directory_create($"{working_directory}/_vanilla/character/")


// Find first skin
var Skin_name  = file_find_first($"{working_directory}/_vanilla/character/*", fa_directory)
var Skin_index = 0

// Load all skins
if (Skin_name != "" && Skin_name != "<null>")
{
	while(Skin_name != "" && Skin_name != "<null>")
	{
		if !file_exists($"{working_directory}/_vanilla/character/{Skin_name}/player.txt") show_debug_message("NOT THERE")
		var File = file_text_open_read($"{working_directory}/_vanilla/character/{Skin_name}/player.txt");
		var Desc = SplitString(file_text_read_string(File),",");
		array_push(MOD_SkinDesc,Desc)
		file_text_readln(File); file_text_readln(File);
		var XYscale = SplitString(file_text_read_string(File),",");
		array_push(MOD_SkinGSetts,XYscale);
		file_text_readln(File); file_text_readln(File); file_text_readln(File);

		SpdArr		=[];
		LoopArr		=[];
		FramesArr	=[];
		var LengthOfAnims		=array_length(AnimationData);
		var OrgXarr	=[];
		var OrgYarr	=[];

		for (var i = 0; i < LengthOfAnims; ++i;)
		{
			var StrArr = SplitString(file_text_read_string(File),",");
			Frames=real(StrArr[0]); OrgX=StrArr[1]; OrgY=StrArr[2]; AnimSpd=real(StrArr[3])*0.01; LoopPnt=real(StrArr[4]);
			array_push(SpdArr,AnimSpd); array_push(LoopArr,LoopPnt); array_push(FramesArr,Frames);
			array_push(OrgXarr,StrArr[1]); array_push(OrgYarr,StrArr[2]);
			//show_debug_message(AnimationData[i]);
			//show_debug_message(Skin_name);
			//show_debug_message("s" + Skin_name + AnimationData[i]);
			//global.texPage.AddFile($"{working_directory}\\SEdata\\Skins\\{Skin_name}\\{AnimationData[i]}.png",$"s{Skin_name}{AnimationData[i]}",Frames,,,OrgX,OrgY);
			file_text_readln(File); file_text_readln(File);
		}

		array_push(MOD_SkinAnimSpeed,SpdArr);
		array_push(MOD_SkinAnimLoopPoint,LoopArr);
		array_push(MOD_SkinFrameCount,FramesArr);
		file_text_close(File);

		array_push(MOD_PlayerSkins,Skin_name);
		Skin_name  = file_find_next();
		Skin_index ++;
	}
}
}

function init_player(){ //make this load animation data later
	sheet=[];
	sprite_list=[];
	fr=0;
	sprite="stand";
	offset_x=0;
	offset_y=0;
	xsc=1;
	ysc=1;
	sprite_angle=0;
	col=c_white;
	alpha=1;
	box_width=47;
	box_height=47;
	top_margin=120;
	dy=0;
}

function draw_player() {
	var margin=1/256;
	var _f = function(_element, _index)
	{
		return (sprite_list[_index] == _element);
	}
	var fry=array_find_index(sprite_list,_f)
	draw_sprite_general(
		sheet[0],0,
		8+fr*(box_width+1+margin),
		top_margin+8+fry*(box_height+margin),
		box_width-margin*2,
		box_height-margin*2, //might need to add some lengthdir bullshit to make it rotate on offset properly
		floor(x)+lengthdir_x((margin)*xsc,sprite_angle)+lengthdir_x((margin+dy)*ysc,sprite_angle-90)-offset_x+(box_width/2)*-xsc,
		floor(y)+lengthdir_y((margin)*xsc,sprite_angle)+lengthdir_y((margin+dy)*ysc,sprite_angle-90)-offset_y-(11)+(box_height/2)*-ysc,
		xsc,ysc,
		sprite_angle,
		col,col,col,col,
		alpha
	)			
}

/*
function draw_player(step) {
	///draw_player(step)
	//sprite/animation manager specifically for player characters, if you want one for enemies make a different script.
	//if step is true, animation is executed, otherwise it just draws
	var mem;



	if (step) {
	    oldspr=sprite
	    //This makes the spr manager not run under certain circumstances.
	   // if (!piped && !codeblock_stopsprmanager)

	    txr_exec(_spriteManagerEvent);

	    //this one handles drawing order inside multiplayer, or rather, the way it switches so that both are flashing when on top of one another.
	    //if ((depth=0 || depth=1) && player_id=gamemanager.plrsort) depth=!depth
	}
	if (flash) exit
	//Growing and hurting size changes.
	//mem=size
	//if (((hurt || fall=6) && hk<4) || (grow && gk mod 6<3)) size=oldsize
	sheet=sheets[size]


	//if (global.tpose) {sprite="stand" frame=0}

	if (step) {
	    //reset frame on sprite change
	    if (sprite!=oldspr) frame=0
	    //find sprite position in list
	    sid=0
	    for (i=0;i<global.animdat[player_id,0];i+=1) {
	        if (string(global.animdat[player_id,16+128*i])==sprite) {sid=i break}
	    }
	}
	draw_playercore(step)
	//below is the code that deals with taking damage, as well as growing, commented out just in case rn
	//if (!super) if (((hurt || fall=6) && hk<4) || (grow && gk mod 6<3)) size=mem
}

function draw_playercore(step) {
	///draw_playercore(1=step,0=draw)
	//automatically handles sprite drawing for 2.0 sheet format

	var k,frx,frn,fry,frs,frl,c,sprw,sprh,margin;
	
	margin=1/256

	if (step) {//animate
	    k=16+128*sid
	    //This is mostly the same as the original boll's, except the global variable now has size as one of the dimensions.
	    frn=global.animdat[player_id+size*10,k+1] //frame number
	    frs=(frspd*animf*global.animdat[player_id+size*10,k+2])/max(1,global.animdat[player_id+size*10,k+4+floor(frame)]) //(game speed * percent * sprite speed) / frame time
	    frl=global.animdat[player_id+size*10,k+3]-1 //loop point  
	    if (water && !cantslowanim) frs*=wf                       
	    if (piped!=2) frame+=frs
	    if (frame<0) frame+=frn
	    if (frame>=frn) {frame=frame-frn if (frl<frn) frame+=frl}
	    sprw=global.animdat[player_id+size*10,1]
	    sprh=global.animdat[player_id+size*10,2]
	    frame=modulo(precise(frame),0,frn)   
	} else {//draw
	    c=tint
	    if !c c=$ffffff
	    frx=floor(frame)
	    fry=sid+ypos
	   if (shadow) { 
	        draw_set_blend_mode_ext(10,1) rect(x-sprcx,y-sprcy,sprw,sprh,$ffffff,1) draw_set_blend_mode(0)     
	        charm_run("effectsbehind")
	        if (sprite_angle!=0) draw_sprite_general(sheets[size],0,8+frx*sprw,128+fry*sprh,sprw-1,sprh-1,round(x+lengthdir_x(-sprcx*xsc,sprite_angle)+lengthdir_x((dy-sprcy)*ysc,sprite_angle-90)),round(y+lengthdir_y(-sprcx*xsc,sprite_angle)+lengthdir_y((dy-sprcy)*ysc,sprite_angle-90)),xsc,ysc,sprite_angle,$40ff40,$40ff40,$40ff40,$40ff40,alpha)
	        else draw_sprite_part_ext(sheets[size],0,8+frx*sprw,128+fry*sprh,sprw-1,sprh-1,round(x-sprcx*xsc),round(y+(dy-sprcy)*ysc),xsc,ysc,$40ff40,alpha)
	        draw_set_blend_mode_ext(10,1) rect(x-sprcx,y-sprcy,sprw,sprh,$ffffff,1) draw_set_blend_mode(0)
	        d3d_set_fog(1,$a00000,0,0)
	    } else 
    
		//charm_run("effectsbehind")

	    if (sprite_angle!=0) draw_sprite_general(
	    //  sprite, subimage    
	        sheets[size],0,
	    //  left, top    
	        8+frx*sprw+margin,128+fry*sprh+margin,
	    //  width, height    
	        sprw-1-margin*2,sprh-1-margin*2,
	    //  left top corner of the quad, accounting for rotation
	        round(x)+lengthdir_x((margin-sprcx)*xsc*pxsc*mxsc,sprite_angle)+lengthdir_x((margin+dy-(14+sprcy))*ysc*mysc+14,sprite_angle-90),
	        round(y)+lengthdir_y((margin-sprcx)*xsc*pysc*mysc,sprite_angle)+lengthdir_y((margin+dy-(14+sprcy))*ysc*mysc+14,sprite_angle-90),
	    //  scale and rotation
	        xsc*pxsc*mxsc,ysc*pysc,sprite_angle,
	    //  blending    
	        c,c,c,c,alpha*(1-0.75*shadow)
	    )
	    else draw_sprite_part_ext(
	        sheets[size],0,
	        8+frx*sprw,128+fry*sprh,
	        sprw-1,sprh-1,
	        round(x-sprcx*xsc), //XSC =direction PXSC = Pipe Squishing MXSC=Modifiable XSC
	        round(y+(dy-(14+sprcy))*ysc+14)+2, //+2 for ground offset
	        xsc,ysc,
	        c,image_alpha
	    )
	    //if (shadow) d3d_set_fog(0,0,0,0)   
	    //charm_run("effectsfront")
	}
}*/