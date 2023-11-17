///draw_player(step)
//sprite/animation manager specifically for player characters, if you want one for enemies make a different script.
//if step is true, animation is executed, otherwise it just draws
/*
var mem,step;

step=argument[0]


if (step) {
    oldspr=sprite
    //This makes the spr manager not run under certain circumstances.
    if (!piped && !codeblock_stopsprmanager)

    charm_run("sprmanager")

    //this one handles drawing order inside multiplayer, or rather, the way it switches so that both are flashing when on top of one another.
    //if ((depth=0 || depth=1) && p2=gamemanager.plrsort) depth=!depth
}
if (flash && global.bgscroll mod 5<3) exit
//Growing and hurting size changes.
//mem=size
//if (((hurt || fall=6) && hk<4) || (grow && gk mod 6<3)) size=oldsize
sheet=sheets[size]


//if (global.tpose) {sprite="stand" frame=0}

if (step) {
    //reset frame on sprite change
    if (sprite!=oldspr) frame=0
    //find sprite position in list
    sid=0
    for (i=0;i<global.animdat[p2,0];i+=1) {
        if (string(global.animdat[p2,16+128*i])==sprite) {sid=i break}
    }
}
draw_playercore(step)*/