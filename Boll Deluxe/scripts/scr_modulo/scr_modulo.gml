function modulo(value,lower,upper){
	///modulo(value,lower,upper):value
	//keeps a value within supplied range warping in both ways (lower incl, upper excl)
	var o,d,w;

	o=lower
	d=value-o
	w=upper-o

	if (w=0) return o
	return d-floor(d/w)*w+o
}