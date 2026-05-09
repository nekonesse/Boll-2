#define create
grav=0.25; //we're having an actual grav var now because changing gravity should be EASIER!!
defaultgrav = grav; //for resetting gravity back to default
vsp=0;
hsp=0;
gsp=0;

chsp = 0;
cvsp = 0;

collision_array=[oCollider];

fric = 0.02; //slipperiness

xsc=1
ysc=1

#define step
vsp+=grav

if check_collision_line(x,y+sprite_height+1,x+sprite_width,y+sprite_height, COL_BOTTOM) {
    vsp= -4
}

y+=vsp

#define draw
draw_sprite(asset_get_index("spr_Samba"),0,x+8,y+8)