if in_shell {
	walker = false;
	gsp = 0;
	no_interaction = true;
	no_stomping = true;
	exit;
}

if unshellable {
	constantspd = 1;
	x = floor(x);
}