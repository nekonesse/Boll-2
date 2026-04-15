image_xscale+=0.05;
image_yscale+=0.05;
image_alpha=max(image_alpha-0.05,0);

if (image_alpha <= 0.0) {
	instance_destroy();
}