#macro MUSIC_GAIN 0.35
#macro MUSIC_GAIN_INACTIVE_MUFFLED 0.1
#macro MUSIC_GAIN_INACTIVE 0.225

global.yellow_switch=0;
global.cyan_switch=0;
global.magenta_switch=0;
global.coins_collected=0;
global.paused=0;
global.conductive_array=[oAmp];

shard_count = 0;
collected_shards = [];
shard_scales = [];
shard_gui_y = -16;
shard_gui_goto = -16;
shard_gui_timer = 0;

HUDsurface=-1;
gameoversurface=-1;

HUDcoinflash=0;

game_timer = 0;

level_properties =
{
    name : "Danger Room",
    desc : ""
};

object_uuids = {
	
};

piping_object_depth = [];
music_tracks = [];
region_widths = [];
region_heights = [];
region_positions = [];
hidden_tile_layers = [];
all_layers = [];

pswitch_timer = 0;

reserved_item = noone;
reserve_timer = 0;

var guiw = window_get_width();
var guih = window_get_height();
if !os_is_paused() && guiw>0 && guih>0 {
	HUDsurface=surface_create(RESOLUTION_X,RESOLUTION_Y)
}
bgMusic=undefined;
fgMusic=undefined;
current_music = "";
bluefadeprog = shader_get_uniform(shd_bluefade, "staged_offset");
bluefadeinflag = shader_get_uniform(shd_bluefade, "fadein");

fadeprog = 0.0
fadein = false

enable_app_surf_redraw = false

switch_region = function(region) {
	var musicstr;
	
	musicstr = music_tracks[region]
	
	//Play region's music
	if (struct_exists(global.musiclist, musicstr)) {
		if (musicstr != current_music)  {
			current_music = musicstr;
			VinylStop(fgMusic);
			VinylStop(bgMusic);
			var lmix, bmix;
			lmix = global.musiclist[$ musicstr].leadmix;
			bmix = global.musiclist[$ musicstr].backmix;
			if (lmix != undefined)
				fgMusic=VinylPlayFadeIn(lmix, true, MUSIC_GAIN * VinylMixGetGain("music"),0.5);
			if (bmix != undefined)
				bgMusic=VinylPlayFadeIn(bmix, true, MUSIC_GAIN * VinylMixGetGain("music"),0.5);
		}
	}
	
	with(oCamera) {
		myregion = region;
	}
	with(oBackgroundManager) {
		myregion = region;
	}
	
	//Update layers
	var i=0;
	repeat(array_length(all_layers)) {
		var j=0;
		repeat(array_length(all_layers[i])) {
			var struct = all_layers[i][j]
			layer_set_visible(struct.my_layer,false);
			j++;
		}
		i++;
	}
	i=0;
	repeat(array_length(all_layers[region])) {
		var struct = all_layers[region][i]
		layer_set_visible(struct.my_layer,true);
		i++;
	}
}

play_music = function() {
	VinylStop(fgMusic);
	VinylStop(bgMusic);
	var lmix, bmix;
	lmix = global.musiclist[$ current_music].leadmix;
	bmix = global.musiclist[$ current_music].backmix;
	if (lmix != undefined)
		fgMusic=VinylPlayFadeIn(lmix, true, MUSIC_GAIN * VinylMixGetGain("music"),0.5);
	if (bmix != undefined)
		bgMusic=VinylPlayFadeIn(bmix, true, MUSIC_GAIN * VinylMixGetGain("music"),0.5);
}

collect_shard = function(_id) {
	collected_shards[_id] = true;
	shard_scales[_id] = 3;
	shard_gui_goto = 16;
	shard_gui_timer = 180;
}