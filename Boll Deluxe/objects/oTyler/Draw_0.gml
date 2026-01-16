var tilesetarr = global.tilesets[$ tileset]
var t_width = sprite_get_width(tilesetarr[0])/16

var i=0;
repeat(uv[2]*(repeat_x+1)) {
	var j=0;
	repeat(uv[3]*(repeat_y+1)) {
		var tile_index = (uv[0]+(i mod uv[2]))+((uv[1]+(j mod uv[3]))*t_width);
		
		var tiledata = tile_index;
		if (mirror) {
			tiledata |= tile_mirror;
		}
		if (flip) {
			tiledata |= tile_flip;
		}
		if (rotate) {
			tiledata |= tile_rotate;
		}
		draw_tile(tilesetarr[1],tiledata,0,x+i*16+off_x,y+j*16+off_y);
		j++;
	}
	i++;
}