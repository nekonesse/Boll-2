{
  "resourceType": "GMSequence",
  "resourceVersion": "1.4",
  "name": "ItemBoxMovement",
  "autoRecord": true,
  "backdropHeight": 768,
  "backdropImageOpacity": 0.5,
  "backdropImagePath": "",
  "backdropWidth": 1366,
  "backdropXOffset": 0.0,
  "backdropYOffset": 0.0,
  "events": {
    "resourceType": "KeyframeStore<MessageEventKeyframe>",
    "resourceVersion": "1.0",
    "Keyframes": [],
  },
  "eventStubScript": null,
  "eventToFunction": {},
  "length": 16.0,
  "lockOrigin": false,
  "moments": {
    "resourceType": "KeyframeStore<MomentsEventKeyframe>",
    "resourceVersion": "1.0",
    "Keyframes": [],
  },
  "parent": {
    "name": "Sequences",
    "path": "folders/Sequences.yy",
  },
  "playback": 0,
  "playbackSpeed": 60.0,
  "playbackSpeedType": 0,
  "showBackdrop": true,
  "showBackdropImage": false,
  "spriteId": null,
  "timeUnits": 1,
  "tracks": [
    {"resourceType":"GMGraphicTrack","resourceVersion":"1.0","name":"spr_emptybox","builtinName":0,"events":[],"inheritsTrackColour":true,"interpolation":1,"isCreationTrack":false,"keyframes":{"resourceType":"KeyframeStore<AssetSpriteKeyframe>","resourceVersion":"1.0","Keyframes":[
          {"resourceType":"Keyframe<AssetSpriteKeyframe>","resourceVersion":"1.0","Channels":{"0":{"resourceType":"AssetSpriteKeyframe","resourceVersion":"1.0","Id":{"name":"spr_emptybox","path":"sprites/spr_emptybox/spr_emptybox.yy",},},},"Disabled":false,"id":"557e9551-0838-4bea-9295-81818efec8f2","IsCreationKey":false,"Key":0.0,"Length":16.0,"Stretch":false,},
        ],},"modifiers":[],"trackColour":4289589832,"tracks":[
        {"resourceType":"GMRealTrack","resourceVersion":"1.0","name":"image_index","builtinName":18,"events":[],"inheritsTrackColour":true,"interpolation":0,"isCreationTrack":false,"keyframes":{"resourceType":"KeyframeStore<RealKeyframe>","resourceVersion":"1.0","Keyframes":[
              {"resourceType":"Keyframe<RealKeyframe>","resourceVersion":"1.0","Channels":{"0":{"resourceType":"RealKeyframe","resourceVersion":"1.0","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":0.0,},},"Disabled":false,"id":"84667799-3422-455a-9f68-3c771d42e40c","IsCreationKey":false,"Key":0.0,"Length":1.0,"Stretch":false,},
              {"resourceType":"Keyframe<RealKeyframe>","resourceVersion":"1.0","Channels":{"0":{"resourceType":"RealKeyframe","resourceVersion":"1.0","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":1.0,},},"Disabled":false,"id":"a167cf27-f5a5-463d-8539-7d0cf800a8de","IsCreationKey":false,"Key":9.0,"Length":1.0,"Stretch":false,},
            ],},"modifiers":[],"trackColour":4289589832,"tracks":[],"traits":0,},
        {"resourceType":"GMRealTrack","resourceVersion":"1.0","name":"origin","builtinName":16,"events":[],"inheritsTrackColour":true,"interpolation":1,"isCreationTrack":true,"keyframes":{"resourceType":"KeyframeStore<RealKeyframe>","resourceVersion":"1.0","Keyframes":[
              {"resourceType":"Keyframe<RealKeyframe>","resourceVersion":"1.0","Channels":{"0":{"resourceType":"RealKeyframe","resourceVersion":"1.0","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":0.0,},"1":{"resourceType":"RealKeyframe","resourceVersion":"1.0","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":0.0,},},"Disabled":false,"id":"b1f356e3-fc67-4338-922f-c2b5e8a017bd","IsCreationKey":true,"Key":0.0,"Length":1.0,"Stretch":false,},
            ],},"modifiers":[],"trackColour":4289589832,"tracks":[],"traits":0,},
        {"resourceType":"GMRealTrack","resourceVersion":"1.0","name":"position","builtinName":14,"events":[],"inheritsTrackColour":true,"interpolation":1,"isCreationTrack":false,"keyframes":{"resourceType":"KeyframeStore<RealKeyframe>","resourceVersion":"1.0","Keyframes":[
              {"resourceType":"Keyframe<RealKeyframe>","resourceVersion":"1.0","Channels":{"0":{"resourceType":"RealKeyframe","resourceVersion":"1.0","AnimCurveId":null,"EmbeddedAnimCurve":{"resourceType":"GMAnimCurve","resourceVersion":"1.2","name":"Position","channels":[
                        {"resourceType":"GMAnimCurveChannel","resourceVersion":"1.0","name":"x","colour":4290799884,"points":[
                            {"th0":-0.25,"th1":0.0,"tv0":0.0,"tv1":0.0,"x":0.0,"y":0.0,},
                            {"th0":0.0,"th1":0.25,"tv0":0.0,"tv1":0.0,"x":1.0,"y":0.0,},
                          ],"visible":true,},
                        {"resourceType":"GMAnimCurveChannel","resourceVersion":"1.0","name":"y","colour":4281083598,"points":[
                            {"th0":0.0,"th1":0.0067528617,"tv0":0.0,"tv1":-1.0298918,"x":0.0,"y":0.0,},
                            {"th0":-0.029720258,"th1":0.030825425,"tv0":3.437317,"tv1":-3.565136,"x":0.07387017,"y":-12.177187,},
                            {"th0":-0.0069762915,"th1":0.0037709475,"tv0":0.0,"tv1":0.0,"x":0.1348393,"y":-16.58048,},
                            {"th0":-0.02691203,"th1":0.014755666,"tv0":-4.6783657,"tv1":2.565113,"x":0.20329803,"y":-12.367571,},
                            {"th0":-0.009289414,"th1":0.14666668,"tv0":-3.1155386,"tv1":0.0,"x":0.26505154,"y":0.103767395,},
                            {"th0":-0.14666668,"th1":0.0,"tv0":0.0,"tv1":0.0,"x":1.0,"y":0.0,},
                          ],"visible":true,},
                      ],"function":2,},"RealValue":0.0,},"1":{"resourceType":"RealKeyframe","resourceVersion":"1.0","AnimCurveId":null,"EmbeddedAnimCurve":{"resourceType":"GMAnimCurve","resourceVersion":"1.2","name":"","channels":[
                        {"resourceType":"GMAnimCurveChannel","resourceVersion":"1.0","name":"x","colour":4290799884,"points":[
                            {"th0":-0.25,"th1":0.0,"tv0":0.0,"tv1":0.0,"x":0.0,"y":0.0,},
                            {"th0":0.0,"th1":0.25,"tv0":0.0,"tv1":0.0,"x":1.0,"y":0.0,},
                          ],"visible":true,},
                        {"resourceType":"GMAnimCurveChannel","resourceVersion":"1.0","name":"y","colour":4281083598,"points":[
                            {"th0":0.0,"th1":0.0067528617,"tv0":0.0,"tv1":-1.0298918,"x":0.0,"y":0.0,},
                            {"th0":-0.029720258,"th1":0.030825425,"tv0":3.437317,"tv1":-3.565136,"x":0.07387017,"y":-12.177187,},
                            {"th0":-0.0069762915,"th1":0.0037709475,"tv0":0.0,"tv1":0.0,"x":0.1348393,"y":-16.58048,},
                            {"th0":-0.02691203,"th1":0.014755666,"tv0":-4.6783657,"tv1":2.565113,"x":0.20329803,"y":-12.367571,},
                            {"th0":-0.009289414,"th1":0.14666668,"tv0":-3.1155386,"tv1":0.0,"x":0.26505154,"y":0.103767395,},
                            {"th0":-0.14666668,"th1":0.0,"tv0":0.0,"tv1":0.0,"x":1.0,"y":0.0,},
                          ],"visible":true,},
                      ],"function":2,},"RealValue":0.0,},},"Disabled":false,"id":"b28cea29-5c3e-4c7b-89b6-97251db3f932","IsCreationKey":false,"Key":0.0,"Length":60.0,"Stretch":false,},
            ],},"modifiers":[],"trackColour":4289589832,"tracks":[],"traits":0,},
        {"resourceType":"GMRealTrack","resourceVersion":"1.0","name":"rotation","builtinName":8,"events":[],"inheritsTrackColour":true,"interpolation":1,"isCreationTrack":true,"keyframes":{"resourceType":"KeyframeStore<RealKeyframe>","resourceVersion":"1.0","Keyframes":[
              {"resourceType":"Keyframe<RealKeyframe>","resourceVersion":"1.0","Channels":{"0":{"resourceType":"RealKeyframe","resourceVersion":"1.0","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":0.0,},},"Disabled":false,"id":"704aa2ec-fef0-4662-8e36-c44379840823","IsCreationKey":false,"Key":0.0,"Length":1.0,"Stretch":false,},
            ],},"modifiers":[],"trackColour":4289589832,"tracks":[],"traits":0,},
        {"resourceType":"GMRealTrack","resourceVersion":"1.0","name":"scale","builtinName":15,"events":[],"inheritsTrackColour":true,"interpolation":1,"isCreationTrack":true,"keyframes":{"resourceType":"KeyframeStore<RealKeyframe>","resourceVersion":"1.0","Keyframes":[
              {"resourceType":"Keyframe<RealKeyframe>","resourceVersion":"1.0","Channels":{"0":{"resourceType":"RealKeyframe","resourceVersion":"1.0","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":1.0,},"1":{"resourceType":"RealKeyframe","resourceVersion":"1.0","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":1.0,},},"Disabled":false,"id":"002a060a-efc1-40b5-bd3a-97ea8c3eb020","IsCreationKey":true,"Key":0.0,"Length":1.0,"Stretch":false,},
            ],},"modifiers":[],"trackColour":4289589832,"tracks":[],"traits":0,},
      ],"traits":0,},
  ],
  "visibleRange": null,
  "volume": 1.0,
  "xorigin": 0,
  "yorigin": 0,
}