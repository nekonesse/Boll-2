vieww=view_get_wport(view_current)
viewh=view_get_hport(view_current)
midx=vieww/2
midy=viewh/2

draw_set_halign(fa_middle)
draw_set_valign(fa_middle)
draw_set_font(Font3)

//needs to be rewritten into an actual good system lol
if (selectedoption)!=0
draw_text(midx,midy-16,"level selector")
else
draw_text(midx,midy-16,"> level selector <")

if (selectedoption)!=1
draw_text(midx,midy+16,"keybinds")
else
draw_text(midx,midy+16,"> keybinds <")

if (selectedoption)!=2
draw_text(midx,viewh-16,"Exit Game")
else
draw_text(midx,viewh-16,"> Exit Game <")