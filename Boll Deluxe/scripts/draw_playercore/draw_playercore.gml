///draw_playercore(1=step,0=draw)
//automatically handles sprite drawing for 2.0 sheet format
/*
var k,frx,fry,frs,frl,c;

if (argument[0]) {//animate
    k=16+128*sid
    //This is mostly the same as the original boll's, except the global variable now has size as one of the dimensions.
    frn=global.animdat[p2+size*10,k+1] //frame number
    frs=(frspd*animf*global.animdat[p2+size*10,k+2])/max(1,global.animdat[p2+size*10,k+4+floor(frame)]) //(game speed * percent * sprite speed) / frame time
    frl=global.animdat[p2+size*10,k+3]-1 //loop point  
    if (water && !cantslowanim) frs*=wf                       
    if (piped!=2) frame+=frs
    if (frame<0) frame+=frn
    if (frame>=frn) {frame=frame-frn if (frl<frn) frame+=frl}
    sprw=global.animdat[p2+size*10,1]
    sprh=global.animdat[p2+size*10,2]
    frame=modulo(precise(frame),0,frn)   
} else {//draw
    if object_index=player c=tint
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

}*/