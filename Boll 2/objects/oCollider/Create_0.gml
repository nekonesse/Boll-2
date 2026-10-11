no_collide = false;
semi = false;
ceiling_only = false;
slope = false;
rounded = false;
x_diff = 0;
y_diff = 0;
my_friction = 1;
grabbed = false;
slippery = false;
footstep_material = footstepMaterial.Default;

depth=10;

activateLink = new Signal();

activateLink.Connect(self, function(index, obj) {
	activated_by_link = true;
	switch(index) {
		case 0:
			nodeReverse.Emit();
		break;
	}
});

node_init_vars()