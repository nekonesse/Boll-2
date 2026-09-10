if (demo_build) {
    draw_rect(0, 0, RESOLUTION_X, RESOLUTION_Y, c_black, 0.5, 0)
    
    if (surf_l == -1 || !surface_exists(surf_l))
        surf_l = surface_create(RESOLUTION_X div 2, RESOLUTION_Y);
    {
        surface_set_target(surf_l);
        draw_sprite_tiled(spr_TECHDEMO_css_bg, 5, scrollen, scrollen)
        surface_reset_target();
    }
    if (surf_r == -1 || !surface_exists(surf_r))
        surf_r = surface_create(RESOLUTION_X div 2, RESOLUTION_Y); 
    {
        surface_set_target(surf_r);
        draw_sprite_tiled(spr_TECHDEMO_css_bg, 4, scrollen, scrollen)
        surface_reset_target();
    }
    
    draw_set_colour(c_gray)
    
    draw_surface(surf_l, 0, 0)
    draw_surface(surf_r, RESOLUTION_X div 2, 0)
    
    draw_set_colour(c_white)
    
    var i = 0; repeat (2) {
        var slide;
        slide = demo_char_slide_l if (i) slide = demo_char_slide_r
        draw_sprite(spr_TECHDEMO_css_portraits, i, (RESOLUTION_X/2), (sprite_get_yoffset(spr_TECHDEMO_css_portraits) * 2) - slide)
        i++;
    }
    
    draw_sprite(spr_TECHDEMO_css_nametags, _select, (RESOLUTION_X/2) + ((RESOLUTION_X/4) * ((((1 - _select) * 2) - 1) * 1)), (RESOLUTION_Y/2))
    exit;
}

var _spacing=0, _cardSizeW=sprite_get_width(spr_rostercard);
var _startX=(RESOLUTION_X/2),
	_startY=(RESOLUTION_Y/2);

// centering the cards
_startX -= ((_cardSizeW+_spacing)*((_rowLimit-1)/2));
_startY -= ((_cardSizeW+_spacing)*((ceil(_charCount/(_rowLimit))-1)/2));

// x and y adders for loop
var _x=0,
	_y=0,
	_arr=oGlobals._charmList;
	
var i=0;
repeat (_charCount) {
	draw_sprite(spr_rostercard,0,_startX+_x,_startY+_y);
	if (_select=i) {
		draw_sprite(spr_rostercard,5,_startX+_x,_startY+_y);
	}
	draw_text_scribble(_startX+_x, _startY+_y-4, $"[spr_omifont][fa_middle][fa_center]{_arr[i]}");
	
	_x+=_cardSizeW+_spacing;
	if (i+1 mod _rowLimit==0) {
		_x=0;
		_y+=_cardSizeW+_spacing;
	}
	i++;
}