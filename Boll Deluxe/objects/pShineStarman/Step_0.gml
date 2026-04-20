timer += 1;

if (timer > 10 || owner == noone) {
	instance_destroy();
}

depth = owner.depth + 1;