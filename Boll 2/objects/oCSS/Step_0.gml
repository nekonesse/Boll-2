left	=InputPressed(INPUT_VERB.LEFT);
right	=InputPressed(INPUT_VERB.RIGHT);
up		=InputPressed(INPUT_VERB.UP);
down	=InputPressed(INPUT_VERB.DOWN);
akey	=(InputPressed(INPUT_VERB.A) || InputPressed(INPUT_VERB.ENTER));
bkey	=InputPressed(INPUT_VERB.B)
ckey	=InputPressed(INPUT_VERB.C)

if (demo_build) {
    scrollen = (scrollen + 0.25) mod sprite_get_width(spr_TECHDEMO_css_bg);
    
    haltensie = clamp(haltensie - 1, 0, 28)
    
    if (haltensie) exit;
        
    if (!daiditeuzhe) {
        if (left && _select) {
            demo_char_slide_l = 1
            demo_char_slide_lm = sprite_get_yoffset(spr_TECHDEMO_css_portraits) / 2
            demo_char_slide_rm = sprite_get_yoffset(spr_TECHDEMO_css_portraits) / 2
    	   _select = 0; VinylPlay(test_ui_highlight)
        }
        
        if (right && !_select) {
            demo_char_slide_r = 1
            demo_char_slide_rm = sprite_get_yoffset(spr_TECHDEMO_css_portraits) / 2
            demo_char_slide_lm = sprite_get_yoffset(spr_TECHDEMO_css_portraits) / 2
        	_select = 1; VinylPlay(test_ui_highlight)
        }
    }
    
    if (!_select) {
        demo_char_slide_l = clamp(demo_char_slide_l + demo_char_slide_lm, 0, sprite_get_yoffset(spr_TECHDEMO_css_portraits) * 2)
        
        demo_char_slide_lm *= 0.666
        
        demo_char_slide_r = clamp(demo_char_slide_r - demo_char_slide_rm, 0, sprite_get_yoffset(spr_TECHDEMO_css_portraits) * 2)
        
        if (demo_char_slide_rm)
            demo_char_slide_rm *= 0.666
    } else if (_select) {
        demo_char_slide_l = clamp(demo_char_slide_l - demo_char_slide_lm, 0, sprite_get_yoffset(spr_TECHDEMO_css_portraits) * 2)
        
        demo_char_slide_lm *= 0.666
        
        demo_char_slide_r = clamp(demo_char_slide_r + demo_char_slide_rm, 0, sprite_get_yoffset(spr_TECHDEMO_css_portraits) * 2)
        
        demo_char_slide_rm *= 0.666
    }
    
    if (akey && !daiditeuzhe) {
        daiditeuzhe = 60
        VinylPlay(test_ui_select)
    }
    
    if (daiditeuzhe == 34)
        instance_create(0, 0, oTECHDEMO_MenuTrans);
    
    if (daiditeuzhe) daiditeuzhe--;
    
    if (daiditeuzhe == 1) {
        var i;
        i = 0;
        repeat(4) {
            global.lives[i]=5
            i++
        }
        
        FadeTransition(0.5, function() {
            room_goto(rGame);
        });
        global._playerChars = [demo_char[_select]];
    	instance_destroy();
    }
    
    if (bkey) {
        if (daiditeuzhe == 0) {
        	if (instance_exists(oTECHDEMO_TitleMenu)) {
        		with (oTECHDEMO_TitleMenu) {
        			backAmenu("levelselectm");
        			optionLock=0;
        		}
        	}
        	instance_destroy();
        } else if (daiditeuzhe >= 48) {
            daiditeuzhe = 0 VinylPlay(test_ui_cancel)
        }
    }
    exit
}

// vars so you don't copy and paste the same shit over and over
var _RowCount=_charCount div _rowLimit, // number of rows
	_curRow=_select div _rowLimit, // current row (y)
	_curPos=_select % _rowLimit, // current position (x)
	_topRowLimit=_charCount % _rowLimit, // how many cards are on the top row
	_beyondTopLimit=(_select+(_rowLimit-_topRowLimit)); // check to see if going up will go beyond the amount of cards at the top

if (akey) {
	if (instance_exists(oMainMenu))
		var i;
        
        i = 0;
		repeat(4) {
		    global.lives[i]=5
			i++
		}
		
		FadeTransition(0.5, function() {
			room_goto(rGame);
		});
		global._playerChars = [oGlobals._charmList[_select]];
	instance_destroy();
}

if (bkey) {
	if (instance_exists(oMainMenu)) {
		with (oMainMenu) {
			backAmenu("levelselectm");
			optionLock=0;
		}
	}
	instance_destroy();
}

if (left) {
	_select -= 1;
	
	if (_RowCount=_curRow) and (_select<_rowLimit*_curRow)
		_select = _rowLimit*(_curRow+1)-1-(_rowLimit-_topRowLimit);
	else if (_select<_rowLimit*_curRow)
		_select = _rowLimit*(_curRow+1)-1;
}

if (right) {
	_select += 1;
		
	if (_RowCount=_curRow) and (_select>_rowLimit*(_curRow+1)-1-(_rowLimit-_topRowLimit))
		_select = _rowLimit*(_curRow);
	else if (_select>_rowLimit*(_curRow+1)-1)
		_select = _rowLimit*(_curRow);
}

if (down) {
	_select += _rowLimit;
	if (_select>_charCount-1)
		_select = _curPos;
}

if (up) {
	_select -= _rowLimit;
	
	if (_select<0) {
		if (_beyondTopLimit >= _rowLimit) {
			_select = _charCount-(_rowLimit-_curPos)+1+(_rowLimit-(_topRowLimit+1))-_rowLimit;
		} else {
			_select = _charCount-(_rowLimit-_curPos)+1+(_rowLimit-(_topRowLimit+1));
		}
	}
}