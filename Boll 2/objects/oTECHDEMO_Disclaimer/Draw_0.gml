draw_set_valign(fa_center);
draw_set_halign(fa_middle);
draw_set_font(global.rulerGold);

var fus_ro_dah = " ";

if (interim_timer <= 0)
    fus_ro_dah = "Press any button to continue.";

//draw_text(64,64,string(interim_timer))

draw_text(room_width / 2, room_height / 2, "DISCLAIMER\n\nPlease note that this is a TECH DEMO,\nand as such everything is subject to change,\nincluding but not limited to graphics,\nlevel layouts, sounds, game logos, and\nmenu interfaces.\n\nMod support is also limited in this version;\nfor now, simply report bugs you find in the\nofficial Boll Team Discord server, or clone\nthe GitHub repository if you want to contribute\ncontent and code to the final game.\n\n" + fus_ro_dah);