selected_layer = noone;
image_xscale = 320;
image_yscale = 405;

x -= image_xscale/2;
y -= image_yscale/2;

tilesetlist=[
"tTilesetMain",
"tTilesetPipes",
"tTilesetMainDeco",
"tTilesetWorld5",
]

exitbutton = new JADEiconbutton(x+image_xscale-16,y+1,spr_JADEexiticon, function() {
	instance_destroy(oJADELayerProperties);
	oJADEController.layereditbutton.reset();
});

//auto generation the list of names for dropdown, dont touch!
tilesetnames=[];
var i=0;
repeat(array_length(tilesetlist)) {
	array_push(tilesetnames, global.tilesets[$ tilesetlist[i]][2])
	i++;
}

tilesetselector = new JADEsmallbuttons(x,y+66,52,16)
tilesetselector.add("Select", function() {
	var inst = JADEdropdown(tilesetselector.x,tilesetselector.y+tilesetselector.height+4,tilesetnames, function(name,ind) {
		if (ind!=-1) {
			selected_layer.update_tileset(tilesetlist[ind]);
			oJADEController.current_tileset=selected_layer.tileset;
			oJADEController.tilepicker.pan_x = 0;
			oJADEController.tilepicker.pan_y = 0;
		}
		oJADELayerProperties.tilesetselector.reset();
	});
	inst.depth=oJADELayerProperties.depth-1;
});