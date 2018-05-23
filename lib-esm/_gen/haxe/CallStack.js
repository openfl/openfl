// Class: haxe.CallStack

var $global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this



var __map_reserved = {};

// Imports

var $hxClasses = require("./../hxClasses_stub").default;
var $import = require("./../import_stub").default;
function HxOverrides() {return require("./../HxOverrides");}
function haxe_StackItem() {return require("./../haxe/StackItem");}
function js__$Boot_HaxeError() {return require("./../js/_Boot/HaxeError");}
function StringBuf() {return require("./../StringBuf");}
function Type() {return require("./../Type");}
function EReg() {return require("./../EReg");}
function Std() {return require("./../Std");}
function StringTools() {return require("./../StringTools");}

// Constructor

var CallStack = function(){}

// Meta

CallStack.__name__ = ["haxe","CallStack"];
CallStack.prototype = {
	
};
CallStack.prototype.__class__ = CallStack.prototype.constructor = $hxClasses["haxe.CallStack"] = CallStack;

// Init



// Statics

CallStack.getStack = function(e) {
	if(e == null) {
		return [];
	}
	var oldValue = Error.prepareStackTrace;
	Error.prepareStackTrace = function(error,callsites) {
		var stack = [];
		var _g = 0;
		while(_g < callsites.length) {
			var site = callsites[_g];
			++_g;
			if(CallStack.wrapCallSite != null) {
				site = CallStack.wrapCallSite(site);
			}
			var method = null;
			var fullName = site.getFunctionName();
			if(fullName != null) {
				var idx = fullName.lastIndexOf(".");
				if(idx >= 0) {
					var className = (HxOverrides().default).substr(fullName,0,idx);
					var methodName = (HxOverrides().default).substr(fullName,idx + 1,null);
					method = (haxe_StackItem().default).Method(className,methodName);
				}
			}
			stack.push((haxe_StackItem().default).FilePos(method,site.getFileName(),site.getLineNumber()));
		}
		return stack;
	};
	var a = CallStack.makeStack(e.stack);
	Error.prepareStackTrace = oldValue;
	return a;
}
CallStack.callStack = function() {
	try {
		throw new Error();
	} catch( e ) {
		if (e instanceof (js__$Boot_HaxeError().default)) e = e.val;
		var a = CallStack.getStack(e);
		a.shift();
		return a;
	}
}
CallStack.exceptionStack = function() {
	return CallStack.getStack(CallStack.lastException);
}
CallStack.toString = function(stack) {
	var b = new (StringBuf().default)();
	var _g = 0;
	while(_g < stack.length) {
		var s = stack[_g];
		++_g;
		b.add("\nCalled from ");
		CallStack.itemToString(b,s);
	}
	return b.toString();
}
CallStack.itemToString = function(b,s) {
	switch((Type().default).enumIndex(s)) {
	case 0:
		b.add("a C function");
		break;
	case 1:
		var m = s[2];
		b.add("module ");
		b.add(m);
		break;
	case 2:
		var line = s[4];
		var file = s[3];
		var s1 = s[2];
		if(s1 != null) {
			CallStack.itemToString(b,s1);
			b.add(" (");
		}
		b.add(file);
		b.add(" line ");
		b.add(line);
		if(s1 != null) {
			b.add(")");
		}
		break;
	case 3:
		var meth = s[3];
		var cname = s[2];
		b.add(cname);
		b.add(".");
		b.add(meth);
		break;
	case 4:
		var n = s[2];
		b.add("local function #");
		b.add(n);
		break;
	}
}
CallStack.makeStack = function(s) {
	if(s == null) {
		return [];
	} else if(typeof(s) == "string") {
		var stack = s.split("\n");
		if(stack[0] == "Error") {
			stack.shift();
		}
		var m = [];
		var rie10 = new (EReg().default)("^   at ([A-Za-z0-9_. ]+) \\(([^)]+):([0-9]+):([0-9]+)\\)$","");
		var _g = 0;
		while(_g < stack.length) {
			var line = stack[_g];
			++_g;
			if(rie10.match(line)) {
				var path = rie10.matched(1).split(".");
				var meth = path.pop();
				var file = rie10.matched(2);
				var line1 = (Std().default).parseInt(rie10.matched(3));
				m.push((haxe_StackItem().default).FilePos(meth == "Anonymous function" ? (haxe_StackItem().default).LocalFunction() : meth == "Global code" ? null : (haxe_StackItem().default).Method(path.join("."),meth),file,line1));
			} else {
				m.push((haxe_StackItem().default).Module((StringTools().default).trim(line)));
			}
		}
		return m;
	} else {
		return s;
	}
}


// Export

exports.default = CallStack;