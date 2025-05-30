/// Takes a reference to a Catspeak IR and converts it into a callable GML
/// function.
///
/// @experimental
///
/// @warning
///   Do not modify the the Catspeak IR whilst compilation is taking place.
///   This will cause **undefined behaviour**, potentially resulting in hard
///   to discover bugs!
///
/// @param {Struct} ir
///   The Catspeak IR to compile.
///
/// @param {Struct} [interface]
///   The native interface to use.
function GMLspeakCodegen(ir, interface=undefined) constructor {
    if (CATSPEAK_DEBUG_MODE) {
        __catspeak_check_init();
        __catspeak_check_arg_struct("ir", ir,
            "functions", is_array,
            "entryPoints", is_array
        );
    }
    /// @ignore
    self.interface = interface;
        
    // Fetching compile flags
    /// @ignore
    useVariableHash = (__getCompileFlag("useVariableHash") == true);
    /// @ignore
    checkForVariables = (__getCompileFlag("checkForVariables") == true);

    
    /// @ignore
    self.functions = ir.functions;
    /// @ignore
    self.sharedData = {
        globals : { },
        self_ : undefined,
    };
    //# feather disable once GM2043
    /// @ignore
    self.program = __compileFunctions(ir.entryPoints);
    /// @ignore
    self.finalised = false;
    /// @ignore
    ///
    /// @param {String} name
    /// @return {Any}
    static __get = function (name) {
        if (__catspeak_is_nullish(interface)) {
            return undefined;
        }
        return interface.get(name);
    }

    /// @ignore
    ///
    /// @param {String} name
    /// @return {Any}
    static __exists = function (name) {
        if (__catspeak_is_nullish(interface)) {
            return undefined;
        }
        return interface.exists(name);
    }

    /// @ignore
    ///
    /// @param {String} name
    /// @return {Bool}
    static __isDynamicConstant = function (name) {
        if (__catspeak_is_nullish(interface)) {
            return false;
        }
        return interface.isDynamicConstant(name);
    }

    /// Generates the code for a single term from the supplied Catspeak IR.
    ///
    /// @example
    ///   Creates a new `CatspeakGMLCompiler` from the variable `ir` and
    ///   loops until the compiler is finished compiling. The final result is
    ///   assigned to the `result` local variable.
    ///
    ///   ```gml
    ///   var compiler = new CatspeakGMLCompiler(ir);
    ///   var result;
    ///   do {
    ///       result = compiler.update();
    ///   } until (result != undefined);
    ///   ```
    ///
    /// @return {Function}
    ///   The final compiled Catspeak function if there are no more terms left
    ///   to compile, or `undefined` if there is still more left to compile.
    static update = function () {
        if (CATSPEAK_DEBUG_MODE && finalised) {
            __catspeak_error(
                "attempting to update gml compiler after it has been finalised"
            );
        }
        finalised = true;
        return program;
    };

    /// @ignore
    ///
    /// @param {Array} entryPoints
    /// @return {Function}
    static __compileFunctions = function (entryPoints) {
        var functions_ = functions;
        var entryCount = array_length(entryPoints);
        var exprs = array_create(entryCount);
        for (var i = 0; i < entryCount; i += 1) {
            var entry = entryPoints[i];
            if (CATSPEAK_DEBUG_MODE) {
                __catspeak_check_arg("entry", entry, is_numeric);
            }
            exprs[@ i] = __compileFunction(functions_[entry]);
        }
        var rootCall = __emitBlock(exprs);
        __setupCatspeakFunctionMethods(rootCall);
        return rootCall;
    };

    /// @ignore
    static __setupCatspeakFunctionMethods = function (f) {
        f.setSelf = method(sharedData, function (selfInst) {
            self_ = selfInst == undefined
                    ? undefined
                    : catspeak_special_to_struct(selfInst);
        });
        f.setGlobals = method(sharedData, function (globalInst) {
            var newGlobals = catspeak_special_to_struct(globalInst);
            if (newGlobals != undefined) {
                globals = newGlobals;
            }
        });
        f.getSelf = method(sharedData, function () { return self_ });
        f.getGlobals = method(sharedData, function () { return globals });
    };

    /// @ignore
    ///
    /// @param {Struct} func
    /// @return {Function}
    static __compileFunction = function (func) {
        if (CATSPEAK_DEBUG_MODE) {
            __catspeak_check_arg_struct("func", func,
                "localCount", is_numeric,
                "argCount", is_numeric,
                "root", undefined
            );
            __catspeak_check_arg_struct("func.root", func.root,
                "type", is_numeric
            );
        }
        var ctx = {
            callTime : -1,
            program : undefined,
            locals : array_create(func.localCount),
            argCount : func.argCount,
            args : array_create(func.argCount),
            currentArgCount: 0,
        };
        ctx.program = __compileTerm(ctx, func.root);
        if (__catspeak_term_is_pure(func.root.type)) {
            // if there's absolutely no way this function could misbehave,
            // use the fast path
            return ctx.program;
        }
        return method(ctx, __catspeak_function__);
    };

    /// @ignore
    ///
    /// @param {Struct} ctx
    /// @param {Struct} term
    /// @return {Function}
    static __compileValue = function (ctx, term) {
        if (CATSPEAK_DEBUG_MODE) {
            __catspeak_check_arg_struct("term", term,
                "value", undefined
            );
        }
        return method({ value : term.value }, __catspeak_expr_value__);
    };

    /// @ignore
    ///
    /// @param {Struct} ctx
    /// @param {Struct} term
    /// @return {Function}
    static __compileArray = function (ctx, term) {
        if (CATSPEAK_DEBUG_MODE) {
            __catspeak_check_arg_struct("term", term,
                "values", is_array
            );
        }
        var values = term.values;
        var valueCount = array_length(values);
        var exprs = array_create(valueCount);
        for (var i = 0; i < valueCount; i += 1) {
            exprs[@ i] = __compileTerm(ctx, values[i]);
        }
        return method({
            values : exprs,
            n : array_length(exprs),
        }, __catspeak_expr_array__);
    };

    /// @ignore
    ///
    /// @param {Struct} ctx
    /// @param {Struct} term
    /// @return {Function}
    static __compileStruct = function (ctx, term) {
        if (CATSPEAK_DEBUG_MODE) {
            __catspeak_check_arg_struct("term", term,
                "values", is_array
            );
        }
        var values = term.values;
        var valueCount = array_length(values);
        var exprs = array_create(valueCount);
        for (var i = 0; i < valueCount; i += 1) {
            exprs[@ i] = __compileTerm(ctx, values[i]);
        }
        return method({
            values : exprs,
            n : array_length(exprs) div 2,
        }, __catspeak_expr_struct__);
    };

    /// @ignore
    ///
    /// @param {Struct} ctx
    /// @param {Struct} term
    /// @return {Function}
    static __compileBlock = function (ctx, term) {
        if (CATSPEAK_DEBUG_MODE) {
            __catspeak_check_arg_struct("term", term,
                "terms", is_array
            );
        }
        var terms = term.terms;
        var termCount = array_length(terms);
        var exprs = array_create(termCount);
        for (var i = 0; i < termCount; i += 1) {
            exprs[@ i] = __compileTerm(ctx, terms[i]);
        }
        return __emitBlock(exprs);
    };

    /// @ignore
    ///
    /// @param {Array} exprs
    /// @return {Function}
    static __emitBlock = function (exprs) {
        var exprCount = array_length(exprs);
        // hard-code some common block sizes
        if (exprCount == 1) {
            return exprs[0];
        } else if (exprCount == 2) {
            return method({
                _1st : exprs[0],
                _2nd : exprs[1],
            }, __catspeak_expr_block_2__);
        } else if (exprCount == 3) {
            return method({
                _1st : exprs[0],
                _2nd : exprs[1],
                _3rd : exprs[2],
            }, __catspeak_expr_block_3__);
        } else if (exprCount == 4) {
            return method({
                _1st : exprs[0],
                _2nd : exprs[1],
                _3rd : exprs[2],
                _4th : exprs[3],
            }, __catspeak_expr_block_4__);
        } else if (exprCount == 5) {
            return method({
                _1st : exprs[0],
                _2nd : exprs[1],
                _3rd : exprs[2],
                _4th : exprs[3],
                _5th : exprs[4],
            }, __catspeak_expr_block_5__);
        }
        // arbitrary size block
        return method({
            stmts : exprs,
            n : exprCount - 1,
            result : exprs[exprCount - 1],
        }, __catspeak_expr_block__);
    };

    /// @ignore
    ///
    /// @param {Struct} ctx
    /// @param {Struct} term
    /// @return {Function}
    static __compileIf = function (ctx, term) {
        if (CATSPEAK_DEBUG_MODE) {
            __catspeak_check_arg_struct("term", term,
                "condition", undefined,
                "ifTrue", undefined,
                "ifFalse", undefined
            );
        }
        if (__catspeak_is_nullish(term.ifFalse)) {
            return method({
                condition : __compileTerm(ctx, term.condition),
                ifTrue : __compileTerm(ctx, term.ifTrue),
            }, __catspeak_expr_if__);
        } else {
            return method({
                condition : __compileTerm(ctx, term.condition),
                ifTrue : __compileTerm(ctx, term.ifTrue),
                ifFalse : __compileTerm(ctx, term.ifFalse),
            }, __catspeak_expr_if_else__);
        }
    };

    /// @ignore
    ///
    /// @param {Struct} ctx
    /// @param {Struct} term
    /// @return {Function}
    static __compileCatch = function (ctx, term) {
        if (CATSPEAK_DEBUG_MODE) {
            __catspeak_check_arg_struct("term", term,
                "eager", undefined,
                "lazy", undefined,
                "localRef", undefined
            );
            __catspeak_check_arg_struct("term.localRef", term.localRef,
                "idx", is_numeric
            );
        }        
        return method({
            eager : __compileTerm(ctx, term.eager),
            lazy : __compileTerm(ctx, term.lazy),
            locals : ctx.locals,
            idx : term.localRef.idx,
        }, __catspeak_expr_catch__);
    };

    /// @ignore
    ///
    /// @param {Struct} ctx
    /// @param {Struct} term
    /// @return {Function}
    static __compileLoop = function (ctx, term) {
        if (CATSPEAK_DEBUG_MODE) {
            __catspeak_check_arg_struct("term", term,
                "preCondition", undefined,
                "postCondition", undefined,
                "step", undefined,
                "body", undefined
            );
        }
        var preCondition_ = term.preCondition == undefined
                ? undefined : __compileTerm(ctx, term.preCondition);
        var body_ = term.body == undefined
                ? undefined : __compileTerm(ctx, term.body);
        var postCondition_ = term.postCondition == undefined
                ? undefined : __compileTerm(ctx, term.postCondition);
        var step_ = term.step == undefined
                ? undefined : __compileTerm(ctx, term.step);
        if (
            preCondition_ != undefined &&
            postCondition_ == undefined
        ) {
            if (term.step == undefined) {
                return method({
                    ctx : ctx,
                    condition : preCondition_,
                    body : body_,
                }, __catspeak_expr_loop_while__);
            } else {
                return method({
                    ctx : ctx,
                    condition : preCondition_,
                    body : body_,
                    step : step_,
                }, __catspeak_expr_loop_for__);
            }
        }
        if (
            preCondition_ == undefined &&
            postCondition_ != undefined &&
            step_ == undefined
        ) {
            return method({
                ctx : ctx,
                condition : postCondition_,
                body : body_,
            }, __catspeak_expr_loop_do__);
        }
        
        return method({
            ctx : ctx,
            preCondition : preCondition_,
            postCondition : postCondition_,
            step : step_,
            body : body_,
        }, __catspeak_expr_loop_general__);
    };

    /// @ignore
    ///
    /// @param {Struct} ctx
    /// @param {Struct} term
    /// @return {Function}
    static __compileWith = function(ctx, term) {
        if (CATSPEAK_DEBUG_MODE) {
            __catspeak_check_arg_struct("term", term,
                "scope", undefined,
                "body", undefined
            );
        }
        return method({
            scope : __compileTerm(ctx, term.scope),
            body : __compileTerm(ctx, term.body),
        }, __catspeak_expr_loop_with__);
    };

    /// @ignore
    ///
    /// @param {Struct} ctx
    /// @param {Struct} term
    /// @return {Function}
    static __compileMatch = function(ctx, term) {
        var i = 0;
        var n = array_length(term.arms);
        repeat n {
            var pair = term.arms[i];
            var condition = __catspeak_is_nullish(pair[0])
                    ? undefined
                    : __compileTerm(ctx, pair[0]);
            term.arms[i] = {
                condition : condition,
                result : __compileTerm(ctx, pair[1]),
            };
            i += 1;
        }
        return method({
            value: __compileTerm(ctx, term.value),
            arms: term.arms,
        }, __catspeak_expr_match__);
    };

    /// @ignore
    ///
    /// @param {Struct} ctx
    /// @param {Struct} term
    /// @return {Function}
    static __compileReturn = function (ctx, term) {
        if (CATSPEAK_DEBUG_MODE) {
            __catspeak_check_arg_struct("term", term,
                "value", undefined
            );
        }
        return method({
            value : __compileTerm(ctx, term.value),
        }, __catspeak_expr_return__);
    };

    /// @ignore
    ///
    /// @param {Struct} ctx
    /// @param {Struct} term
    /// @return {Function}
    static __compileBreak = function (ctx, term) {
        if (CATSPEAK_DEBUG_MODE) {
            __catspeak_check_arg_struct("term", term,
                "value", undefined
            );
        }
        return method({
            value : __compileTerm(ctx, term.value),
        }, __catspeak_expr_break__);
    };

    /// @ignore
    ///
    /// @param {Struct} ctx
    /// @param {Struct} term
    /// @return {Function}
    static __compileContinue = function (ctx, term) {
        return method(undefined, __catspeak_expr_continue__);
    };

    /// @ignore
    ///
    /// @param {Struct} ctx
    /// @param {Struct} term
    /// @return {Function}
    static __compileThrow = function (ctx, term) {
        if (CATSPEAK_DEBUG_MODE) {
            __catspeak_check_arg_struct("term", term,
                "value", undefined
            );
        }
        return method({
            value : __compileTerm(ctx, term.value),
        }, __catspeak_expr_throw__);
    };

    /// @ignore
    ///
    /// @param {Struct} ctx
    /// @param {Struct} term
    /// @return {Function}
    static __compileOpUnary = function (ctx, term) {
        if (CATSPEAK_DEBUG_MODE) {
            __catspeak_check_arg_struct("term", term,
                "operator", is_numeric, // TODO :: add proper bounds check here
                "value", undefined
            );
        }
        return method({
            op : __catspeak_operator_get_unary(term.operator),
            value : __compileTerm(ctx, term.value),
        }, __catspeak_expr_op_1__);
    };

    /// @ignore
    ///
    /// @param {Struct} ctx
    /// @param {Struct} term
    /// @return {Function}
    static __compileOpBinary = function (ctx, term) {
        if (CATSPEAK_DEBUG_MODE) {
            __catspeak_check_arg_struct("term", term,
                "operator", is_numeric, // TODO :: add proper bounds check here
                "lhs", undefined,
                "rhs", undefined
            );
        }
        return method({
            op : __catspeak_operator_get_binary(term.operator),
            lhs : __compileTerm(ctx, term.lhs),
            rhs : __compileTerm(ctx, term.rhs),
        }, __catspeak_expr_op_2__);
    };

    /// @ignore
    ///
    /// @param {Struct} ctx
    /// @param {Struct} term
    /// @return {Function}
    static __compileAnd = function (ctx, term) {
        if (CATSPEAK_DEBUG_MODE) {
            __catspeak_check_arg_struct("term", term,
                "eager", undefined,
                "lazy", undefined
            );
        }
        return method({
            eager : __compileTerm(ctx, term.eager),
            lazy : __compileTerm(ctx, term.lazy),
        }, __catspeak_expr_and__);
    };

    /// @ignore
    ///
    /// @param {Struct} ctx
    /// @param {Struct} term
    /// @return {Function}
    static __compileOr = function (ctx, term) {
        if (CATSPEAK_DEBUG_MODE) {
            __catspeak_check_arg_struct("term", term,
                "eager", undefined,
                "lazy", undefined
            );
        }
        return method({
            eager : __compileTerm(ctx, term.eager),
            lazy : __compileTerm(ctx, term.lazy),
        }, __catspeak_expr_or__);
    };

    /// @ignore
    ///
    /// @param {Struct} ctx
    /// @param {Struct} term
    /// @return {Function}
    static __compileCall = function (ctx, term) {
        if (CATSPEAK_DEBUG_MODE) {
            __catspeak_check_arg_struct("term", term,
                "callee", undefined,
                "args", undefined
            );
            __catspeak_check_arg_struct("term.callee", term.callee,
                "type", is_numeric
            );
        }
        
        var isCompileTimeCallable = false;
        var conditionFailed = false;
        var args = term.args;
        var argCount = array_length(args);
        var exprs = array_create(argCount);
        for (var i = 0; i < argCount; i += 1) {
            exprs[@ i] = __compileTerm(ctx, args[i]);
        }
        var dbgError = __dbgTerm(term.callee, "is not a function");
        if (term.callee.type == CatspeakTerm.INDEX) {
            if (CATSPEAK_DEBUG_MODE) {
                __catspeak_check_arg_struct("term.callee", term.callee,
                    "collection", undefined,
                    "key", undefined
                );
            }
            var collection = __compileTerm(ctx, term.callee.collection);
            var key = __compileTerm(ctx, term.callee.key);
            var result = method({
                dbgError : dbgError,
                collection : collection,
                key : key,
                args : exprs,
                shared : sharedData,
                }, __catspeak_expr_call_method__);
                
            if (checkForVariables) {
                return method({
                    result: result,
                    key: key,
                    collection: collection,
                    hash_: useVariableHash && is_string(term.callee.key) ? variable_get_hash(term.callee.key) : -1,
                    dbgError : __dbgTerm(term.callee.key, "is not defined."),
                }, useVariableHash ? __gmlspeak_expr_index_check_hash__ : 
                    __gmlspeak_expr_index_check__
                );   
            }
            
            return result;
        } else { 
            var callee = __compileTerm(ctx, term.callee);
            var func = __catspeak_expr_call__;
            switch (array_length(exprs)) {
            case 0: func = __catspeak_expr_call_0__; break;
            case 1: func = __catspeak_expr_call_1__; break;
            case 2: func = __catspeak_expr_call_2__; break;
            case 3: func = __catspeak_expr_call_3__; break;
            case 4: func = __catspeak_expr_call_4__; break;
            case 5: func = __catspeak_expr_call_5__; break;
            }
            return method({
                dbgError : dbgError,
                callee : callee,
                args : exprs,
                shared : sharedData,
            }, func);
        }
    };

    /// @ignore
    ///
    /// @param {Struct} ctx
    /// @param {Struct} term
    /// @return {Function}
    static __compileCallNew = function (ctx, term) {
        // NOTE :: blehhh ugly code pls pls refactor fr fr ong no cap
        if (CATSPEAK_DEBUG_MODE) {
            __catspeak_check_arg_struct("term", term,
                "callee", undefined,
                "args", undefined
            );
            __catspeak_check_arg_struct("term.callee", term.callee,
                "type", is_numeric
            );
        }
        var args = term.args;
        var argCount = array_length(args);
        var exprs = array_create(argCount);
        for (var i = 0; i < argCount; i += 1) {
            exprs[@ i] = __compileTerm(ctx, args[i]);
        }
        var callee = __compileTerm(ctx, term.callee);
        return method({
            dbgError : __dbgTerm(term.callee, "is not constructible"),
            callee : callee,
            args : exprs,
        }, __catspeak_expr_call_new__);
    };

    /// @ignore
    ///
    /// @param {Struct} ctx
    /// @param {Struct} term
    /// @return {Function}
    static __compileSet = function (ctx, term) {
        if (CATSPEAK_DEBUG_MODE) {
            __catspeak_check_arg_struct("term", term,
                "assignType", is_numeric,
                "target", undefined,
                "value", undefined,
            );
            __catspeak_check_arg_struct("term.target", term.target,
                "type", is_numeric
            );
        }
        var target = term.target;
        var targetType = target.type;
        var value = __compileTerm(ctx, term.value);
        if (targetType == CatspeakTerm.INDEX) {
            if (CATSPEAK_DEBUG_MODE) {
                __catspeak_check_arg_struct("term.target", target,
                    "collection", undefined,
                    "key", undefined
                );
            }
            var func = useVariableHash ? 
                        __assignLookupIndexHash[term.assignType] :
                        __assignLookupIndex[term.assignType];
            var result = method({
                dbgError : __dbgTerm(target.collection, "is not indexable"),
                collection : __compileTerm(ctx, target.collection),
                key : __compileTerm(ctx, target.key),
                hash_ : useVariableHash && is_string(target.key.key) ? variable_get_hash(target.key.key) : -1,
                value : value,
            }, func);
			
			if (checkForVariables) && (term.assignType != CatspeakAssign.VANILLA) {
				return method({
					dbgError : __dbgTerm(target.key, "is not defined."),
					collection : __compileTerm(ctx, target.collection),
					key : __compileTerm(ctx, target.key),
					hash_: useVariableHash && is_string(target.key.key) ? variable_get_hash(target.key.key) : -1,
					result: result,
				}, useVariableHash ? 
						__gmlspeak_expr_index_check_hash__ : 
						__gmlspeak_expr_index_check__
				);
			}

			return result;	
        } else if (targetType == CatspeakTerm.PROPERTY) {
            if (CATSPEAK_DEBUG_MODE) {
                __catspeak_check_arg_struct("term.target", target,
                    "property", undefined
                );
            }
            var func = __assignLookupProperty[term.assignType];
            return method({
                dbgError : __dbgTerm(target.property, "is not a function"),
                property : __compileTerm(ctx, target.property),
                value : value,
            }, func);
        } else if (targetType == CatspeakTerm.LOCAL) {
            if (CATSPEAK_DEBUG_MODE) {
                __catspeak_check_arg_struct("term.target", target,
                    "idx", is_numeric
                );
            }
            var func = __assignLookupLocal[term.assignType];
            return method({
                locals : ctx.locals,
                idx : target.idx,
                value : value,
            }, func);
        } else if (targetType == CatspeakTerm.GLOBAL) {
            if (CATSPEAK_DEBUG_MODE) {
                __catspeak_check_arg_struct("term.target", target,
                    "name", is_string
                );
            }
            var name = target.name;
            if (__exists(name)) {
                // cannot assign to interface values
                __catspeak_error(
                    __catspeak_location_show(target.dbg),
                    " -- invalid assignment target, ",
                    "cannot assign to built-in function or constant"
                );
            }

            var func = __assignLookupGlobal[term.assignType];
            return method({
                shared : sharedData,
                name : name,
                value : value,
            }, func);
        } else {
            if (CATSPEAK_DEBUG_MODE) {
                __catspeak_check_arg_struct("term.target", target,
                    "dbg", undefined
                );
            }
            __catspeak_error(
                __catspeak_location_show(target.dbg),
                " -- invalid assignment target, ",
                "must be an identifier or accessor expression"
            );
        }
    };

    /// @ignore
    ///
    /// @param {Struct} ctx
    /// @param {Struct} term
    /// @return {Function}
    static __compileIndex = function (ctx, term) {
        if (CATSPEAK_DEBUG_MODE) {
            __catspeak_check_arg_struct("term", term,
                "collection", undefined,
                "key", undefined
            );
        }
        
        var getter = useVariableHash ? 
            __gmlspeak_expr_index_get_hash__ : 
            __catspeak_expr_index_get__;
        
        var result = method({
                dbgError : __dbgTerm(term.collection, "is not indexable"),
                collection : __compileTerm(ctx, term.collection),
                key : __compileTerm(ctx, term.key),
				hash_ : useVariableHash && is_string(term.key.value) ? variable_get_hash(term.key.value) : -1,
            }, getter);
        
        // Adds variable check
        if (checkForVariables) {
            return method({
                dbgError : __dbgTerm(term.key, "is not defined."),
                collection : __compileTerm(ctx, term.collection),
                key : __compileTerm(ctx, term.key),
                hash_: useVariableHash && is_string(term.key.value) ? variable_get_hash(term.key.value) : -1,
                result: result,
            }, useVariableHash ? 
                    __gmlspeak_expr_index_check_hash__ : 
                    __gmlspeak_expr_index_check__
                );
        };
        
        return result;
    };

    /// @ignore
    ///
    /// @param {Struct} ctx
    /// @param {Struct} term
    /// @return {Function}
    static __compileProperty = function (ctx, term) {
        if (CATSPEAK_DEBUG_MODE) {
            __catspeak_check_arg_struct("term", term,
                "property", undefined
            );
        }
        return method({
            dbgError : __dbgTerm(term.property, "is not a function"),
            property : __compileTerm(ctx, term.property),
        }, __catspeak_expr_property_get__);
    };

    /// @ignore
    ///
    /// @param {Struct} ctx
    /// @param {Struct} term
    /// @return {Function}
    static __compileGlobal = function (ctx, term) {
        if (CATSPEAK_DEBUG_MODE) {
            __catspeak_check_arg_struct("term", term,
                "name", is_string
            );
        }
        var name = term.name;
        if (__exists(name)) {
            var _callee = method({
                value : __get(name),
            }, __catspeak_expr_value__);
            if (__isDynamicConstant(name)) {
                // dynamic constant
                return method({
                    dbgError : __dbgTerm(term, "is not a function"),
                    callee : _callee,
                    shared : sharedData,
                }, __catspeak_expr_call_0__);
            } else {
                // user-defined interface
                return _callee;
            }
        } else {
            // global var
            return method({
                name : name,
                shared : sharedData,
            }, __catspeak_expr_global_get__);
        }
    };

    /// @ignore
    ///
    /// @param {Struct} ctx
    /// @param {Struct} term
    /// @return {Function}
    static __compileLocal = function (ctx, term) {
        if (CATSPEAK_DEBUG_MODE) {
            __catspeak_check_arg_struct("term", term,
                "idx", is_numeric
            );
        }
        return method({
            locals : ctx.locals,
            idx : term.idx,
        }, __catspeak_expr_local_get__);
    };
    
    /// @ignore
    ///
    /// @param {Struct} ctx
    /// @param {Struct} term
    /// @return {Function}
    static __compileParams = function (ctx, term) {
        if (CATSPEAK_DEBUG_MODE) {
            __catspeak_check_arg_struct("term", term,
                "key", is_struct
            );
        }
        return method({
            args : ctx.args,
            key : __compileTerm(ctx, term.key),
        }, __catspeak_expr_params_get__);
    };
    
    /// @ignore
    ///
    /// @param {Struct} ctx
    /// @param {Struct} term
    /// @return {Function}
    static __compileParamsCount = function (ctx, term) {
        if (CATSPEAK_DEBUG_MODE) {
            __catspeak_check_arg_struct("term", term);
        }
        return method(ctx, __catspeak_expr_params_count_get__);
    };

    /// @ignore
    ///
    /// @param {Struct} ctx
    /// @param {Struct} term
    /// @return {Function}
    static __compileFunctionExpr = function (ctx, term) {
        if (CATSPEAK_DEBUG_MODE) {
            __catspeak_check_arg_struct("term", term,
                "idx", is_numeric
            );
        }
        var funcExpr = __compileFunction(functions[term.idx]);
        __setupCatspeakFunctionMethods(funcExpr);
        return method({
            value : funcExpr,
        }, __catspeak_expr_value__);
    };

    /// @ignore
    ///
    /// @param {Struct} ctx
    /// @param {Struct} term
    /// @return {Function}
    static __compileSelf = function (ctx, term) {
        return method(sharedData, __catspeak_expr_self__);
    };

    /// @ignore
    ///
    /// @param {Struct} ctx
    /// @param {Struct} term
    /// @return {Function}
    static __compileOther = function (ctx, term) {
        return method(sharedData, __catspeak_expr_other__);
    };

    /// @ignore
    ///
    /// @param {Struct} ctx
    /// @param {Struct} term
    /// @return {Function}
    static __compileTerm = function (ctx, term) {
        if (CATSPEAK_DEBUG_MODE) {
            __catspeak_check_arg_struct("term", term,
                "type", is_numeric
            );
        }
        var prod = __productionLookup[term.type];
        if (CATSPEAK_DEBUG_MODE && __catspeak_is_nullish(prod)) {
            __catspeak_error_bug();
        }
        return prod(ctx, term);
    };

    /// @ignore
    static __productionLookup = (function () {
        var db = array_create(CatspeakTerm.__SIZE__, undefined);
        db[@ CatspeakTerm.VALUE] = __compileValue;
        db[@ CatspeakTerm.ARRAY] = __compileArray;
        db[@ CatspeakTerm.STRUCT] = __compileStruct;
        db[@ CatspeakTerm.BLOCK] = __compileBlock;
        db[@ CatspeakTerm.IF] = __compileIf;
        db[@ CatspeakTerm.CATCH] = __compileCatch;
        db[@ CatspeakTerm.LOOP] = __compileLoop;
        db[@ CatspeakTerm.WITH] = __compileWith;
        db[@ CatspeakTerm.MATCH] = __compileMatch;
        db[@ CatspeakTerm.RETURN] = __compileReturn;
        db[@ CatspeakTerm.BREAK] = __compileBreak;
        db[@ CatspeakTerm.CONTINUE] = __compileContinue;
        db[@ CatspeakTerm.THROW] = __compileThrow;
        db[@ CatspeakTerm.OP_BINARY] = __compileOpBinary;
        db[@ CatspeakTerm.OP_UNARY] = __compileOpUnary;
        db[@ CatspeakTerm.CALL] = __compileCall;
        db[@ CatspeakTerm.CALL_NEW] = __compileCallNew;
        db[@ CatspeakTerm.SET] = __compileSet;
        db[@ CatspeakTerm.INDEX] = __compileIndex;
        db[@ CatspeakTerm.PROPERTY] = __compileProperty;
        db[@ CatspeakTerm.GLOBAL] = __compileGlobal;
        db[@ CatspeakTerm.LOCAL] = __compileLocal;
        db[@ CatspeakTerm.FUNCTION] = __compileFunctionExpr;
        db[@ CatspeakTerm.SELF] = __compileSelf;
        db[@ CatspeakTerm.OTHER] = __compileOther;
        db[@ CatspeakTerm.AND] = __compileAnd;
        db[@ CatspeakTerm.OR] = __compileOr;
        db[@ CatspeakTerm.PARAMS] = __compileParams;
        db[@ CatspeakTerm.PARAMS_COUNT] = __compileParamsCount;
        return db;
    })();

    /// @ignore
    static __assignLookupIndex = (function () {
        var db = array_create(CatspeakAssign.__SIZE__, undefined);
        db[@ CatspeakAssign.VANILLA] = __catspeak_expr_index_set__;
        db[@ CatspeakAssign.MULTIPLY] = __catspeak_expr_index_set_mult__;
        db[@ CatspeakAssign.DIVIDE] = __catspeak_expr_index_set_div__;
        db[@ CatspeakAssign.SUBTRACT] = __catspeak_expr_index_set_sub__;
        db[@ CatspeakAssign.PLUS] = __catspeak_expr_index_set_plus__;
        return db;
    })();
    
    /// @ignore
    static __assignLookupIndexHash = (function () {
        var db = array_create(CatspeakAssign.__SIZE__, undefined);
        db[@ CatspeakAssign.VANILLA] = __gmlspeak_expr_index_set_hash__;
        db[@ CatspeakAssign.MULTIPLY] = __gmlspeak_expr_index_set_mult_hash__;
        db[@ CatspeakAssign.DIVIDE] = __gmlspeak_expr_index_set_div_hash__;
        db[@ CatspeakAssign.SUBTRACT] = __gmlspeak_expr_index_set_sub_hash__;
        db[@ CatspeakAssign.PLUS] = __gmlspeak_expr_index_set_plus_hash__;
        return db;
    })();

    /// @ignore
    static __assignLookupProperty = (function () {
        var db = array_create(CatspeakAssign.__SIZE__, undefined);
        db[@ CatspeakAssign.VANILLA] = __catspeak_expr_property_set__;
        db[@ CatspeakAssign.MULTIPLY] = __catspeak_expr_property_set_mult__;
        db[@ CatspeakAssign.DIVIDE] = __catspeak_expr_property_set_div__;
        db[@ CatspeakAssign.SUBTRACT] = __catspeak_expr_property_set_sub__;
        db[@ CatspeakAssign.PLUS] = __catspeak_expr_property_set_plus__;
        return db;
    })();

    /// @ignore
    static __assignLookupLocal = (function () {
        var db = array_create(CatspeakAssign.__SIZE__, undefined);
        db[@ CatspeakAssign.VANILLA] = __catspeak_expr_local_set__;
        db[@ CatspeakAssign.MULTIPLY] = __catspeak_expr_local_set_mult__;
        db[@ CatspeakAssign.DIVIDE] = __catspeak_expr_local_set_div__;
        db[@ CatspeakAssign.SUBTRACT] = __catspeak_expr_local_set_sub__;
        db[@ CatspeakAssign.PLUS] = __catspeak_expr_local_set_plus__;
        return db;
    })();

    /// @ignore
    static __assignLookupGlobal = (function () {
        var db = array_create(CatspeakAssign.__SIZE__, undefined);
        db[@ CatspeakAssign.VANILLA] = __catspeak_expr_global_set__;
        db[@ CatspeakAssign.MULTIPLY] = __catspeak_expr_global_set_mult__;
        db[@ CatspeakAssign.DIVIDE] = __catspeak_expr_global_set_div__;
        db[@ CatspeakAssign.SUBTRACT] = __catspeak_expr_global_set_sub__;
        db[@ CatspeakAssign.PLUS] = __catspeak_expr_global_set_plus__;
        return db;
    })();
    
    /// @ignore
    static __hasCompileFlag = function(flagName) {
        return variable_struct_exists(interface.compileFlags, flagName);   
    }
    
    static __getCompileFlag = function(flagName) {
        if (!__hasCompileFlag(flagName)) {
            return undefined;
        }
        
        return interface.compileFlags[$ flagName];   
    }

    /// @ignore
    static __dbgTerm = function (term, msg="is invalid in this context") {
        if (CATSPEAK_DEBUG_MODE) {
            __catspeak_check_arg_struct("term", term,
                "dbg", undefined
            );
        }
        var terminalName = __catspeak_term_get_terminal(term);
        return "runtime error " + __catspeak_location_show_ext(term.dbg,
            __catspeak_is_nullish(terminalName)
                    ? "value"
                    : "variable '" + terminalName + "'",
            " ", msg
        );
    };
}

// @ignore
/// @return {Any}
function __gmlspeak_expr_index_check__() {
    var collection_ = collection();
    var key_ = key();
    if (__catspeak_is_withable(collection_)) {
        if (!variable_struct_exists(collection_, key_)) {
            __catspeak_error(dbgError);
        }
    }
    
    return result();
}

// @ignore
/// @return {Any}
function __gmlspeak_expr_index_check_hash__() {
    var collection_ = collection();
    // var key_ = key();
    if (__catspeak_is_withable(collection_)) {
        if (!struct_exists_from_hash(collection_, hash_)) {
            __catspeak_error(dbgError);
        }
    }
    
    return result();
}

/// @ignore
/// @return {Any}
function __gmlspeak_expr_index_get_hash__() {
    var collection_ = collection();
    // var key_ = key();
    if (is_array(collection_)) {
        return collection_[key_];
    } else if (__catspeak_is_withable(collection_)) {
        return struct_get_from_hash(collection_, hash_);
    } else {
        __catspeak_error_got(dbgError, collection_);
    }
}

/// @ignore
/// @return {Any}
function __gmlspeak_expr_index_set_hash__() {
    var collection_ = collection();
    // var key_ = key();
    var value_ = value();
    if (is_array(collection_)) {
        collection_[@ key_] = value_;
    } else if (__catspeak_is_withable(collection_)) {
        var specialSet = global.__catspeakGmlSpecialVars[$ key_];
        if (specialSet != undefined) {
            specialSet(collection_, value_);
            return;
        }
        struct_set_from_hash(collection_, hash_, value_);
    } else {
        __catspeak_error_got(dbgError, collection_);
    }
}

/// @ignore
/// @return {Any}
function __gmlspeak_expr_index_set_mult_hash__() {
    var collection_ = collection();
    // var key_ = key();
    var value_ = value();
    if (is_array(collection_)) {
        collection_[@ key_] *= value_;
    } else if (__catspeak_is_withable(collection_)) {
        var specialSet = global.__catspeakGmlSpecialVars[$ key_];
        if (specialSet != undefined) {
            specialSet(collection_, __gmlspeak_expr_index_get_hash__() * value_);
            return;
        }
        struct_set_from_hash(collection_, hash_, __gmlspeak_expr_index_get_hash__() * value_);
    } else {
        __catspeak_error_got(dbgError, collection_);
    }
}

/// @ignore
/// @return {Any}
function __gmlspeak_expr_index_set_div_hash__() {
    var collection_ = collection();
    // var key_ = key();
    var value_ = value();
    if (is_array(collection_)) {
        collection_[@ key_] /= value_;
    } else if (__catspeak_is_withable(collection_)) {
        var specialSet = global.__catspeakGmlSpecialVars[$ key_];
        if (specialSet != undefined) {
            specialSet(collection_, __gmlspeak_expr_index_get_hash__() / value_);
            return;
        }
        struct_set_from_hash(collection_, hash_, __gmlspeak_expr_index_get_hash__() / value_);
    } else {
        __catspeak_error_got(dbgError, collection_);
    }
}

/// @ignore
/// @return {Any}
function __gmlspeak_expr_index_set_sub_hash__() {
    var collection_ = collection();
    // var key_ = key();
    var value_ = value();
    if (is_array(collection_)) {
        collection_[@ key_] -= value_;
    } else if (__catspeak_is_withable(collection_)) {
        var specialSet = global.__catspeakGmlSpecialVars[$ key_];
        if (specialSet != undefined) {
            specialSet(collection_, __gmlspeak_expr_index_get_hash__() - value_);
            return;
        }
        struct_set_from_hash(collection_, hash_, __gmlspeak_expr_index_get_hash__() - value_);
    } else {
        __catspeak_error_got(dbgError, collection_);
    }
}

/// @ignore
/// @return {Any}
function __gmlspeak_expr_index_set_plus_hash__() {
    var collection_ = collection();
    // var key_ = key();
    var value_ = value();
    if (is_array(collection_)) {
        collection_[@ key_] += value_;
    } else if (__catspeak_is_withable(collection_)) {
        var specialSet = global.__catspeakGmlSpecialVars[$ key_];
        if (specialSet != undefined) {
            specialSet(collection_, __gmlspeak_expr_index_get_hash__() + value_);
            return;
        }
        struct_set_from_hash(collection_, hash_, __gmlspeak_expr_index_get_hash__() + value_);
    } else {
        __catspeak_error_got(dbgError, collection_);
    }
}