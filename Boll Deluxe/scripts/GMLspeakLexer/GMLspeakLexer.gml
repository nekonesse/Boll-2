//! Responsible for the lexical analysis stage of the Catspeak compiler.
//! This stage converts UTF8 encoded text from individual characters into
//! discrete clusters of characters called [tokens](https://en.wikipedia.org/wiki/Lexical_analysis#Lexical_token_and_lexical_tokenization).

/// @feather ignore all

/// A token in Catspeak is a series of characters with meaning, usually
/// separated by whitespace. These meanings are represented by unique
/// elements of the `GMLspeakToken` enum.
///
/// @example
///   Some examples of tokens in Catspeak, and their meanings:
///   - `if`   (is a `CatspeakToken.IF`)
///   - `else` (is a `CatspeakToken.ELSE`)
///   - `12.3` (is a `CatspeakToken.VALUE`)
///   - `+`    (is a `CatspeakToken.PLUS`)
enum CatspeakToken {
    /// The `(` character.
    PAREN_LEFT = 0,
    /// The `)` character.
    PAREN_RIGHT = 1,
    /// The `[` character.
    BOX_LEFT = 2,
    /// The `]` character.
    BOX_RIGHT = 3,
    /// The `{` character.
    BRACE_LEFT = 4,
    /// The `}` character.
    BRACE_RIGHT = 5,
    /// The `:` character.
    COLON = 6,
    /// The `;` character.
    SEMICOLON = 7,
    /// The `,` character.
    COMMA = 8,
    /// The `.` operator.
    DOT = 9,
    /// The `=>` operator.
    ARROW = 10,
    /// @ignore
    __OP_ASSIGN_BEGIN__ = 11,
    /// The `=` operator.
    ASSIGN = 12,
    /// The `*=` operator.
    ASSIGN_MULTIPLY = 13,
    /// The `/=` operator.
    ASSIGN_DIVIDE = 14,
    /// The `-=` operator.
    ASSIGN_SUBTRACT = 15,
    /// The `+=` operator.
    ASSIGN_PLUS = 16,
    /// @ignore
    __OP_BEGIN__ = 17,
    /// The remainder `%` operator.
    REMAINDER = 18,
    /// The `*` operator.
    MULTIPLY = 19,
    /// The `/` operator.
    DIVIDE = 20,
    /// The integer division `//` operator.
    DIVIDE_INT = 21,
    /// The `-` operator.
    SUBTRACT = 22,
    /// The `+` operator.
    PLUS = 23,
    /// The relational `==` operator.
    EQUAL = 24,
    /// The relational `!=` operator.
    NOT_EQUAL = 25,
    /// The relational `>` operator.
    GREATER = 26,
    /// The relational `>=` operator.
    GREATER_EQUAL = 27,
    /// The relational `<` operator.
    LESS = 28,
    /// The relational `<=` operator.
    LESS_EQUAL = 29,
    /// The logical negation `!` operator.
    NOT = 30,
    /// The bitwise negation `~` operator.
    BITWISE_NOT = 31,
    /// The bitwise right shift `>>` operator.
    SHIFT_RIGHT = 32,
    /// The bitwise left shift `<<` operator.
    SHIFT_LEFT = 33,
    /// The bitwise and `&` operator.
    BITWISE_AND = 34,
    /// The bitwise xor `^` operator.
    BITWISE_XOR = 35,
    /// The bitwise or `|` operator.
    BITWISE_OR = 36,
    /// The logical `and` operator.
    AND = 37,
    /// The logical `or` operator.
    OR = 38,
    /// The logical `xor` operator.
    XOR = 39,
    /// The functional pipe right `|>` operator.
    PIPE_RIGHT = 40,
    /// The functional pipe left `<|` operator.
    PIPE_LEFT = 41,
    /// The `do` keyword.
    DO = 42,
    /// The `if` keyword.
    IF = 43,
    /// The `else` keyword.
    ELSE = 44,
    /// The `catch` keyword.
    CATCH = 66,
    /// The `while` keyword.
    WHILE = 45,
    /// The `for` keyword.
    ///
    /// @experimental
    FOR = 46,
    /// The `loop` keyword.
    ///
    /// @experimental
    LOOP = 47,
    /// The `with` keyword.
    ///
    /// @experimental
    WITH = 48,
    /// The `match` keyword.
    ///
    /// @experimental
    MATCH = 49,
    /// The `let` keyword.
    LET = 50,
    /// The `fun` keyword.
    FUN = 51,
    /// The `break` keyword.
    BREAK = 52,
    /// The `continue` keyword.
    CONTINUE = 53,
    /// The `return` keyword.
    RETURN = 54,
    /// The `throw` keyword.
    THROW = 67,
    /// The `new` keyword.
    NEW = 55,
    /// The `impl` keyword.
    ///
    /// @experimental
    IMPL = 56,
    /// The `self` keyword.
    ///
    /// @experimental
    SELF = 57,
    /// The `params` keyword.
    ///
    /// @experimental
    PARAMS = 58,
    /// The `params_count` keyword.
    ///
    /// @experimental
    PARAMS_COUNT = 65,
    /// Represents a variable name.
    IDENT = 59,
    /// Represents a GML value. This could be one of:
    ///  - string literal:    `"hello world"`
    ///  - verbatim literal:  `@"\(0_0)/ no escapes!"`
    ///  - integer:           `1`, `2`, `5`
    ///  - float:             `1.25`, `0.5`
    ///  - character:         `'A'`, `'0'`, `'\n'`
    ///  - boolean:           `true` or `false`
    ///  - `undefined`
    VALUE = 60,
    /// Represents a sequence of non-breaking whitespace characters.
    WHITESPACE = 61,
    /// Represents a comment.
    COMMENT = 62,
    /// Represents the end of the file.
    EOF = 63,
    /// Represents any other unrecognised character.
    ///
    /// @remark
    ///   If the compiler encounters a token of this type, it will typically
    ///   raise an exception. This likely indicates that a Catspeak script has
    ///   a syntax error somewhere.
    OTHER = 64,
    /// @ignore
    __SIZE__ = 68,
}


enum GMLspeakToken {
	__CATSPEAK_SIZE__ = CatspeakToken.__SIZE__,
	REPEAT,
	FOR,
	DO,
	UNTIL,
	SWITCH,
	CASE,
	DEFAULT,
	COMMENT_LONG,
	COMMENT_LONG_END,
	NULLISH,
	NULLISH_ASSIGN,
	OTHER,
	ROOM,
	ROOM_WIDTH,
	ROOM_HEIGHT,
	ROOM_PERSISTENT,
	VIEW_ENABLED,
	KEYBOARD_STRING,
	KEYBOARD_KEY,
	KEYBOARD_LASTCHAR,
	KEYBOARD_LASTKEY,
	MOUSE_LASTBUTTON,
	CURSOR_SPRITE,
	DOLLAR_SIGN,
	AT_SIGN,
	HASH_SIGN,
	QUESTION_MARK_SIGN,
	VERTICAL_BAR,
	__GMLINE__,
	__GMFILE__,
	__GMFUNCTION__,
    DELETE,
    FINALLY,
	EXIT,
    /// @ignore
    __SIZE__
}

/// Responsible for tokenising the contents of a GML buffer. This can be used
/// for syntax highlighting in a programming game which uses Catspeak.
///
/// @warning
///   The lexer does not take ownership of its buffer, so you must make sure
///   to delete the buffer once the lexer is complete. Failure to do this will
///   result in leaking memory.
///
/// @param {Id.Buffer} buff
///   The ID of the GML buffer to use.
///
/// @param {Real} [offset]
///   The offset in the buffer to start parsing from. Defaults to 0.
///
/// @param {Real} [size]
///   The length of the buffer input. Any characters beyond this limit
///   will be treated as the end of the file. Defaults to `infinity`.
///
/// @param {Struct} [keywords]
///   A struct whose keys map to the corresponding Catspeak tokens they
///   represent. Defaults to the vanilla set of Catspeak keywords.
function GMLspeakLexer(
    buff, offset=0, size=infinity, keywords=undefined
) constructor {
    if (CATSPEAK_DEBUG_MODE) {
        __catspeak_check_init();
        __catspeak_check_arg("buff", buff, buffer_exists);
        __catspeak_check_arg("offset", offset, is_numeric);
        __catspeak_check_arg("size", size, is_numeric);
        if (keywords != undefined) {
            __catspeak_check_arg("keywords", keywords, is_struct);
        }
    }
    /// @ignore
    self.buff = buff;
    /// @ignore
    self.buffAlignment = buffer_get_alignment(buff);
    /// @ignore
    self.buffCapacity = buffer_get_size(buff);
    /// @ignore
    self.buffOffset = clamp(offset, 0, self.buffCapacity);
    /// @ignore
    self.buffSize = clamp(offset + size, 0, self.buffCapacity);
    /// @ignore
    self.row = 1;
    /// @ignore
    self.column = 1;
    /// @ignore
    self.lexemeStart = self.buffOffset;
    /// @ignore
    self.lexemeEnd = self.lexemeStart;
    /// @ignore
    self.lexemePos = catspeak_location_create(self.row, self.column);
    /// @ignore
    self.lexeme = undefined;
    /// @ignore
    self.value = undefined;
    /// @ignore
    self.hasValue = false;
    /// @ignore
    self.peeked = undefined;
    /// @ignore
    self.charCurr = 0;
    /// @ignore
    //# feather disable once GM2043
    self.charNext = __nextUTF8Char();
    /// @ignore
    self.keywords = keywords ?? global.__catspeakString2Token;

    /// @ignore
    ///
    /// @return {Real}
    static __nextUTF8Char = function () {
        if (buffOffset >= buffSize) {
            return 0;
        }
        var byte = buffer_peek(buff, buffOffset, buffer_u8);
        buffOffset += 1;
        if ((byte & 0x80) == 0) { // if ((byte & 0b10000000) == 0) {
            // ASCII digit
            return byte;
        }
        var codepointCount;
        var headerMask;
        // parse UTF8 header, could maybe hand-roll a binary search
        if ((byte & 0xFC) == 0xFC) { // if ((byte & 0b11111100) == 0b11111100) {
            codepointCount = 5;
            headerMask = 0xFC;
        } else if ((byte & 0xF8) == 0xF8) { // } else if ((byte & 0b11111000) == 0b11111000) {
            codepointCount = 4;
            headerMask = 0xF8;
        } else if ((byte & 0xF0) == 0xF0) { // } else if ((byte & 0b11110000) == 0b11110000) {
            codepointCount = 3;
            headerMask = 0xF0;
        } else if ((byte & 0xE0) == 0xE0) { // } else if ((byte & 0b11100000) == 0b11100000) {
            codepointCount = 2;
            headerMask = 0xE0;
        } else if ((byte & 0xC0) == 0xC0) { // } else if ((byte & 0b11000000) == 0b11000000) {
            codepointCount = 1;
            headerMask = 0xC0;
        } else {
            //__catspeak_error("invalid UTF8 header codepoint '", byte, "'");
            return -1;
        }
        // parse UTF8 continuations (2 bit header, followed by 6 bits of data)
        var dataWidth = 6;
        var utf8Value = (byte & ~headerMask) << (codepointCount * dataWidth);
        for (var i = codepointCount - 1; i >= 0; i -= 1) {
            byte = buffer_peek(buff, buffOffset, buffer_u8);
            buffOffset += 1;
            if ((byte & 0x80) == 0) { // if ((byte & 0b10000000) == 0) {
                //__catspeak_error("invalid UTF8 continuation codepoint '", byte, "'");
                return -1;
            }
            utf8Value |= (byte & ~0xC0) << (i * dataWidth); // utf8Value |= (byte & ~0b11000000) << (i * dataWidth);
        }
        return utf8Value;
    };

    /// @ignore
    static __advance = function () {
        lexemeEnd = buffOffset;
        if (charNext == ord("\r")) {
            column = 1;
            row += 1;
        } else if (charNext == ord("\n")) {
            column = 1;
            if (charCurr != ord("\r")) {
                row += 1;
            }
        } else {
            column += 1;
        }
        // actually update chars now
        charCurr = charNext;
        charNext = __nextUTF8Char();
    };

    /// @ignore
    static __clearLexeme = function () {
        lexemeStart = lexemeEnd;
        lexemePos = catspeak_location_create(self.row, self.column);
        lexeme = undefined;
        hasValue = false;
    };

    /// @ignore
    ///
    /// @param {Real} start
    /// @param {Real} end_
    static __slice = function (start, end_) {
        var buff_ = buff;
        // don't read outside bounds of `buffSize`
        var clipStart = min(start, buffSize);
        var clipEnd = min(end_, buffSize);
        if (clipEnd <= clipStart) {
            // always an empty slice
            if (CATSPEAK_DEBUG_MODE && clipEnd < clipStart) {
                __catspeak_error_bug();
            }
            return "";
        } else if (clipEnd >= buffCapacity) {
            // beyond the actual capacity of the buffer
            // not safe to use `buffer_string`, which expects a null char
            return buffer_peek(buff_, clipStart, buffer_text);
        } else {
            // quickly write a null terminator and then read the content
            var byte = buffer_peek(buff_, clipEnd, buffer_u8);
            buffer_poke(buff_, clipEnd, buffer_u8, 0x00);
            var result = buffer_peek(buff_, clipStart, buffer_string);
            buffer_poke(buff_, clipEnd, buffer_u8, byte);
            return result;
        }
    };

    /// Returns the string representation of the most recent token emitted by
    /// the `next` or `nextWithWhitespace` methods.
    ///
    /// @example
    ///   Prints the string content of the first `GMLspeakToken` emitted by a
    ///   lexer.
    ///
    ///   ```gml
    ///   lexer.next();
    ///   show_debug_message(lexer.getLexeme());
    ///   ```
    ///
    /// @return {String}
    static getLexeme = function () {
        lexeme ??= __slice(lexemeStart, lexemeEnd);
        return lexeme;
    };

    /// @ignore
    ///
    /// @param {String} str
    static __getKeyword = function (str) {
        var keyword = keywords[$ str];
        if (CATSPEAK_DEBUG_MODE && keyword != undefined) {
            __catspeak_check_arg(
                    "keyword", keyword, __gmlspeak_is_token, "GMLspeakToken");
        }
        return keyword;
    };

    /// Returns the actual value representation of the most recent token
    /// emitted by the `next` or `nextWithWhitespace` methods.
    ///
    /// @remark
    ///   Unlike `getLexeme` this value is not always a string. For numeric
    ///   literals, the value will be converted into an integer or real.
    ///
    /// @return {Any}
    static getValue = function () {
        if (hasValue) {
            return value;
        }
        value = getLexeme();
        hasValue = true;
        return value;
    };

    /// Returns the location information for the most recent token emitted by
    /// the `next` or `nextWithWhitespace` methods.
    ///
    /// @return {Real}
    static getLocation = function () {
        return catspeak_location_create(row, column);
    };

    /// Advances the lexer and returns the next type of `GMLspeakToken`. This
    /// includes additional whitespace and comment tokens.
    ///
    /// @remark
    ///   To get the string content of the token, you should use the
    ///   `getLexeme` method.
    ///
    /// @example
    ///   Iterates through all tokens of a buffer containing Catspeak code,
    ///   printing each non-whitespace token out as a debug message.
    ///
    ///   ```gml
    ///   var lexer = new CatspeakLexer(buff);
    ///   do {
    ///     var token = lexer.nextWithWhitespace();
    ///     if (token != CatspeakToken.WHITESPACE) {
    ///       show_debug_message(lexer.getLexeme());
    ///     }
    ///   } until (token == CatspeakToken.EOF);
    ///   ```
    ///
    /// @return {Enum.GMLspeakToken}
    static nextWithWhitespace = function () {
        __clearLexeme();
        if (charNext == 0) {
            return CatspeakToken.EOF;
        }
        __advance();
        var token = CatspeakToken.OTHER;
        var charCurr_ = charCurr; // micro-optimisation, locals are faster
        if (charCurr_ >= 0 && charCurr_ < __CATSPEAK_CODEPAGE_SIZE) {
            token = global.__catspeakChar2Token[charCurr_];
        }
        if (
            charCurr_ == ord("\"") ||
            charCurr_ == ord("@") && charNext == ord("\"")
        ) {
            // strings
            var isRaw = charCurr_ == ord("@");
            if (isRaw) {
                token = CatspeakToken.VALUE; // since `@` is an operator
                __advance();
            }
            var skipNextChar = false;
            var processEscapes = false;
            while (true) {
                var charNext_ = charNext;
                if (charNext_ == 0) {
                    break;
                }
                if (skipNextChar) {
                    __advance();
                    skipNextChar = false;
                    continue;
                }
                if (!isRaw && charNext == ord("\\")) {
                    skipNextChar = true;
                    processEscapes = true;
                } else if (charNext_ == ord("\"")) {
                    break;
                }
                __advance();
            }
            var value_ = __slice(lexemeStart + (isRaw ? 2 : 1), lexemeEnd);
            if (charNext == ord("\"")) {
                __advance();
            }
            if (processEscapes) {
                // TODO :: may be very slow, figure out how to do it faster
                value_ = string_replace_all(value_, "\\\"", "\"");
                value_ = string_replace_all(value_, "\\t", "\t");
                value_ = string_replace_all(value_, "\\n", "\n");
                value_ = string_replace_all(value_, "\\v", "\v");
                value_ = string_replace_all(value_, "\\f", "\f");
                value_ = string_replace_all(value_, "\\r", "\r");
                value_ = string_replace_all(value_, "\\\\", "\\");
            }
            value = value_;
            hasValue = true;
        } else if (__catspeak_char_is_operator(charCurr_)) {
            // operators
            while (__catspeak_char_is_operator(charNext)) {
                __advance();
            }
            var keyword = __getKeyword(getLexeme());
            if (keyword != undefined) {
                token = keyword;
                if (keyword == CatspeakToken.COMMENT) {
                    // consume the comment
                    lexeme = undefined; // since the lexeme is now invalid
                                        // we have more work to do
                    while (true) {
                        var charNext_ = charNext;
                        if (
                            charNext_ == ord("\n") ||
                            charNext_ == ord("\r") ||
                            charNext_ == 0
                        ) {
                            break;
                        }
                        __advance();
                    }
                } 
            }
        } else if (charCurr_ == ord("`")) {
            // literal identifiers
            while (true) {
                var charNext_ = charNext;
                if (
                    charNext_ == ord("`") || charNext_ == 0 ||
                    __catspeak_char_is_whitespace(charNext_)
                ) {
                    break;
                }
                __advance();
            }
            value = __slice(lexemeStart + 1, lexemeEnd);
            hasValue = true;
            if (charNext == ord("`")) {
                __advance();
            }
        } else if (token == CatspeakToken.IDENT) {
            // alphanumeric identifiers
            while (__catspeak_char_is_alphanumeric(charNext)) {
                __advance();
            }
            var lexeme_ = getLexeme();
            var keyword = __getKeyword(lexeme_);
            // TODO :: optimise this into a lookup table?
            if (keyword != undefined) {
                token = keyword;
            } else if (lexeme_ == "true") {
                token = CatspeakToken.VALUE;
                value = true;
                hasValue = true;
            } else if (lexeme_ == "false") {
                token = CatspeakToken.VALUE;
                value = false;
                hasValue = true;
            } else if (lexeme_ == "undefined") {
                token = CatspeakToken.VALUE;
                value = undefined;
                hasValue = true;
            } else if (lexeme_ == "NaN") {
                token = CatspeakToken.VALUE;
                value = NaN;
                hasValue = true;
            } else if (lexeme_ == "infinity") {
                token = CatspeakToken.VALUE;
                value = infinity;
                hasValue = true;
            }
        } else if (charCurr_ == ord("'")) {
            // character literals
            __advance();
            value = charCurr;
            hasValue = true;
            if (charNext == ord("'")) {
                __advance();
            }
        } else if (
            charCurr_ == ord("0") &&
            (charNext == ord("x") || charNext == ord("X"))
        ) {
            // hexadecimal literals
            __advance();
            var digitStack = ds_stack_create();
            while (true) {
                var charNext_ = charNext;
                if (__catspeak_char_is_digit_hex(charNext_)) {
                    ds_stack_push(digitStack,
                            __catspeak_char_hex_to_dec(charNext_));
                    __advance();
                } else if (charNext_ == ord("_")) {
                    __advance();
                } else {
                    break;
                }
            }
            value = 0;
            var pow = 0;
            while (!ds_stack_empty(digitStack)) {
                value += power(16, pow) * ds_stack_pop(digitStack);
                pow += 1;
            }
            ds_stack_destroy(digitStack);
            hasValue = true;
        } else if (
            charCurr_ == ord("0") &&
            (charNext == ord("b") || charNext == ord("B"))
        ) {
            // TODO :: avoid code duplication here
            // binary literals
            __advance();
            var digitStack = ds_stack_create();
            while (true) {
                var charNext_ = charNext;
                if (__catspeak_char_is_digit_binary(charNext_)) {
                    ds_stack_push(digitStack,
                            __catspeak_char_binary_to_dec(charNext_));
                    __advance();
                } else if (charNext_ == ord("_")) {
                    __advance();
                } else {
                    break;
                }
            }
            value = 0;
            var pow = 0;
            while (!ds_stack_empty(digitStack)) {
                value += power(2, pow) * ds_stack_pop(digitStack);
                pow += 1;
            }
            ds_stack_destroy(digitStack);
            hasValue = true;
        } else if (charCurr_ == ord("#")) {
            // colour literals
            token = CatspeakToken.VALUE;
            var digitStack = ds_stack_create();
            while (true) {
                var charNext_ = charNext;
                if (__catspeak_char_is_digit_hex(charNext_)) {
                    ds_stack_push(digitStack,
                            __catspeak_char_hex_to_dec(charNext_));
                    __advance();
                } else if (charNext_ == ord("_")) {
                    __advance();
                } else {
                    break;
                }
            }
            var digitCount = ds_stack_size(digitStack);
            var cR = 0;
            var cG = 0;
            var cB = 0;
            var cA = 0;
            if (digitCount == 3) {
                // #RGB
                cB = ds_stack_pop(digitStack);
                cB = cB | (cB << 4);
                cG = ds_stack_pop(digitStack);
                cG = cG | (cG << 4);
                cR = ds_stack_pop(digitStack);
                cR = cR | (cR << 4);
            } else if (digitCount == 4) {
                // #RGBA
                cA = ds_stack_pop(digitStack);
                cA = cA | (cA << 4);
                cB = ds_stack_pop(digitStack);
                cB = cB | (cB << 4);
                cG = ds_stack_pop(digitStack);
                cG = cG | (cG << 4);
                cR = ds_stack_pop(digitStack);
                cR = cR | (cR << 4);
            } else if (digitCount == 6) {
                // #RRGGBB
                cB = ds_stack_pop(digitStack);
                cB = cB | (ds_stack_pop(digitStack) << 4);
                cG = ds_stack_pop(digitStack);
                cG = cG | (ds_stack_pop(digitStack) << 4);
                cR = ds_stack_pop(digitStack);
                cR = cR | (ds_stack_pop(digitStack) << 4);
            } else if (digitCount == 8) {
                // #RRGGBBAA
                cA = ds_stack_pop(digitStack);
                cA = cA | (ds_stack_pop(digitStack) << 4);
                cB = ds_stack_pop(digitStack);
                cB = cB | (ds_stack_pop(digitStack) << 4);
                cG = ds_stack_pop(digitStack);
                cG = cG | (ds_stack_pop(digitStack) << 4);
                cR = ds_stack_pop(digitStack);
                cR = cR | (ds_stack_pop(digitStack) << 4);
            } else {
                // Check for comment, hacky as hell
				var charNext_ = charNext;
				var char_ = 0;
				if (digitCount == 1) {
					char_ = ds_stack_top(digitStack) + ord("a") - 10;
				}
				if (charNext_ == ord("r") || digitCount == 1) {
					var word_ = "";
					if (digitCount == 1) {
						word_ += chr(char_);
					}
					while(charNext_ != ord("\n") && charNext_ != ord("\r") && charNext_ != ord(" ")) {
						word_ += chr(charNext_);
						__advance();
						charNext_ = charNext;
					}
					
					if (word_ == "region" || word_ == "endregion") {
						token = CatspeakToken.COMMENT;	
						// Keep on advancing until we get to the end
						while (true) {
							var charNext_ = charNext;
							if (
							    charNext_ == ord("\n") ||
							    charNext_ == ord("\r") ||
							    charNext_ == 0
							) {
							    break;
							}
							__advance();
						}
					}
				} else {
					 // invalid
					 token = CatspeakToken.OTHER;	
				}
            }
            ds_stack_destroy(digitStack);
            value = cR | (cG << 8) | (cB << 16) | (cA << 24);
            hasValue = true;
        } else if (token == CatspeakToken.VALUE) {
            // numeric literals
            var hasUnderscores = false;
            var hasDecimal = false;
            while (true) {
                var charNext_ = charNext;
                if (__catspeak_char_is_digit(charNext_)) {
                    __advance();
                } else if (charNext_ == ord("_")) {
                    __advance();
                    hasUnderscores = true;
                } else if (!hasDecimal && charNext_ == ord(".")) {
                    __advance();
                    hasDecimal = true;
                } else {
                    break;
                }
            }
            var digits = getLexeme();
            if (hasUnderscores) {
                digits = string_replace_all(digits, "_", "");
            }
            value = real(digits);
            hasValue = true;
        }
        return token;
    };

    /// Advances the lexer and returns the next `GMLspeakToken`, ignoring any
    /// comments, whitespace, and line continuations.
    ///
    /// @remark
    ///   To get the string content of the token, you should use the
    ///   `getLexeme` method.
    ///
    /// @example
    ///   Iterates through all tokens of a buffer containing Catspeak code,
    ///   printing each token out as a debug message.
    ///
    ///   ```gml
    ///   var lexer = new CatspeakLexer(buff);
    ///   do {
    ///     var token = lexer.next();
    ///     show_debug_message(lexer.getLexeme());
    ///   } until (token == CatspeakToken.EOF);
    ///   ```
    ///
    /// @return {Enum.GMLspeakToken}
    static next = function () {
        if (peeked != undefined) {
            var token = peeked;
            peeked = undefined;
            return token;
        }
        while (true) {
            var token = nextWithWhitespace();
            if (token == CatspeakToken.WHITESPACE
                    || token == CatspeakToken.COMMENT) {
                continue;
            } else if (token == GMLspeakToken.COMMENT_LONG) {
				while(token != GMLspeakToken.COMMENT_LONG_END) {
					token = nextWithWhitespace();
				}
				continue;
			}
            return token;
        }
    };

    /// Peeks at the next non-whitespace character without advancing the lexer.
    ///
    /// @example
    ///   Iterates through all tokens of a buffer containing Catspeak code,
    ///   printing each token out as a debug message.
    ///
    ///   ```gml
    ///   var lexer = new CatspeakLexer(buff);
    ///   while (lexer.peek() != CatspeakToken.EOF) {
    ///     lexer.next();
    ///     show_debug_message(lexer.getLexeme());
    ///   }
    ///   ```
    ///
    /// @return {Enum.GMLspeakToken}
    static peek = function () {
        peeked ??= next();
        return peeked;
    };
}

/// @ignore
///
/// @param {Any} val
function __gmlspeak_is_token(val) {
    // the user can modify what keywords are, so just check
    // that they've used one of the enum types instead of a
    // random ass value
    return is_numeric(val) && (
        val >= 0 && val < GMLspeakToken.__SIZE__
    );
}