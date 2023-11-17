///Initialize
Catspeak.applyPreset(
	CatspeakPreset.MATH,
	CatspeakPreset.MATH_3D,
	CatspeakPreset.DRAW,
	CatspeakPreset.COLOUR,
	CatspeakPreset.ARRAY,
	CatspeakPreset.STRUCT,
	CatspeakPreset.STRING,
	CatspeakPreset.ASSET,
	CatspeakPreset.TYPE,
	CatspeakPreset.RANDOM,
	"collision",
	"instance"
);
if file_exists(working_directory+"\_vanilla\\character\\mario_create.meow") {
	var buffer = buffer_load(working_directory+"\_vanilla\\character\\mario_create.meow");
	var ast = Catspeak.parse(buffer);
	buffer_delete(buffer);

	createProgram = Catspeak.compileGML(ast);
	
	createProgram.setSelf(id)
	createProgram();
}

stepProgram=undefined;
if file_exists(working_directory+"\_vanilla\\character\\mario_step.meow") {
	var buffer = buffer_load(working_directory+"\_vanilla\\character\\mario_step.meow");
	var ast = Catspeak.parse(buffer);
	buffer_delete(buffer);

	stepProgram = Catspeak.compileGML(ast);
}

drawProgram=undefined;
if file_exists(working_directory+"\_vanilla\\character\\mario_draw.meow") {
	var buffer = buffer_load(working_directory+"\_vanilla\\character\\mario_draw.meow");
	var ast = Catspeak.parse(buffer);
	buffer_delete(buffer);

	drawProgram = Catspeak.compileGML(ast);
}