deltime -= 1;
if deltime <= 0 {
	instance_destroy();
}
subimg = (abs(deltime - 30) / 30);