#define text

debugtext = "yep, sure is reading this peice of text!" 
show_debug_message("ran script inside" + string(id))

#define test_create

arb_value = 0;

#define test_step

arb_value = (arb_value + 1) mod 360
debugtext = string(arb_value)