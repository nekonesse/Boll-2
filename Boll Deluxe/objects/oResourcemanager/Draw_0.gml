vieww=view_get_wport(view_current)
viewh=view_get_hport(view_current)
midx=vieww/2
midy=viewh/2

draw_set_font(Font3)
draw_text(midx,16,"SELECT LEVEL")

draw_set_halign(fa_left)
if selectedlevel!=0
draw_text(16,16,"BACK")
else
draw_text(16,16,"> BACK <")

draw_set_font(Font2)
for(i=0; i<=array_length(global.levellist)-1; i++;) {
	if selectedlevel!=i+1
	draw_text(64,midy+(12*i),global.levellist[i])
	else
	draw_text(57,midy+(12*i),"> "+global.levellist[i]+" <")
}
draw_set_halign(fa_middle)

draw_set_font(Font3)