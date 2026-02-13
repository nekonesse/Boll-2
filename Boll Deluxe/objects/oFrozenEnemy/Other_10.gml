///@description Empty Contents on break
var j = noone;
switch (content) {
	case "goomba": j = oGoomba break;
	
	case "goombrat": j = oGoombrat break;
	
	case "gkoopa": j = oKoopa break;
	
	case "rkoopa": j = oKoopaRed break;
	
	case "beetle": j = oBuzzyBeetle break;
	
	case "bumpty": j = oBumpty break;
	
	case "shyguy": j = oShyGuy break;
	
	case "icesnifit": j = oIceSnifit break;
	
	default: break;
}

if (j != noone) {
	var i = instance_create_depth(x,y,0,j);
}

instance_create_depth(x,y,0,pSmoke);
instance_destroy();