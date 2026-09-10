if (VinylIsPlaying(voice)) {
    draw_set_font(global.rulerGold);
    
    draw_set_colour(c_black)
    draw_set_alpha(0.35)
    draw_rectangle(56, 4, 56 + 324, 4 + 72, 0)
    draw_set_alpha(1)
    draw_set_colour(c_white)
    
    draw_sprite(spr_commentary_icon, 0, 67, 27)

    draw_text_scribble(88, 8, $"[spr_rulergold][fa_top][fa_left][c_white]{current_speaker}");
    
    draw_text_scribble(112, 24, $"[spr_rulergold][fa_top][fa_left][c_white]{current_subtitle}");
}