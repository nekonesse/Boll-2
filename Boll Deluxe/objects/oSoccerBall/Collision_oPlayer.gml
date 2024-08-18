if (other.up) {
	hsp=2*other.xsc
	vsp=-3
} else if (other.down) {
	hsp=3*other.xsc
	vsp=-1
} else {
	hsp=4*other.xsc
	vsp=-2
}
grounded=false