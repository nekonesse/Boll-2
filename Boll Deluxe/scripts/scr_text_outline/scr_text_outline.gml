function draw_text_outline(_x,_y,str,outwidth,outcol,outfidelity,xscale,yscale,angle){
	///draw_text_outline(x,y,str,outwidth,outcol,outfidelity,_separation,height)

	//x,y: Coordinates to draw
	//str: String to draw
	//arugment3 = outwidth: height of outline in pixels
	//outcol = outcol: Colour of outline (main text draws with regular set colour)
	//outfidelity = outfidelity: Fidelity of outline (recommended: 4 for small, 8 for medium, 16 for larger. Watch your performance!)
	//width = separation, for the draw_text_EXT command.
	//height = height for the draw_text_EXT command.


	//2,c_dkgray,4,20,500 <Personal favorite preset. (For fnt_3)
	var dto_dcol=draw_get_color();

	draw_set_color(outcol);

	for(var dto_i=45; dto_i<405; dto_i+=360/outfidelity)
	{
	  //draw_text_ext(_x+lengthdir_x(outwidth,dto_i),_y+lengthdir_y(outwidth,dto_i),str,width,height);
	  draw_text_transformed(_x+round(lengthdir_x(outwidth,dto_i)),_y+round(lengthdir_y(outwidth,dto_i)),str,xscale,yscale,angle);
	}

	draw_set_color(dto_dcol);

	draw_text_transformed(_x,_y,str,xscale,yscale,angle);
}