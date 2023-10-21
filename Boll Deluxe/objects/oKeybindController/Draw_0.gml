vieww=view_get_wport(view_current)
viewh=view_get_hport(view_current)
midx=vieww/2
midy=viewh/2

draw_set_halign(fa_middle)
draw_set_valign(fa_middle)
draw_set_font(Font3)

//needs to be rewritten into an actual good system lol
if (selectedoption)!=0
draw_text(midx,midy-64,"Back to Menu")
else
draw_text(midx,midy-64,"> Back to Menu <")

if (selectedoption)!=1
draw_text(midx,midy-32,"Right: "+input_binding_get_icon(input_binding_get("right")))
else
draw_text(midx,midy-32,"> Right: "+input_binding_get_icon(input_binding_get("right"))+" <")

if (selectedoption)!=2
draw_text(midx,midy-16,"Left: "+input_binding_get_icon(input_binding_get("left")))
else
draw_text(midx,midy-16,"> Left: "+input_binding_get_icon(input_binding_get("left"))+" <")

if (selectedoption)!=3
draw_text(midx,midy,"Up: "+input_binding_get_icon(input_binding_get("up")))
else
draw_text(midx,midy,"> Up: "+input_binding_get_icon(input_binding_get("up"))+" <")

if (selectedoption)!=4
draw_text(midx,midy+16,"Down: "+input_binding_get_icon(input_binding_get("down")))
else
draw_text(midx,midy+16,"> Down: "+input_binding_get_icon(input_binding_get("down"))+" <")

if (selectedoption)!=5
draw_text(midx,midy+32,"A (Run): "+input_binding_get_icon(input_binding_get("action")))
else
draw_text(midx,midy+32,"> A (Run): "+input_binding_get_icon(input_binding_get("action"))+" <")

if (selectedoption)!=6
draw_text(midx,midy+48,"B (Jump): "+input_binding_get_icon(input_binding_get("jump")))
else
draw_text(midx,midy+48,"> B (Jump): "+input_binding_get_icon(input_binding_get("jump"))+" <")

if (selectedoption)!=7
draw_text(midx,midy+64,"C (Action): "+input_binding_get_icon(input_binding_get("special")))
else
draw_text(midx,midy+64,"> C (Action): "+input_binding_get_icon(input_binding_get("special"))+" <")

if (selectedoption)!=8
draw_text(midx,midy+96,"Revert to Default")
else
draw_text(midx,midy+96,"> Revert to Default <")

if (input_binding_scan_in_progress())
{
draw_text(midx,viewh-8,"Press any key...")
}