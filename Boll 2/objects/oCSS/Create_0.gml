_select		=0; // current card selected
_charCount	=array_length(oGlobals._charmList); // character count
_rowLimit	=4; // amount of cards on a row

demo_char = ["mario", "sonic"]

demo_char_slide_r = 0
demo_char_slide_l = 0
demo_char_slide_lm = sprite_get_yoffset(spr_TECHDEMO_css_portraits) / 2
demo_char_slide_rm = 0

haltensie = 22

daiditeuzhe = 0

surf_l = -1
surf_r = -1

scrollen = 0

a11y_prev_select = -1;
if (instance_exists(oTECHDEMO_TitleMenu)) {
	var _n = demo_char[0];
	a11y_speak("Character select. " + string_upper(string_char_at(_n,1)) + string_delete(_n,1,1));
	a11y_prev_select = 0;
} else if (instance_exists(oMainMenu) && array_length(oGlobals._charmList) > 0) {
	var _n2 = oGlobals._charmList[0];
	a11y_speak("Character select. " + string(_n2));
	a11y_prev_select = 0;
}