if !surface_exists(GUIcanvas) exit;

surface_set_target(GUIcanvas)
draw_clear_alpha(c_black, 0)

draw_set_font(global.omiFont)

draw_rect(0,0,guiw,24,themeaccent1,1)
draw_rect(0,24,guiw,24,themeaccent2,1)

topbuttons.draw();

with(oJADEDropDown) {
	event_perform(ev_draw,ev_draw_normal);
}

surface_reset_target();

draw_surface_ext(GUIcanvas, 0, 0, (cam_w/guiw), (cam_h/guih), 0, c_white, 1);