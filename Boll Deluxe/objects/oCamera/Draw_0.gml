if !global.debug exit;

draw_rect(x - xsensor,y - 16,xsensor * 2,24,#FF0000,0.125)
draw_rect(x-8,y,16,ysensor * 1.333,#FFFF00,0.125)
draw_self()
draw_text(x,y,string(state)+"\n"+string(xdist)+"\n"+string(xsc)+"\n"+string(ydist))
if (oPlayer.grounded) {draw_text(x,y-32,"oPlayer is grounded")}
draw_rect(x_final-8,y_final,16,16,#00FF00,0.5)