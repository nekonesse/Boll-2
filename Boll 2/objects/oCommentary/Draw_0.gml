if (VinylIsPlaying(voice))
    image_index = 1 + ((audio_sound_get_track_position(gm_voice) * 30) mod 8)
else image_index = 0;

draw_self();
