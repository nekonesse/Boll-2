if (place_meeting(x, y, oPlayer)) {
    var i = instance_place(x, y, oPlayer);
    if (i.bpress && !VinylIsPlaying(voice)) {
        gm_voice = VinylPlay(voice, false);
        current_speaker = "";
        current_subtitle = "";
        current_subtime = 0.000;
        current_subindex = 0;
    }
}

if (VinylIsPlaying(voice)) {
    var i = current_subindex;
    repeat ((array_length(subtitles) div 3) - current_subindex) {
        if (audio_sound_get_track_position(gm_voice) >= subtitles[i * 3] && current_subindex < i + 1) {
            current_subtime = subtitles[i * 3];
            current_speaker = subtitles[(i * 3) + 1];
            current_subtitle = subtitles[(i * 3) + 2];
            current_subindex = i + 1;
        }
    }
}