function skin_data(key, value=undefined) {
	//skin data registry. passing a value writes to it.

	var map;
	map=oGameManager.skinmap

	if (value==undefined) {
	    if (ds_map_exists(map,key)) {return ds_map_find_value(map,key)}
	    else return false
	} else {
	    if (ds_map_exists(map,key)) ds_map_replace(map,key,value)
	    else ds_map_add(map,key,value)
	}
}

function replace_animdat(file) {
	var str,f,section,p;

	if (file_exists(file)) {
	    f=file_text_open_read(file)
	    section=""
	    do {
	        str=file_text_read_string(f)
	        file_text_readln(f)
	        if (str!="") {
	            if (string_pos("[",str) && string_pos("]",str) && !string_pos("=",str))
	                section=string_replace(string_replace(str,"[",""),"]","")
	            else {
	                p=string_pos("=",str)
	                skin_data(section+" "+string_copy(str,1,p-1),string_delete(str,1,p))
	            }
	        }
	    } until (file_text_eof(f))
	    file_text_close(f)
	    return true
	} return false
}

function skin_animationdata(slot,name,list,size) {
	var i,j,k,p,t,spr,tokens,c,tokens2,c2,sizename;

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
	    //I'm utilizing the defaults of nozerounreal here so that in the case that it doesn't actually find the tag it just goes for a non size specific version. i.e, one without a tag.s
		frames_list[i]=nozerounreal(skin_data(sizename+ " " + name+" "+string(spr)+" frames"),unreal(skin_data(name+" "+string(spr)+" frames"),1))
	    
		//read animation speed
	    t=nozerounreal(skin_data(sizename+ " " +name+" "+string(spr)+" speed"),unreal(skin_data(name+" "+string(spr)+" speed"),1) ) 
	    if (t=0) t=1 
	    
		speed_list[i]=t
		
	    //read animation loop
	    loops_list[i]=max(1,nozerounreal(skin_data(sizename+ " " +name+" "+string(spr)+" loop"),unreal(skin_data(name+" "+string(spr)+" loop"),1)) )
      
   
    
    
	    list=string(skin_data(sizename+ " " +name+" "+string(spr)+" frametimes"))
	    if list=""  list=string(skin_data(name+" "+string(spr)+" frametimes"))
    

	    c2=0
	    do {
	        p=string_pos(",",list)
	        if (p=0) {if (list!="") tokens2[c2]=list c2+=1}
	        else {
	            tokens2[c2]=string_copy(list,1,p-1) c2+=1
	            list=string_delete(list,1,p)
	        }
	    } until (p=0)
		
		var _f = function(_element, _index)
		{
			return (sprite_list[_index] == _element);
		}
		var spri=array_find_index(sprite_list,_f) //sprite list index
	    if (list="0") {
	        for (j=0;j<frames_list[i];j+=1) {
	            times_list[spri,j]=1 //if frame time is not found, set to default
	        }
	    } else {
	        for (j=0;j<frames_list[i];j+=1) {
	            times_list[spri,j]=max(1,unreal(tokens2[j],1)) //else if found, set frametime array map of sprite index to frame time value
	        }
	    }
	}
	box_width=max(1,nozerounreal(skin_data(sizename+ " " +name+" box width"),unreal(skin_data(name+" box width"),48)))
	box_height=max(1,nozerounreal(skin_data(sizename+ " " +name+" box height"),unreal(skin_data(name+" box height"),48)))
	offset_x=nozerounreal(skin_data(sizename+ " " +name+" offset x"),unreal(skin_data(name+" offset x"),0))
	offset_y=nozerounreal(skin_data(sizename+ " " +name+" offset y"),unreal(skin_data(name+" offset y"),0))
	animf=median(0,nozerounreal(skin_data(sizename+ " " +name+" animation speed"),unreal(skin_data(name+" animation speed"),1.0)),10)
	poleoffx=nozerounreal(skin_data(sizename+ " " +name+" pole center offset"),unreal(skin_data(name+" pole center offset"),8))
}

function init_player() { //make this load animation data later
	sheet=[];
	txr_exec(_spriteListEvent); //sprite list
	frames_list=[1];
	loops_list=[1];
	times_list=["stand",1];
	speed_list=[1];
	fr=0;
	sprite="stand";
	xsc=1;
	ysc=1;
	sprite_angle=0;
	col=c_white;
	alpha=1;
	top_margin=120;
	dy=0;
	
	skin_animationdata(pNum,charmName,sprite_list,0);
}

function draw_player() {
	//if (flash) exit
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


function animate_player() {
	///draw_player(step)
	//sprite/animation manager specifically for player characters, if you want one for enemies make a different script.
	//if step is true, animation is executed, otherwise it just draws
	
	oldspr=sprite
	//This makes the spr manager not run under certain circumstances.
	// if (!piped && !codeblock_stopsprmanager)

	txr_exec(_spriteManagerEvent);

	//this one handles drawing order inside multiplayer, or rather, the way it switches so that both are flashing when on top of one another.
	//if ((depth=0 || depth=1) && pNum=gamemanager.plrsort) depth=!depth
	 
	//Growing and hurting size changes.
	//mem=size
	//if (((hurt || fall=6) && hk<4) || (grow && gk mod 6<3)) size=oldsize

	//if (global.tpose) {sprite="stand" frame=0}

	if (sprite!=oldspr) frame=0
	
	var _f = function(_element, _index)
	{
		return (sprite_list[_index] == _element);
	}
	var spri=array_find_index(sprite_list,_f)
	//This is mostly the same as the original boll's, except the global variable now has size as one of the dimensions.
	frn=frames_list[spri] //frame number
	frs=(frspd*animf*1)/max(1,1) //(game speed * percent * sprite speed) / frame time
	frl=loops_list[spri]-1 //loop point  
	//if (water && !cantslowanim) frs*=wf                       
	if (piped!=2) frame+=frs
	if (frame<0) frame+=frn
	if (frame>=frn) {frame=frame-frn if (frl<frn) frame+=frl}
	frame=modulo(frame,0,frn)  

	//below is the code that deals with taking damage, as well as growing, commented out just in case rn
	//if (!super) if (((hurt || fall=6) && hk<4) || (grow && gk mod 6<3)) size=mem
}
/*
function draw_playercore(step) {
	///draw_playercore(1=step,0=draw)
	//automatically handles sprite drawing for 2.0 sheet format

	var k,frx,frn,fry,frs,frl,c,sprw,sprh,margin;
	
	margin=1/256

	if (step) {//animate
	    k=16+128*sid
	    //This is mostly the same as the original boll's, except the global variable now has size as one of the dimensions.
	    frn=global.animdat[pNum+size*10,k+1] //frame number
	    frs=(frspd*animf*global.animdat[pNum+size*10,k+2])/max(1,global.animdat[pNum+size*10,k+4+floor(frame)]) //(game speed * percent * sprite speed) / frame time
	    frl=global.animdat[pNum+size*10,k+3]-1 //loop point  
	    if (water && !cantslowanim) frs*=wf                       
	    if (piped!=2) frame+=frs
	    if (frame<0) frame+=frn
	    if (frame>=frn) {frame=frame-frn if (frl<frn) frame+=frl}
	    sprw=global.animdat[pNum+size*10,1]
	    sprh=global.animdat[pNum+size*10,2]
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