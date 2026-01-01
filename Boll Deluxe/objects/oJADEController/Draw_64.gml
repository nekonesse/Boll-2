#region UI
if !surface_exists(GUIcanvas) exit;

surface_set_target(GUIcanvas)
draw_clear_alpha(c_black, 0)

draw_rect(0,0,guiw,24,themeaccent1,1) //top bar
draw_rect(0,24,guiw,32,themeaccent2,1) //tool top bar
draw_rect(guiw-240,24,240,guih-24,themeaccent1,1) //right side
draw_rect(0,56,192,guih-56,themeaccent1,1) //left side

topbuttons.draw();
modebuttons.draw();
toolbarbuttons.draw();
playtestbutton.draw();
objectvisibility.draw();
gizmovisibility.draw();
tilelayervisibility.draw();
assetlayervisibility.draw();
bglayervisibility.draw();

if (selected_mode != DECO_MODE) {
	list_tabbuttons.draw();
	
	if !properties_tab_active {
		if selected_mode == OBJECT_MODE {
			objectlist.draw();
		} else if selected_mode == NODE_MODE {
			gizmolist.draw();
		}
	} else {
		if (drawing_node==-1) {
			propertylist.draw(selected_array);
		} else {
			nodepropertylist.draw(drawing_node);
		}
	}
} else {
	switch(deco_mode_type) {
		case "tile": tilepicker.draw() break;
		case "asset": decolist.draw() break;
		case "bg": 
			bglist.draw() 
			bgalignbuttons.draw()
		break;
	}
	
	layerlist.draw();
	layeraddbutton.draw();
	layerdeletebutton.draw();
	layereditbutton.draw();
}

/*with(oJADEDropDown) {
	event_perform(ev_draw,ev_draw_normal);
}

with(oJADELayerProperties) {
	event_perform(ev_draw,ev_draw_normal);
}*/

if (displaytextdur) && (displaytext!="") {
	displaytextdur=max(0,displaytextdur-1)
	draw_set_halign(fa_center)
	draw_set_alpha(displaytextdur/60)
	draw_set_font(global.rulerGold)
	draw_text_outline(guiw/2,guih-24,displaytext, 1, c_black, 8, 1, 1, 0)
	draw_set_alpha(1)
	draw_set_halign(fa_left)
}

surface_reset_target();

draw_surface(GUIcanvas, 0, 0)
#endregion