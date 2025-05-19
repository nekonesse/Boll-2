script_onTrigger = ""
script_onStep = ""
script_onCreate = ""
script_onDraw = ""

ran_create_event = false

is_triggered = false
only_once = false

depth=1;

enum TRIGGER
{
	NONE,
    OVERLAP,
    OVERLAP_ONCE,
    ON_TOUCH,
    PASS_X,
    PASS_Y,
    CHANNEL_ID,
}

detection_type = TRIGGER.NONE

detection_value = 0

node_init_vars()
