left	=input_check_pressed("left");
right	=input_check_pressed("right");
up		=input_check_pressed("up");
down	=input_check_pressed("down");
akey	=(input_check_pressed("a") || input_check_pressed("enter"));
bkey	=input_check_pressed("b");
ckey	=input_check_pressed("c");

// vars so you don't copy and paste the same shit over and over
var _RowCount=_charCount div _rowLimit, // number of rows
	_curRow=_select div _rowLimit, // current row (y)
	_curPos=_select % _rowLimit, // current position (x)
	_topRowLimit=_charCount % _rowLimit, // how many cards are on the top row
	_beyondTopLimit=(_select+(_rowLimit-_topRowLimit)); // check to see if going up will go beyond the amount of cards at the top

// function to report current grid/position info (COPY THE ABOVE INTO IT IF YOU'RE UPDATING IT)
var _debugMess = function() {
	var	_RowCount=_charCount div _rowLimit,
		_curRow=_select div _rowLimit,
		_curPos=_select % _rowLimit,
		_topRowLimit=_charCount % _rowLimit,
		_beyondTopLimit=(_select+(_rowLimit-_topRowLimit));
	
	//show_debug_message($"Beyond Top Limit: {_beyondTopLimit}")
	//show_debug_message($"Current Row: {_curRow}");
	//show_debug_message($"Current Pos: {_curPos}");
	//show_debug_message($"Sel: {_select}");
	//show_debug_message($"Count: {_charCount}");
}

if (akey) {
	if (instance_exists(oMainMenu))
		room_goto(rGame);
		global._playerChars = [oGlobals._charmList[_select]];
	instance_destroy();
}

if (bkey) {
	if (instance_exists(oMainMenu)) {
		with (oMainMenu) {
			//backAmenu("levelselectm");
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
		
	_debugMess();
}

if (right) {
	_select += 1;
		
	if (_RowCount=_curRow) and (_select>_rowLimit*(_curRow+1)-1-(_rowLimit-_topRowLimit))
		_select = _rowLimit*(_curRow);
	else if (_select>_rowLimit*(_curRow+1)-1)
		_select = _rowLimit*(_curRow);
		
	_debugMess();
}

if (down) {
	_select += _rowLimit;
	if (_select>_charCount-1)
		_select = _curPos;
		
	_debugMess();
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
	_debugMess();
}