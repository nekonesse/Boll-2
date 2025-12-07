#region UI
if !surface_exists(GUIcanvas) exit;

surface_set_target(GUIcanvas)
draw_clear_alpha(c_black, 0)

draw_set_font(global.omiFont)

draw_rect(0,0,guiw,24,themeaccent1,1) //top bar
draw_rect(0,24,guiw,32,themeaccent2,1) //tool top bar
draw_rect(guiw-240,24,240,guih-24,themeaccent1,1) //right side
draw_rect(0,56,192,guih-56,themeaccent1,1) //left side

not_on_gui=
!point_in_rectangle(curs_x,curs_y,0,0,guiw,32+24)&&
!point_in_rectangle(curs_x,curs_y,0,24,guiw,32)&&
!point_in_rectangle(curs_x,curs_y,guiw-240,24,guiw,guih)&&
!point_in_rectangle(curs_x,curs_y,0,56,192,guih)

topbuttons.draw();
modebuttons.draw();
toolbarbuttons.draw();
playtestbutton.draw();

if (selected_mode != DECO_MODE) {
	list_tabbuttons.draw();
	
	if !properties_tab_active {
		if selected_mode == OBJECT_MODE {
			objectlist.draw();
		} else if selected_mode == NODE_MODE {
			gizmolist.draw();
		}
	} else {
		propertylist.draw(selected_array);
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

surface_reset_target();

draw_surface(GUIcanvas, 0, 0)
#endregion