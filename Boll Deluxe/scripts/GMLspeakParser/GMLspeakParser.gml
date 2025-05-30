//! Responsible for the syntax analysis stage of the Catspeak compiler.
//!
//! This stage uses `CatspeakIRBuilder` to create a hierarchical
//! representation of your Catspeak programs, called an abstract syntax graph
//! (or ASG for short). These graphs are encoded as a JSON object, making it
//! possible for you to cache the result of parsing a mod to a file, instead
//! of re-parsing each time the game loads.

/// @feather ignore all

/// Consumes tokens produced by a `CatspeakLexer`, transforming the program
/// they represent into Catspeak IR. This Catspeak IR can be further compiled
/// down into a callable GML function using `CatspeakGMLCompiler`.
///
/// @experimental
///
/// @param {Struct.CatspeakLexer} lexer
///   The lexer to consume tokens from.
///
/// @param {Struct.CatspeakIRBuilder} builder
///   The Catspeak IR builder to write the program to.
function GMLspeakParser(lexer, builder, interface = other.interface) constructor {
    if (CATSPEAK_DEBUG_MODE) {
        __catspeak_check_arg_struct_instanceof(
                "lexer", lexer, "GMLspeakLexer");
        __catspeak_check_arg_struct_instanceof(
                "builder", builder, "CatspeakIRBuilder");
    }
    /// @ignore
    self.lexer = lexer;
    /// @ignore
    self.ir = builder;
	
	self.interface = interface;
	self.owner = other;
    /// @ignore
    self.finalised = false;
	self.functionNames = [];
    builder.pushFunction();
	__pushFunctionName();

    /// Parses a top-level Catspeak statement from the supplied lexer, adding
    /// any relevant parse information to the supplied IR.
    ///
    /// @example
    ///   Creates a new `CatspeakParser` from the variables `lexer` and
    ///   `builder`, then loops until there is nothing left to parse.
    ///
    ///   ```gml
    ///   var parser = new CatspeakParser(lexer, builder);
    ///   var moreToParse;
    ///   do {
    ///       moreToParse = parser.update();
    ///   } until (!moreToParse);
    ///   ```
    ///
    /// @return {Bool}
    ///   `true` if there is still more data left to parse, and `false`
    ///   if the parser has reached the end of the file.
    static update = function () {
        if (lexer.peek() == CatspeakToken.EOF) {
            if (!finalised) {
				ir.createStatement(ir.createValue(undefined)); // Force return `undefined`
                ir.popFunction();
				__popFunctionName();
                finalised = true;
            }
            return false;
        }
        if (CATSPEAK_DEBUG_MODE && finalised) {
            __catspeak_error(
                "attempting to update parser after it has been finalised"
            );
        }
        __parseStatement();
        return true;
    };

	static __pushFunctionName = function(_line) {
		var location_ = lexer.getLocation();
		array_push(functionNames, 
			"GMLspeak_" + owner.currentFilename + "@anon@" + string(catspeak_location_get_row(location_)) + ":" + 
			string(catspeak_location_get_column(location_)));
	}
	
	static __popFunctionName = function() {
		return array_pop(functionNames);	
	}

    /// @ignore
    static __parseStatement = function () {
        var result;
        var peeked = lexer.peek();
        if (peeked == CatspeakToken.SEMICOLON) {
            lexer.next();
            return;
        } else if (peeked == CatspeakToken.LET) {
            lexer.next();
            if (lexer.next() != CatspeakToken.IDENT) {
                __ex("expected identifier after 'let' keyword");
            }
            var localName = lexer.getValue();
            var location = lexer.getLocation();
            var valueTerm;
            if (lexer.peek() == CatspeakToken.ASSIGN) {
                lexer.next();
                valueTerm = __parseExpression();
            } else {
                valueTerm = ir.createValue(undefined, location);
            }
            var getter = ir.allocLocalOrReuse(localName, location);
            result = ir.createAssign(
                CatspeakAssign.VANILLA,
                getter,
                valueTerm,
                lexer.getLocation()
            );
        } else if (peeked == GMLspeakToken.DELETE) {
            lexer.next();
            return ir.createAssign(CatspeakAssign.VANILLA, __parseIndex(), ir.createValue(undefined), lexer.getLocation());
        } else if (peeked = CatspeakToken.BRACE_LEFT) {
            // This is a bug. I suspect that the IR isn't liking what is going on here.
            // Well, hacks are hacks!
            ir.createStatement(ir.createValue(-1));
			ir.pushBlock(true);
			__parseStatements("block", true);
			result = ir.popBlock(lexer.getLocation());
		} else {
            result = __parseExpression();
        }
        ir.createStatement(result);
		return result;
    };

    /// @ignore
    ///
    /// @return {Struct}
    static __parseExpression = function () {
        var peeked = lexer.peek();
        if (peeked == CatspeakToken.RETURN) {
            lexer.next();
            peeked = lexer.peek();
            var value;
            if (
                peeked == CatspeakToken.SEMICOLON ||
                peeked == CatspeakToken.BRACE_RIGHT
            ) {
                value = ir.createValue(undefined, lexer.getLocation());
            } else {
                value = __parseExpression();
            }
            return ir.createReturn(value, lexer.getLocation());
        } else if (peeked == GMLspeakToken.EXIT) {
			lexer.next();
			var value = ir.createValue(undefined, lexer.getLocation());
			return ir.createReturn(value, lexer.getLocation());
		} else if (peeked == CatspeakToken.CONTINUE) {
            lexer.next();
            return ir.createContinue(lexer.getLocation());
        } else if (peeked == CatspeakToken.BREAK) {
            lexer.next();
            peeked = lexer.peek();
            var value;
            if (
                peeked == CatspeakToken.SEMICOLON ||
                peeked == CatspeakToken.BRACE_RIGHT
            ) {
                value = ir.createValue(undefined, lexer.getLocation());
            } else {
                value = __parseExpression();
            }
            return ir.createBreak(value, lexer.getLocation());
        } else if (peeked == CatspeakToken.THROW) {
            lexer.next();
            peeked = lexer.peek();
            var value = __parseExpression();
            return ir.createThrow(value, lexer.getLocation());
        } else if (peeked == CatspeakToken.DO) { // Try
            lexer.next();
            ir.pushBlock(true);
            __parseStatements("try");
            var result = ir.popBlock();
            var peeked = lexer.next();
            if (peeked == CatspeakToken.CATCH) {
                 lexer.next();
                 ir.pushBlock();
                 var localRef = undefined;
                 if (lexer.peek() == CatspeakToken.PAREN_LEFT) {
                     lexer.next();
                 }
                 if (lexer.peek() == CatspeakToken.IDENT) {
                     var localName = lexer.getValue();
                     localRef = ir.allocLocal(localName, lexer.getLocation());
                     lexer.next();
                     lexer.next();
                 }
                 __parseStatements("catch");
                 var catchBlock_ = ir.popBlock();
                 if (lexer.peek() == CatspeakToken.PAREN_RIGHT) {
                     lexer.next();
                 } 
                 result = ir.createCatch(result, catchBlock_, localRef, lexer.getLocation());
            }
            
            return result;
        } else if (peeked == GMLspeakToken.DO) { // Do-until
            lexer.next();
            ir.pushBlock();
            __parseStatements("do");
            var block = ir.popBlock();
			if (lexer.peek() != GMLspeakToken.UNTIL) {
				__ex("expected 'until' after 'do' keyword");
			}
			lexer.next();
			var condition = __parseCondition();
			
			// TODO: Fix hack ass solution
			var op = __catspeak_operator_from_token(CatspeakToken.NOT_EQUAL);
            var lhs = condition;
            var rhs = ir.createValue(true);
			condition = ir.createBinary(op, lhs, rhs, lexer.getLocation());
			return ir.createLoop(undefined, condition, undefined, block, lexer.getLocation());
        } else if (peeked == CatspeakToken.IF) {
            lexer.next();
            var condition = __parseCondition();
            ir.pushBlock();
            __parseStatements("if")
            var ifTrue = ir.popBlock();
            var ifFalse;
            if (lexer.peek() == CatspeakToken.ELSE) {
                lexer.next();
                ir.pushBlock();
                if (lexer.peek() == CatspeakToken.IF) {
                    // for `else if` support
                    var elseIf = __parseExpression();
                    ir.createStatement(elseIf);
                } else {
                    __parseStatements("else");
                }
                ifFalse = ir.popBlock();
            } else {
                ifFalse = ir.createValue(undefined, lexer.getLocation());
            }
            return ir.createIf(condition, ifTrue, ifFalse, lexer.getLocation());
        } else if (peeked == CatspeakToken.WHILE) {
            lexer.next();
            var condition = __parseCondition();
            ir.pushBlock();
            __parseStatements("while");
            var body = ir.popBlock();
            return ir.createWhile(condition, body, lexer.getLocation());
        } else if (peeked == CatspeakToken.WITH) {
            lexer.next();
            var scope = __parseCondition();
            ir.pushBlock();
            __parseStatements("with");
            var body = ir.popBlock();
            return ir.createWith(scope, body, lexer.getLocation());
		} else if (peeked == GMLspeakToken.REPEAT) {
            lexer.next();
			var statement = __parseStatement();
			var localIterator = ir.allocLocal(string_concat("$$", get_timer(), "$$"));
			var incrValue = ir.createValue(1);
			var conditionValue = ir.allocLocal(string_concat("$$", get_timer(), "$$"));
            var condition = ir.createBinary(CatspeakOperator.LESS, localIterator, conditionValue, lexer.getLocation());
			ir.createStatement(ir.createAssign(CatspeakAssign.PLUS, conditionValue, statement, lexer.getLocation()));
			
            ir.pushBlock();
            __parseStatements("repeat");
            var body = ir.popBlock();
			var step = ir.createAssign(CatspeakAssign.PLUS, localIterator, incrValue);
            return ir.createLoop(condition, undefined, step, body, lexer.getLocation());
        } else if (peeked == GMLspeakToken.FOR) {
            lexer.next();
			if (lexer.peek() == CatspeakToken.PAREN_LEFT) {
				lexer.next();		
			}
			if (lexer.peek() == CatspeakToken.OTHER && lexer.getLexeme() == ";;") || (lexer.peek() == CatspeakToken.SEMICOLON) {
				var prevToken_ = lexer.peek();
				var prevLexeme_ = lexer.getLexeme();
				lexer.next(); 
				if (lexer.peek() == CatspeakToken.SEMICOLON) || (prevToken_ == CatspeakToken.OTHER && prevLexeme_ == ";;") {
					if (!(prevToken_ == CatspeakToken.OTHER && prevLexeme_ == ";;")) lexer.next();
					while(__isNot(CatspeakToken.PAREN_RIGHT)) {
						lexer.next();
					}
					lexer.next();
					ir.pushBlock();
					__parseStatements("for");
					var body = ir.popBlock();
					return ir.createWhile(ir.createValue(true), body, lexer.getLocation());
				}
			}
            __parseStatement();
			lexer.next();
			var condition = __parseCondition();
			lexer.next();
			var action = __parseExpression();
			lexer.next();
			if (lexer.peek() == CatspeakToken.SEMICOLON) {
				lexer.next();	
			}
            ir.pushBlock();
            __parseStatements("for");
			var body = ir.popBlock();
            var loop = ir.createLoop(condition, undefined, action, body, lexer.getLocation());
			return loop;
        } else if (peeked == GMLspeakToken.SWITCH) {
			lexer.next();
            var value = __parseExpression();
			var conditions = [];
            var conditions = __parseMatchArms();
            return ir.createMatch(value, conditions, lexer.getLocation());
        } else if (peeked == CatspeakToken.FUN) {
			var optionalArguments = undefined;
            lexer.next();
            ir.pushFunction();
			__pushFunctionName(lexer.getLocation());
            if (lexer.peek() != CatspeakToken.PAREN_LEFT) {
                __ex("expected opening '(' after 'fun' keyword");
            }
			lexer.next();
            while (__isNot(CatspeakToken.PAREN_RIGHT)) {
                if (lexer.next() != CatspeakToken.IDENT) {
                    __ex("expected identifier in function arguments");
                }
				var value = lexer.getValue();
                ir.allocArg(value, lexer.getLocation());
				if (lexer.peek() == CatspeakToken.ASSIGN) {
					lexer.next();
					optionalArguments ??= [];
					array_push(optionalArguments, {
						lhs: value,
						rhs: __parseExpression(),
						location: lexer.getLocation(),
					});
					//ir.createAssign(ir.createGet(value), ir.createCall(ir.createGet("$$__IS_NOT_NULLISH__$$"), 
				}
				
                if (lexer.peek() == CatspeakToken.COMMA) {
                    lexer.next();
                }
            }
            if (lexer.next() != CatspeakToken.PAREN_RIGHT) {
                __ex("expected closing ')' after function arguments");
            }
			
			// Handle optional arguments
			if (is_array(optionalArguments)) {
				var i = 0;
				repeat(array_length(optionalArguments)) {
					var value = optionalArguments[i];
					var lhs =  ir.createGet(value.lhs);
					var rhs = ir.createAssign(
					    __catspeak_operator_assign_from_token(CatspeakToken.ASSIGN),
					    lhs,
					    __parseAsSelf(value.rhs),
					    value.location
					);
					var condition = ir.createCall(ir.createGet("$$__OPTIONAL_ARGUMENT_SKIPPED__$$"), [lhs], lexer.getLocation());
					lhs = ir.createIf(condition, ir.createValue(undefined), rhs, lexer.getLocation());
					ir.createStatement(lhs);
					i += 1;
				}
			}			
            __parseStatements("fun");

			ir.createStatement(ir.createValue(undefined)); // Force return `undefined`
			__popFunctionName();
            return ir.createCall(ir.createGet("$$__BIND__$$"), [ir.createSelf(), ir.popFunction()]);
        } else {
            return __parseAssign();
        }
    };

    /// @ignore
    ///
    /// @param {String} keyword
    /// @return {Struct}
    static __parseStatements = function(keyword, strict = false) {
        var peeked = lexer.next()
        if (!strict) && (peeked != CatspeakToken.BRACE_LEFT) {
            __parseStatement();
            lexer.next();
            return;
        }
        if (peeked != CatspeakToken.BRACE_LEFT) {
            __ex("expected opening '{' at the start of '", keyword, "' block");
        }
        while (__isNot(CatspeakToken.BRACE_RIGHT)) {
            __parseStatement();
        }
        if (lexer.next() != CatspeakToken.BRACE_RIGHT) {
            __ex("expected closing '}' after '", keyword, "' block");
        }
    };
	
    /// @ignore
    ///
    /// @return {Struct}
    static __parseCondition = function () {
        return __parseAssign();
    };

	/// @ignore
    ///
    /// @return {Struct}
	static __parseAssignGlobalAccessor = function (accessor, key) {
		var lhs;	
		var accessorFunction = accessor;
		var peeked = lexer.peek();
        if (
            peeked == CatspeakToken.ASSIGN ||
            peeked == CatspeakToken.ASSIGN_MULTIPLY ||
            peeked == CatspeakToken.ASSIGN_DIVIDE ||
            peeked == CatspeakToken.ASSIGN_SUBTRACT ||
            peeked == CatspeakToken.ASSIGN_PLUS
        ) {
            lexer.next();
			var assignType;
			switch(peeked) {
				case CatspeakToken.ASSIGN: assignType = undefined; break;	
				case CatspeakToken.ASSIGN_MULTIPLY: assignType = CatspeakOperator.MULTIPLY; break;	
				case CatspeakToken.ASSIGN_DIVIDE: assignType = CatspeakOperator.DIVIDE; break;	
				case CatspeakToken.ASSIGN_SUBTRACT: assignType = CatspeakOperator.SUBTRACT; break;	
				case CatspeakToken.ASSIGN_PLUS: assignType = CatspeakOperator.PLUS; break;	
			}
			
			if (assignType != undefined) {
				lhs = ir.createBinary(
				    assignType,
				    ir.createCall(accessorFunction, [key]),
				    __parseAsSelf(__parseExpression()),
				    lexer.getLocation()
				);
				
				lhs = ir.createCall(
					accessorFunction, 
					[key, lhs]
				);
			} else {
				lhs = __parseAsSelf(__parseExpression());
				
				lhs = ir.createCall(
						accessorFunction, 
						[key, lhs],
						lexer.getLocation()
					);
			}
			
			return lhs;
		}
		
		return ir.createCall(accessorFunction, [key], lexer.getLocation());
	}
	
    /// @ignore
    ///
    /// @return {Struct}
    static __parseAssignAccessor = function (accessorFunction, collection, key) {
		var lhs;
		var lhsArray = [collection];
		if (is_array(key)) {
			array_copy(lhsArray, 1, key, 0, array_length(key));
		} else {
			array_push(lhsArray, key);
		}
        var peeked = lexer.peek();
        if (
            peeked == CatspeakToken.ASSIGN ||
            peeked == CatspeakToken.ASSIGN_MULTIPLY ||
            peeked == CatspeakToken.ASSIGN_DIVIDE ||
            peeked == CatspeakToken.ASSIGN_SUBTRACT ||
            peeked == CatspeakToken.ASSIGN_PLUS
        ) {
            lexer.next();
			var assignType;
			switch(peeked) {
				case CatspeakToken.ASSIGN: assignType = undefined; break;	
				case CatspeakToken.ASSIGN_MULTIPLY: assignType = CatspeakOperator.MULTIPLY; break;	
				case CatspeakToken.ASSIGN_DIVIDE: assignType = CatspeakOperator.DIVIDE; break;	
				case CatspeakToken.ASSIGN_SUBTRACT: assignType = CatspeakOperator.SUBTRACT; break;	
				case CatspeakToken.ASSIGN_PLUS: assignType = CatspeakOperator.PLUS; break;	
			}
            //var assignType = __catspeak_operator_assign_from_token(peeked);
			if (assignType != undefined) {
				lhs = ir.createBinary(
				    assignType,
				    ir.createCall(accessorFunction, lhsArray),
				    __parseAsSelf(__parseExpression()),
				    lexer.getLocation()
				);
				
				lhs = ir.createCall(
					accessorFunction, 
					is_array(key) ? [collection, key[0], key[1], lhs] : [collection, key, lhs]
				);
			} else {
				lhs = __parseAsSelf(__parseExpression());
				
				lhs = ir.createCall(
					accessorFunction, 
						is_array(key) ? [collection, key[0], key[1], lhs] : [collection, key, lhs],
						lexer.getLocation()
					);
			}
        } else if (peeked == GMLspeakToken.NULLISH_ASSIGN) {
			lexer.next();
			lhs = __parseAsSelf(__parseExpression());
			var rhs = ir.createCall(
				accessorFunction, 
				is_array(key) ? [collection, key[0], key[1], lhs] : [collection, key, lhs],
				lexer.getLocation()
			);
			
			
			lhs = ir.createCall(accessorFunction, lhsArray, lexer.getLocation());;
			var condition = ir.createCall(ir.createGet("$$__IS_NOT_NULLISH__$$"), [lhs], lexer.getLocation());
			lhs = ir.createIf(condition, ir.createValue(undefined), rhs, lexer.getLocation());
		} else {
			lhs = ir.createCall(accessorFunction, lhsArray); // GET
		}
        return lhs;
    };

    /// @ignore
    ///
    /// @return {Struct}
    static __parseCondition = function () {
        return __parseAssign();
    };

    /// @ignore
    ///
    /// @return {Struct}
    static __parseAssign = function () {
        var lhs = __parseAsSelf(__parseOpLogical());
		
        var peeked = lexer.peek();
        if (
            peeked == CatspeakToken.ASSIGN ||
            peeked == CatspeakToken.ASSIGN_MULTIPLY ||
            peeked == CatspeakToken.ASSIGN_DIVIDE ||
            peeked == CatspeakToken.ASSIGN_SUBTRACT ||
            peeked == CatspeakToken.ASSIGN_PLUS
        ) {
            lexer.next();
            var assignType = __catspeak_operator_assign_from_token(peeked);
            lhs = ir.createAssign(
                assignType,
                lhs,
                __parseAsSelf(__parseExpression()),
                lexer.getLocation()
            );
        } else if (peeked == GMLspeakToken.NULLISH_ASSIGN) {
			lexer.next();
			var rhs = ir.createAssign(
                __catspeak_operator_assign_from_token(CatspeakToken.ASSIGN),
                lhs,
                __parseAsSelf(__parseExpression()),
                lexer.getLocation()
            );
			var condition = ir.createCall(ir.createGet("$$__IS_NOT_NULLISH__$$"), [lhs], lexer.getLocation());
			lhs = ir.createIf(condition, ir.createValue(undefined), rhs, lexer.getLocation());
		}
        return lhs;
    };

    /// @ignore
    ///
    /// @return {Struct}
    static __parseOpLogical = function () {
        var result = __parseOpPipe();
        while (true) {
            var peeked = lexer.peek();
            if (peeked == CatspeakToken.AND) {
                lexer.next();
                var lhs = result;
                var rhs = __parseOpPipe();
                result = ir.createAnd(lhs, rhs, lexer.getLocation());
            } else if (peeked == CatspeakToken.OR) {
                lexer.next();
                var lhs = result;
                var rhs = __parseOpPipe();
                result = ir.createOr(lhs, rhs, lexer.getLocation());
            } else if (peeked == CatspeakToken.XOR) {
                lexer.next();
                var lhs = result;
                var rhs = __parseOpPipe();
                result = ir.createBinary(CatspeakOperator.XOR, lhs, rhs, lexer.getLocation());
            } else if (peeked == GMLspeakToken.NULLISH) {
				lexer.next();
				var condition = ir.createCall(ir.createGet("$$__IS_NOT_NULLISH__$$"), [result], lexer.getLocation());
				var rhs = __parseExpression();
				return ir.createIf(condition, result, rhs, lexer.getLocation());
			} else if (peeked == GMLspeakToken.QUESTION_MARK_SIGN) {
				lexer.next();
				var lhs = __parseExpression();
				lexer.next();
				var rhs = __parseExpression();
				var condition = result;
				return ir.createIf(condition, lhs, rhs, lexer.getLocation());
			} else {
                return result;
            }
        }
    };

    /// @ignore
    ///
    /// @return {Struct}
    static __parseOpPipe = function () {
        var result = __parseOpBitwise();
        while (true) {
            var peeked = lexer.peek();
            if (peeked == CatspeakToken.PIPE_RIGHT) {
                lexer.next();
                var lhs = result;
                var rhs = __parseOpBitwise();
                result = ir.createCall(rhs, [lhs], lexer.getLocation());
            } else if (peeked == CatspeakToken.PIPE_LEFT) {
                lexer.next();
                var lhs = result;
                var rhs = __parseOpBitwise();
                result = ir.createCall(lhs, [rhs], lexer.getLocation());
            } else {
                return result;
            }
        }
    };

    /// @ignore
    ///
    /// @return {Struct}
    static __parseOpBitwise = function () {
        var result = __parseOpBitwiseShift();
        while (true) {
            var peeked = lexer.peek();
            if (
                peeked == CatspeakToken.BITWISE_AND ||
                peeked == CatspeakToken.BITWISE_XOR ||
                peeked == CatspeakToken.BITWISE_OR
            ) {
                lexer.next();
                var op = __catspeak_operator_from_token(peeked);
                var lhs = result;
                var rhs = __parseOpBitwiseShift();
                result = ir.createBinary(op, lhs, rhs, lexer.getLocation());
            } else {
                return result;
            }
        }
    };

    /// @ignore
    ///
    /// @return {Struct}
    static __parseOpBitwiseShift = function () {
        var result = __parseOpEquality();
        while (true) {
            var peeked = lexer.peek();
            if (
                peeked == CatspeakToken.SHIFT_LEFT ||
                peeked == CatspeakToken.SHIFT_RIGHT
            ) {
                lexer.next();
                var op = __catspeak_operator_from_token(peeked);
                var lhs = result;
                var rhs = __parseOpEquality();
                result = ir.createBinary(op, lhs, rhs, lexer.getLocation());
            } else {
                return result;
            }
        }
    };

    /// @ignore
    ///
    /// @return {Struct}
    static __parseOpEquality = function () {
        var result = __parseOpRelational();
        while (true) {
            var peeked = lexer.peek();
            if (
                peeked == CatspeakToken.EQUAL ||
                peeked == CatspeakToken.NOT_EQUAL 
				//peeked == CatspeakToken.ASSIGN
            ) {
                lexer.next();
                var op = __catspeak_operator_from_token(peeked);
                var lhs = result;
                var rhs = __parseOpRelational();
                result = ir.createBinary(op, lhs, rhs, lexer.getLocation());
            } else {
                return result;
            }
        }
    };

    /// @ignore
    ///
    /// @return {Struct}
    static __parseOpRelational = function () {
        var result = __parseOpAdd();
        while (true) {
            var peeked = lexer.peek();
            if (
                peeked == CatspeakToken.LESS ||
                peeked == CatspeakToken.LESS_EQUAL ||
                peeked == CatspeakToken.GREATER ||
                peeked == CatspeakToken.GREATER_EQUAL
            ) {
                lexer.next();
                var op = __catspeak_operator_from_token(peeked);
                var lhs = result;
                var rhs = __parseOpAdd();
                result = ir.createBinary(op, lhs, rhs, lexer.getLocation());
            } else {
                return result;
            }
        }
    };

    /// @ignore
    ///
    /// @return {Struct}
    static __parseOpAdd = function () {
        var result = __parseOpMultiply();
        while (true) {
            var peeked = lexer.peek();
            if (
                peeked == CatspeakToken.PLUS ||
                peeked == CatspeakToken.SUBTRACT
            ) {
                lexer.next();
                var op = __catspeak_operator_from_token(peeked);
                var lhs = result;
                var rhs = __parseOpMultiply();
                result = ir.createBinary(op, lhs, rhs, lexer.getLocation());
            } else {
                return result;
            }
        }
    };

    /// @ignore
    ///
    /// @return {Struct}
    static __parseOpMultiply = function () {
        var result = __parseOpUnary();
        while (true) {
            var peeked = lexer.peek();
            if (
                peeked == CatspeakToken.MULTIPLY ||
                peeked == CatspeakToken.DIVIDE ||
                peeked == CatspeakToken.DIVIDE_INT ||
                peeked == CatspeakToken.REMAINDER
            ) {
                lexer.next();
                var op = __catspeak_operator_from_token(peeked);
                var lhs = result;
                var rhs = __parseOpUnary();
                result = ir.createBinary(op, lhs, rhs, lexer.getLocation());
            } else {
                return result;
            }
        }
    };

    /// @ignore
    ///
    /// @return {Struct}
    static __parseOpUnary = function () {
        var peeked = lexer.peek();
        if (
            peeked == CatspeakToken.NOT ||
            peeked == CatspeakToken.SUBTRACT ||
            peeked == CatspeakToken.PLUS
        ) {
            lexer.next();
            var op = __catspeak_operator_from_token(peeked);
            var value = __parseIndex();
            return ir.createUnary(op, value, lexer.getLocation());
        //} else if (peeked == CatspeakToken.COLON) {
        //    // `:property` syntax
        //    lexer.next();
        //    return __parseExpression();]
		// TODO::Implement better system
        } else {
            return __parseProperty();
        }
    };
	
	/// @ignore
	///
	/// @return {Struct}
	static __parseProperty = function () {
		var accessor;
		switch(lexer.peek()) {
			case GMLspeakToken.KEYBOARD_STRING:
				accessor = "$$__KEYBOARD_STRING__$$";
			break;
			case GMLspeakToken.ROOM:
				accessor = "$$__ROOM__$$";
			break;
			case GMLspeakToken.ROOM_WIDTH:
				accessor = "$$__ROOM_WIDTH__$$";
			break;
			case GMLspeakToken.ROOM_HEIGHT:
				accessor = "$$__ROOM_HEIGHT__$$";
			break;
			case GMLspeakToken.ROOM_PERSISTENT:
				accessor = "$$__ROOM_PERSISTENT__$$";
			break;
			case GMLspeakToken.VIEW_ENABLED:
				accessor = "$$__VIEW_ENABLED__$$";
			break;
			case GMLspeakToken.KEYBOARD_KEY:
				accessor = "$$__KEYBOARD_KEY__$$";
			break;
			case GMLspeakToken.KEYBOARD_LASTCHAR:
				accessor = "$$__KEYBOARD_LASTCHAR__$$";
			break;
			case GMLspeakToken.KEYBOARD_LASTKEY:
				accessor = "$$__KEYBOARD_LASTKEY__$$";
			break;
			case GMLspeakToken.MOUSE_LASTBUTTON:
				accessor = "$$__MOUSE_LASTBUTTON__$$";
			break;
			case GMLspeakToken.CURSOR_SPRITE:
				accessor = "$$__CURSOR_SPRITE__$$";
			break;
			default:
				return __parseIndex();
		}
		
		lexer.next();
		return ir.createProperty(ir.createGet(accessor), lexer.getLocation());
	}
    
    /// @ignore
    ///
    /// @return {Array}
    static __parseMatchArms = function () {
		if (lexer.next() != CatspeakToken.BRACE_LEFT) {
			__ex("expected opening '{' before 'switch' cases");
		}
		var conditions = [];
		var statements = undefined;
		var breakDetected = false;
		var breakCases = undefined;
		var breakDetectedPushed = false;
		while (__isNot(CatspeakToken.BRACE_RIGHT)) {
			statements = undefined;
			var value;
			if (__isNot(GMLspeakToken.CASE) && __isNot(GMLspeakToken.DEFAULT)) {
				__ex("expected '"+lexer.getLexeme()+"' after 'switch' keyword");	
			}
			// Skip over the word case
			var prefix = lexer.next();
			if (prefix == GMLspeakToken.DEFAULT) {
				value = undefined;	
				if (lexer.peek() != CatspeakToken.COLON) {
					__ex("expected '"+lexer.getLexeme()+"' after 'case' expression or constant");
				}
				lexer.next();	
			} else {
				value =	__parseExpression();
				if (lexer.peek() != CatspeakToken.COLON) {
					__ex("expected '"+lexer.getLexeme()+"' after 'case' expression or constant");	
				}
				lexer.next();	
				// Multistack case
				if (lexer.peek() == GMLspeakToken.CASE) {
					statements = [value];
					while(lexer.peek() == GMLspeakToken.CASE) {
						if (lexer.peek() == GMLspeakToken.CASE) {
							lexer.next();	
						}
							
						array_push(statements, ir.createValue(lexer.getValue(), lexer.getLocation()));
						
						if (lexer.peek() == CatspeakToken.COLON) {
							lexer.next();	
						}
						lexer.next();
					}
				}
			}
			ir.pushBlock();
			while((__isNot(GMLspeakToken.CASE) && __isNot(GMLspeakToken.DEFAULT)) && __isNot(CatspeakToken.BRACE_RIGHT)) {
				breakDetectedPushed = false;
				if (lexer.peek() == CatspeakToken.BREAK) {
					breakDetected = true;
					lexer.next();
					if (lexer.peek() == CatspeakToken.SEMICOLON) {
						lexer.next();	
					}
					break;
				} else if (lexer.peek() == CatspeakToken.RETURN) {
					breakDetected = true;
					ir.createStatement(__parseExpression());
					if (lexer.peek() == CatspeakToken.SEMICOLON) {
						lexer.next();	
					}
					break;
				}
				__parseStatement();
			}
			var result = ir.popBlock();
			if (!breakDetected) {
				breakCases ??= [];	
				array_push(breakCases, [value, result]);
			}
			
			if (statements != undefined) {
				for(var i = 0, len = array_length(statements); i < len; ++i) {
					array_push(conditions, [statements[i], result]);
				}
			} else {
				if (breakDetected) {
					breakDetected = false;
					if (breakCases != undefined) {
						breakDetectedPushed = true;
						var newResult;
						for(var i = 0, len = array_length(breakCases); i < len; ++i) {
							ir.pushBlock();
							for(var j = i; j < len; ++j) {
								ir.createStatement(breakCases[j][1]);
							}
							ir.createStatement(result);
							newResult = ir.popBlock();
							array_push(conditions, [breakCases[i][0], newResult]);
						}	
						breakCases = undefined;
					}
					array_push(conditions, [value, result]);
				}	
			}
		}
        if (lexer.next() != CatspeakToken.BRACE_RIGHT) {
            __ex("expected closing '}' after 'switch'");
        }
        return conditions;
    }

    /// @ignore
    ///
    /// @return {Struct}
    static __parseIndex = function () {
        var callNew = lexer.peek() == CatspeakToken.NEW;
		var templateSymbolUsed = false;
        if (callNew) {
            lexer.next();
        }
		
        var result = __parseTerminal();
	
        while (true) {
            var peeked = lexer.peek();
            if (peeked == CatspeakToken.PAREN_LEFT) {
                // function call syntax
                lexer.next();
                var args = [];
                while (__isNot(CatspeakToken.PAREN_RIGHT)) {
                    if (lexer.peek() == CatspeakToken.COMMA) {
						array_push(args, ir.createValue(undefined, lexer.getLocation()));
					} else {
						array_push(args, __parseExpression());	
					}
                    if (lexer.peek() == CatspeakToken.COMMA) {
                        lexer.next();
                    }
                }
                if (lexer.next() != CatspeakToken.PAREN_RIGHT) {
                    __ex("expected closing ')' after function arguments");
                }
				
				result = __parseAsSelf(result);
				
                result = callNew
                        ? ir.createCallNew(result, args, lexer.getLocation())
                        : ir.createCall(result, args, lexer.getLocation());
				
                callNew = false;
            } else if (peeked == CatspeakToken.BOX_LEFT) {
                // accessor syntax
				lexer.next()
                var symbol = lexer.peek();
                var collection = result;
				var key;
				var symbolUsed = false;
				switch(symbol) {
					default:
						if(lexer.getLexeme() == "#") {
							lexer.next();
							key = [];
							array_push(key, __parseExpression());
							if (lexer.next() != CatspeakToken.COMMA) {
								__ex("expected opening ',' after '[#' index");
							}
							array_push(key, __parseExpression());
							symbolUsed = true;
							symbol = GMLspeakToken.HASH_SIGN;
						} else key = __parseExpression();
					break;
					case GMLspeakToken.AT_SIGN: // An array accessor!
						lexer.next();
						key = __parseExpression();
					break;
					case GMLspeakToken.DOLLAR_SIGN:
						lexer.next();
						key = __parseExpression();
                        symbolUsed = true;
					break;
					case GMLspeakToken.QUESTION_MARK_SIGN:
						lexer.next();
						key = __parseExpression();
						symbolUsed = true;
					break;
					case GMLspeakToken.VERTICAL_BAR:
						lexer.next();
						key = __parseExpression();
						symbolUsed = true;
					break;
					case GMLspeakToken.HASH_SIGN:
						lexer.next();
						key = [];
						array_push(__parseExpression());
						if (lexer.next() == CatspeakToken.COMMA) {
							lexer.next();	
						}
						array_push(__parseExpression());
						symbolUsed = true;
					break;
				}
                if (lexer.next() != CatspeakToken.BOX_RIGHT) {
                    __ex("expected closing ']' after accessor expression");
                }
				
				if (!symbolUsed) {
					result = ir.createAccessor(collection, key, lexer.getLocation()); 
				} else {
					switch(symbol) {
						case GMLspeakToken.QUESTION_MARK_SIGN:
							result = __parseAssignAccessor(ir.createGet("$$__MAP_ACCESSOR__$$"), collection, key);
						break;
						case GMLspeakToken.VERTICAL_BAR:
							result = __parseAssignAccessor(ir.createGet("$$__LIST_ACCESSOR__$$"), collection, key);
						break;
						case GMLspeakToken.HASH_SIGN:
							result = __parseAssignAccessor(ir.createGet("$$__GRID_ACCESSOR__$$"), collection, key);
						break;
                        case GMLspeakToken.DOLLAR_SIGN:
                            result = __parseAssignAccessor(ir.createGet("$$__STRUCT_ACCESSOR__$$"), collection, key);
                        break;
					}
				}
            } else if (peeked == CatspeakToken.DOT) {
                // dot accessor syntax
                lexer.next();
                var collection = result;
                if (lexer.next() != CatspeakToken.IDENT) {
                    __ex("expected identifier after '.' operator");
                }
                var key = ir.createValue(lexer.getValue(), lexer.getLocation());
                result = ir.createAccessor(collection, key, lexer.getLocation());
            } else {
                break;
            }
        }
        if (callNew) {
            // implicit new: `let t = new Thing;`
            result = ir.createCallNew(result, [], lexer.getLocation());
        }
        return result;
    };
	
    /// @ignore
    ///
    /// @return {Struct}
    static __parseTerminal = function () {
        var peeked = lexer.peek();
        if (peeked == CatspeakToken.VALUE) {
            lexer.next();
            return ir.createValue(lexer.getValue(), lexer.getLocation());
        } else if (peeked == CatspeakToken.PARAMS) {
			lexer.next();
			if (lexer.peek() == CatspeakToken.BOX_LEFT) {
				lexer.next();
				var key_ = __parseExpression();
				if (lexer.next() != CatspeakToken.BOX_RIGHT) {
					__ex("expected ']' after expression, got '" + lexer.getLexeme() + "'");
				}
			} else {
				__ex("expected '[' after 'argument', got '" + lexer.getLexeme() + "'");	
			}
			return ir.createParams(key_, lexer.getLocation());
		} else if (peeked == CatspeakToken.IDENT) {
            lexer.next();
			var lexeme = lexer.getLexeme();
			if (lexeme == "alarm") || 
				(lexeme == "view_visible") || 
				(lexeme == "view_camera") ||
				(lexeme == "view_xport") ||
				(lexeme == "view_yport") || 
				(lexeme == "view_wport") ||
				(lexeme == "view_hport") ||
				(lexeme == "view_surface_id") {
				if (lexer.peek() == CatspeakToken.BOX_LEFT) {
					lexer.next();
					var key = __parseExpression();
					if (lexer.next() != CatspeakToken.BOX_RIGHT) {
						__ex("expected closing ']' after '"+lexeme+"' index");	
					}
					
					var accessor = undefined;
					switch(lexeme) {
						case "alarm":			accessor = "$$__ALARM_ACCESSOR__$$"; break;
						case "view_visible":	accessor = "$$__VIEW_VISIBLE__$$"; break;
						case "view_camera":		accessor = "$$__VIEW_CAMERA__$$"; break;
						case "view_xport":		accessor = "$$__VIEW_XPORT__$$"; break;
						case "view_yport":		accessor = "$$__VIEW_YPORT__$$"; break;
						case "view_wport":		accessor = "$$__VIEW_WPORT__$$"; break;
						case "view_hport":		accessor = "$$__VIEW_HPORT__$$"; break;
						case "view_surface_id": accessor = "$$__VIEW_SURFACE_ID__$$"; break;
					}
					
					return __parseAssignGlobalAccessor(ir.createGet(accessor), key);
				}
			}
			return __parseAsSelf(ir.createGet(lexer.getValue(), lexer.getLocation()));	

        } else if (peeked == CatspeakToken.OTHER) {
            lexer.next();
            return ir.createOther(lexer.getLocation());
        } else if (peeked == CatspeakToken.SELF) {
            lexer.next();
            return ir.createSelf(lexer.getLocation());
        } else if (peeked == GMLspeakToken.__GMLINE__) {
			lexer.next();
			return ir.createValue(catspeak_location_get_row(lexer.getLocation()), lexer.getLocation())
		} else if (peeked == GMLspeakToken.__GMFILE__) { 
			lexer.next();
			return ir.createValue("GMLspeak_" + owner.currentFilename, lexer.getLocation())
		} else if (peeked == GMLspeakToken.__GMFUNCTION__) {
			lexer.next();
			return ir.createValue(functionNames[array_length(functionNames)-1], lexer.getLocation())
		} else if (peeked == CatspeakToken.PARAMS_COUNT) {
			lexer.next();
			return ir.createParamsCount(lexer.getLocation());
		} else {
            return __parseGrouping();
        }
    };

    /// @ignore
    ///
    /// @return {Struct}
    static __parseGrouping = function () {
        var peeked = lexer.peek();
        if (peeked == CatspeakToken.PAREN_LEFT) {
            lexer.next();
            var inner = __parseExpression();
            if (lexer.next() != CatspeakToken.PAREN_RIGHT) {
                __ex("expected closing ')' after group expression");
            }
            return inner;
        } else if (peeked == CatspeakToken.BOX_LEFT) {
            lexer.next();
            var values = [];
            while (__isNot(CatspeakToken.BOX_RIGHT)) {
                array_push(values, __parseExpression());
                if (lexer.peek() == CatspeakToken.COMMA) {
                    lexer.next();
                }
            }
            if (lexer.next() != CatspeakToken.BOX_RIGHT) {
                __ex("expected closing ']' after array literal");
            }
            return ir.createArray(values, lexer.getLocation());
        } else if (peeked == CatspeakToken.BRACE_LEFT) {
            lexer.next();
            var values = [];
            while (__isNot(CatspeakToken.BRACE_RIGHT)) {
                var key;
                var keyToken = lexer.next();
                if (keyToken == CatspeakToken.BOX_LEFT) {
                    key = __parseExpression();
                    if (lexer.next() != CatspeakToken.BOX_RIGHT) {
                        __ex(
                            "expected closing ']' after computed struct key"
                        );
                    }
                } else if (
                    keyToken == CatspeakToken.IDENT ||
                    keyToken == CatspeakToken.VALUE
                ) {
                    key = ir.createValue(lexer.getValue(), lexer.getLocation());
                } else {
                    __ex("expected identifier or value as struct key");
                }
                var value;
                if (lexer.peek() == CatspeakToken.COLON) {
                    lexer.next();
                    value = __parseExpression();
                } else if (keyToken == CatspeakToken.IDENT) {
                    value = ir.createGet(key.value, lexer.getLocation());
                } else {
                    __ex(
                        "expected ':' between key and value ",
                        "of struct literal"
                    );
                }
                if (lexer.peek() == CatspeakToken.COMMA) {
                    lexer.next();
                }
                array_push(values, key, value);
            }
            if (lexer.next() != CatspeakToken.BRACE_RIGHT) {
                __ex("expected closing '}' after struct literal");
            }
            return ir.createStruct(values, lexer.getLocation());
        } else {
            __ex("malformed expression, expected: '(', '[' or '{'");
        }
    };

    /// @ignore
    ///
    /// @param {String} ...
    static __ex = function () {
        var dbg = __catspeak_location_show(lexer.getLocation()) + " when parsing";
        if (argument_count < 1) {
            __catspeak_error(dbg);
        } else {
            var msg = "";
            for (var i = 0; i < argument_count; i += 1) {
                msg += __catspeak_string(argument[i]);
            }
            __catspeak_error(dbg, " -- ", msg, ", got ", __tokenDebug());
        }
    };

    /// @ignore
    ///
    /// @return {String}
    static __tokenDebug = function () {
        var peeked = lexer.peek();
        if (peeked == CatspeakToken.EOF) {
            return "end of file";
        } else if (peeked == CatspeakToken.SEMICOLON) {
            return "line break ';'";
        }
        return "token '" + lexer.getLexeme() + "' (" + string(peeked) + ")";
    };
	
	static __parseAsSelf = function(term) {
		if (term.type == CatspeakTerm.GLOBAL) && (!interface.exists(term.name)) {
			term.type = CatspeakTerm.VALUE;
			term.value = term.name;
			variable_struct_remove(term, "name");
			return ir.createAccessor(ir.createSelf(), term, term.dbg);
		}	
		return term;
	}

    /// @ignore
    ///
    /// @param {Enum.CatspeakToken} expect
    /// @return {Bool}
    static __isNot = function (expect) {
        var peeked = lexer.peek();
        return peeked != expect && peeked != CatspeakToken.EOF;
    };

    /// @ignore
    ///
    /// @param {Enum.CatspeakToken} expect
    /// @return {Bool}
    static __is = function (expect) {
        var peeked = lexer.peek();
        return peeked == expect && peeked != CatspeakToken.EOF;
    };
}