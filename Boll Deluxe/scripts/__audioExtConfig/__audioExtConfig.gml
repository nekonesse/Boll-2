#macro AUDIO_EXT_DEBUG_MODE											false		// Enables additional debug outputting.

#macro AUDIO_EXT_DIR_OGG_TO_SCAN_ON_START			"music\\"	// Default directory to look in for OGG on startup if SCAN_ON_START is true.
#macro AUDIO_EXT_DIR_WAV_TO_SCAN_ON_START			"sounds\\"	// Default directory to look in for WAV on startup ifSCAN_ON_START is true.
#macro AUDIO_EXT_SCAN_ON_START									false		// Autoscans and adds ogg/wavs upon initalization.
#macro AUDIO_EXT_PRELOAD_ON_START								true        // Adds the entries but doesn't load them into memory until .getSoundID() or audioExtGetSoundID() is called.
#macro AUDIO_EXT_COMPRESS_ON_START							false