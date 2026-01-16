selected_layer = noone;
image_xscale = 320;
image_yscale = 320;
picker_property_index = -1;
picker_object_index = -1;

x -= image_xscale/2;
y -= image_yscale/2;

exitbutton = new JADEiconbutton(x+image_xscale-16,y+1,spr_JADEexiticon, function() {
	instance_destroy(oJADETylerPicker);
});

tile_zoom = 1;
pan_x = 0;
pan_y = 19;
start_pan_x = 0;
start_pan_y = 0;
initial_pan_x = 0;
initial_pan_y = 0;
panning = 0;
tile_drag = false;
tile_sel_last_x = 0;
tile_sel_last_y = 0;