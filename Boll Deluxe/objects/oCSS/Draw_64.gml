var _spacing=0, _cardSizeW=sprite_get_width(spr_rostercard);
var _startX=(480/2),
	_startY=(270/2);

// centering the cards
_startX -= ((_cardSizeW+_spacing)*((_rowLimit-1)/2));
_startY -= ((_cardSizeW+_spacing)*((ceil(_charCount/(_rowLimit))-1)/2));

// x and y adders for loop
var _x=0;
	_y=0;
	
for (var i=1; i<_charCount+1; i++;) {
	draw_sprite(spr_rostercard,0,_startX+_x,_startY+_y);
	if (_select+1=i) {
		draw_sprite(spr_rostercard,5,_startX+_x,_startY+_y-1);
	}
	_x+=_cardSizeW+_spacing;
	if (i%_rowLimit=0) {
		_x=0;
		_y+=_cardSizeW+_spacing;
	}
}