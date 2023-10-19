/// @description Chance(percent)
/// @param percent
function chance(percent){
 
	// Returns true or false depending on RNG
	// ex: 
	//      Chance(0.7);    -> Returns true 70% of the time
 
	return percent > irandom(1);
}