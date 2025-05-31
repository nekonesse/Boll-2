#define create
val=0

#define step
val += 1

#define draw
draw_self();
draw_text(x,y,val)

#define test
instance_create_depth(x,y,0,oGoomba)