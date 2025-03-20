// Feather disable all

/// This is an optional configuration script that you can edit. On boot, Vinyl will import the JSON
/// defined in this script by passing it into VinylSetupImportJSON(). You can configure the
/// entirety of your game audio from this one script in most cases.
/// 
/// If VINYL_LIVE_EDIT is set to <true> then editing this JSON file will quickly be reflected in
/// audio currently playing in your game. The live update feature does have limitations, however.
/// This feature is only available when running on Windows, Mac, or Linux. Furthermore, the GML
/// parser used to power live updating is very simple. You should treat the JSON written in this
/// file as "pure JSON" and you should not use conditionals or if-statements or any logic at all.

global.VinylConfigSON = [
    
    /*
    Here are some examples of different resources you can create using JSON. This is not an
    exhaustive list; please see "Vinyl JSON Format" for more information.
    
    
    
    // -- Simple sound gain adjustment
    //    All sounds can have their gain adjusted using the following JSON syntax.
    {
        sound: sndJump,
        gain: 0.9,
    },
    
    
    
    // -- Sound randomization
    //    The "shuffle" pattern can be used to choose a random sound to play. Vinyl will try to
    //    ensure that one sound is not repeatedly played.
    {
        shuffle: "coin",
        sound: [sndCoin1, sndCoin2, sndCoin3, sndCoin4, sndCoin5],
    },
    
    
    
    // -- Pitch variance
    //    Shuffle patterns can also be used to randomize pitch for a sound. If you specify a two-
    //    element array then Vinyl will randomize the pitch between those two values. You can also
    //    apply pitch randomization to sound randomization too.
    {
        shuffle: "jump variance",
        sound: sndJump,
        pitch: [1, 1.1],
    },
    
    
    
    // -- Head-Loop-Tail
    //    This kind of pattern will play the "head" sound, then loop the "loop" sound, and then
    //    will play the "tail" sound after that. You should use VinylSetLoop() to control when to
    //    move from the "loop" sound to the "tail" sound.
    {
        hlt: "forest bgm",
        head: sndMusicForestHead,
        loop: sndMusicForestLoop,
        tail: sndMusicForestTail,
        duckOn: "duckering music", //This pattern has additionally been set up on a ducker. See
                                   //below for more information on setting up this feature.
    },
    
    
    
    // -- Blend
    //    The final type of pattern will mix together multiple sounds using the "blend factor" set
    //    by VinylSetBlendFactor(). The default behaviour is to sweep between different sounds but
    //    you can also use an animation curve to control gains.
    {
        blend: "forest ambience",
        sounds: [sndAmbienceForestLow, sndAmbienceForestMid, sndAmbienceForestHigh],
        loop: true,
    },
    
    
    
    // -- Mixes
    //    It's very common to want to adjust the gain of multiple sounds and patterns all at once.
    //    Mixes allow you to do this. Any sound or pattern that is defined as a "member" of a mix
    //    will automatically have its gain adjusted when you adjust the gain for the mix as a
    //    whole. Please note that mixes cannot be defined inside other mixes i.e. there's no
    //    hierarchical mix behaviour.
    {
        mix: "diagetic music",
        members: [
            sndDiageticPiano, //You can list out sounds by reference
            sndDiageticFlute,
            sndDiageticGuitar, 
            {
                sound: sndDiageticDrums,
                gain: 0.9,
            },
        ]
    },
    
    
    
    // -- Duckers
    //    When playing music you'll sometimes want to easily crossfade between tracks such that
    //    only one music track is playing at a time. You'll also sometimes want to allow "strings"
    //    (short pieces of music triggered by special events) to ducker background music tracks.
    //    Both of these effects can be achieved with the "duckOn" feature.
    {
        ducker: "music ducker", //First, we set up the ducker itself
    },
    {
        sound: sndMusicMoon, //Second, we set up a link to a ducker in a sound or pattern
        duckOn: "music ducker",
    },
    {
        mix: "duckering music",
        membersDuckOn: "music ducker", //You can also set up a ducker for multiple sounds at once by
                                     //using the .membersDuckOn property on a mix
        members: [
            sndMusicLava,
            sndMusicWater,
            sndMusicJungle,
            
            {
                sound: sndStingFoundSecret,
                duckPrio: 1, //Sounds can also have a "priority" to control how sounds interact
            },
        ],
    },
    */
	{
        mix: "music",
		
        members: [
            mus_overworld_BG_head,
            mus_overworld_BG_loop,
			mus_overworld_FG_head,
            mus_overworld_FG_loop,
			mus_gameover,
			mus_editor_head,
			mus_editor_loop,
        ],
    },
	{
        hlt: "overworld bgm FG",
        head: mus_overworld_FG_head,
        loop: mus_overworld_FG_loop,
    },
	{
        hlt: "overworld bgm BG",
        head: mus_overworld_BG_head,
        loop: mus_overworld_BG_loop,
       
    },
	{
        hlt: "editor bgm",
        head: mus_editor_head,
        loop: mus_editor_loop,
       
    },
    {
		mix: "sound effects",
		members: [
			snd_itemappear, //items
			{
				sound: snd_itemappear,
				gain: 0.25
			},
			snd_blockbump, //objects
			{
				sound: snd_blockbump,
				gain: 0.5
			},
			snd_blockbreak,
			{
				sound: snd_blockbreak,
				gain: 0.8
			},
			snd_hardblockbreak,
			{
				sound: snd_hardblockbreak,
				gain: 0.8
			},
			snd_shootblockshoot,
			{
				sound: snd_shootblockshoot,
				gain: 0.5
			},
			snd_shootblockbreak,
			{
				sound: snd_shootblockbreak,
				gain: 0.5
			},
			snd_checkpoint,
			{
				sound: snd_checkpoint,
				gain: 0.4
			},
			snd_enemycannon, //hazards
			{
				sound: snd_enemycannon,
				gain: 0.3
			},
			snd_enemycannonfast,
			{
				sound: snd_enemycannonfast,
				gain: 0.3
			},
			snd_enemyexplode,
			{
				sound: snd_enemyexplode,
				gain: 0.5
			},
			snd_enemybigexplode,
			{
				sound: snd_enemybigexplode,
				gain: 0.5
			},
			snd_fireball,
			{
				sound: snd_fireball,
				gain: 0.5
			},
            snd_powerup,
            {
                sound: snd_powerup,
                gain: 0.5
            },
            snd_1up,
            {
                sound: snd_1up,
                gain: 0.4
            },
			snd_pipe,
			{
				sound: snd_pipe,
				gain: 0.5
			},
			snd_switch,
			{
				sound: snd_switch,
				gain: 0.5
			},
			snd_enemykick,
			{
				sound: snd_enemykick,
				gain: 0.5
			},
			snd_enemystomp,
			{
				sound: snd_enemystomp,
				gain: 0.5
			}
		],
	}
];