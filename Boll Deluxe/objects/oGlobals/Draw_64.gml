if !global.debug exit;
draw_set_font(smallF)
draw_text(2,2,$"FPS: {fps}\n\nUNCAPPED FPS: {fps_real}\n\nROOM SPEED: {room_speed}")
draw_set_font(basicPlaceholderF)