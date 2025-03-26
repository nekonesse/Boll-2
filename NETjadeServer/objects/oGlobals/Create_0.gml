#macro gametitle "Boll 2"
#macro version "0.1"

global.save_dir=""

global.smallBoldFont=font_add_sprite_ext(spr_smallboldfont,"0123456789abcdefghijklmnopqrstuvwxyz,.'"+chr(34)+":;/"+chr(92)+"[]><*!?_-=+{}#$@%^&|`~",true,1)
ScribblejrAttachSpritefont(global.smallBoldFont,true,1)
global.omiFont=font_add_sprite_ext(spr_omifont,"0123456789:;.,<=>}%/"+chr(92)+"-_!?*+#'"+chr(34)+"~@][&abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ",true,1)
ScribblejrAttachSpritefont(global.omiFont,true,1)

global.debug = false;
global.fps_display = 0;
global.netgame = false; // top 10 boll deluxe things that will never happen:
global.nextlevel = game_save_id+"\save.jade"