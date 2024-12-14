if global.debug draw_text(x+16,y-80,$"{image_index}\n{prev_image_index}\n{image_speed}\n{spin_amount}")

palette_frame = (palette_frame + (palette_speed / 10)) mod 2

var true_palette_frame = floor(palette_frame) + 1
if (palette_frame mod 1 >= 0.75) true_palette_frame = 3

pal_swap_set(spr_checkpointpal, !!hit * true_palette_frame, false)
draw_self()
pal_swap_reset();