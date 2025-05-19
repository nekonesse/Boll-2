script_onTrigger = ""
script_onStep = ""
script_onCreate = ""

debugtext = ""

ran_create_event = false

is_triggered = false
only_once = false

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