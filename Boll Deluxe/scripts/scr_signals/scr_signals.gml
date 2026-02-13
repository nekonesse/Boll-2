function SigConnector( c = undefined,f = function(){} ) constructor{
    _alive = true;
    static SetDead = function(){ _alive = false; }
    IsAlive = function(){ return _alive; }

    fnc  = is_real(f)? f : method_get_index(f);
    Call = function(args){ return script_execute_ext(fnc,args); }
    ctx = undefined;

    static _init_obj = function(c){
        ctx = c.id;
        IsAlive = function(){ _alive = instance_exists(ctx); return _alive; }
        Call = function(args){ var f = fnc; with( ctx ){ return script_execute_ext(f,args); } }
    }

    static _init_ref = function(c){
        ctx = weak_ref_create(c);
        IsAlive = function(){ _alive = weak_ref_alive(ctx); return _alive; }
        Call = function(args){ var f = fnc; with( ctx.ref ){ return script_execute_ext(f,args); } }
    }

    static _init_hold = function(c){
        ctx = c;
        Call = function(args){ var f = fnc; with( ctx ){ return script_execute_ext(f,args); } }
    }

    if( is_struct(c) ){
        if( "struct" == instanceof(c) ){ _init_hold(c); }
        else{ _init_ref(c); }
    }else if( undefined!=c && instance_exists(c) ){ _init_obj(c); }

    prev = undefined;
    next = undefined;
    static Attach = function(s){//s -> self self.Attach(s)
        prev = s;
        next = s.next;
        s.next = self;
        if( undefined != next ){ next.prev = self; }
    }

    static Remove = function(){
        if( undefined != prev ){ prev.next = next; }
        if( undefined != next ){ next.prev = prev; }
        prev = undefined;
        next = undefined;
        if( undefined!=fnc ){ fnc = undefined; }
    }
}

function SigDisconnect(wref){ if( weak_ref_alive(wref) ){ wref.ref.SetDead(); } }

function Signal() constructor {
    slotsHead = new SigConnector();
    slotsHead.prev = slotsHead;
    slotsHead.next = slotsHead;

    static Connect = function(ctx,func) {
         var cn = weak_ref_create( new SigConnector(ctx,func) );
         cn.ref.Attach(slotsHead);
         return cn;//need return connector for delete external
    };

    static Destroy = function() {
        var remove = [];
        var cur = slotsHead.prev;
        while( cur != slotsHead ){ array_push(remove,cur); cur = cur.prev; }
        var len = array_length(remove);
		var i=0;
        repeat(len) {
			remove[i].Remove()
			delete remove[i] 
			i++
		}
    }

    static Count = function() {
        var cnt = 0;
        var cur = slotsHead.prev;
        while( cur != slotsHead ){ ++cnt; cur = cur.prev; }
        return cnt;
    }

    static Emit = function() {
        var head = slotsHead;
        var cur = head.prev;
        if( cur == head ){ return; }
        var remove = [];
        var funcRet = undefined;

        var args = array_create(argument_count);
        var i=0;
		repeat(argument_count){ args[i] = argument[i] i++;}
        if( argument_count<1 ){ args = [undefined]; }//debug for script_execute_ext
        while( cur != head ){
            if( !cur.IsAlive() ){ array_push(remove,cur); }
            else{ funcRet = cur.Call(args); }

            if( funcRet == true ){
                cur.SetDead();
                array_push(remove,cur);
            };

            cur = cur.prev;
        }

        var len = array_length(remove);
		var i=0;
        repeat(len){ 
			remove[i].Remove(); 
			delete remove[i]; 
			i++;
		}
    }
}

function signal_create(obj=id) {
	if obj.object_index == oScript
	return -1;
	
	var test_signal = new Signal();
	if (obj.object_index == oCustomObject) {
		test_signal.Connect( self, function(str_var, code_id) {
			catspeak_execute(global.scripts_object[? $"{code_id}_{str_var}"]);
		});	
	} else {
		test_signal.Connect( self, function(str_var, code_id) {
			catspeak_execute(global.scripts[? $"{code_id}_{str_var}"]);
		});
	}
	return test_signal
}