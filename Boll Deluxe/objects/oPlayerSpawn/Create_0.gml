image_xscale=1;
image_yscale=1;
global._playerChars = [oGlobals._charmList[0]]

var myChar = get_string("Choose \"You Are\" Characters", oGlobals._charmList[0]) //debug jade charm select. not sure if this is what you meant by "multi-charm loading" but it can "load" "multi" "charm"
//gamemaker i don't CARE if its deprecated because of async you cant choose your charm while the charm is already loading

for (var i = 0; i < array_length(oGlobals._charmList); i++) {
	if (myChar == oGlobals._charmList[i]) {
		global._playerChars = [myChar]
		break;
	}
}

var i=instance_create_depth(x,y,0,oPlayer)
instance_destroy();