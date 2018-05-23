// Class: Type

var $global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this



var __map_reserved = {};

// Imports

var $hxClasses = require("./hxClasses_stub").default;
var $import = require("./import_stub").default;
function js_Boot() {return require("./js/Boot");}
function js__$Boot_HaxeError() {return require("./js/_Boot/HaxeError");}
function Reflect() {return require("./Reflect");}
function ValueType() {return require("./ValueType");}

// Constructor

var Type = function(){}

// Meta

Type.__name__ = ["Type"];
Type.prototype = {
	
};
Type.prototype.__class__ = Type.prototype.constructor = $hxClasses["Type"] = Type;

// Init



// Statics

Type.getClass = function(o) {
	if(o == null) {
		return null;
	} else {
		return (js_Boot().default).getClass(o);
	}
}
Type.getSuperClass = function(c) {
	return c.__super__;
}
Type.getClassName = function(c) {
	var a = c.__name__;
	if(a == null) {
		return null;
	}
	return a.join(".");
}
Type.getEnumName = function(e) {
	var a = e.__ename__;
	return a.join(".");
}
Type.resolveClass = function(name) {
	var cl = $hxClasses[name];
	if(cl == null || !(js_Boot().default).isClass(cl)) {
		return null;
	}
	return cl;
}
Type.resolveEnum = function(name) {
	var e = $hxClasses[name];
	if(e == null || !(js_Boot().default).isEnum(e)) {
		return null;
	}
	return e;
}
Type.createInstance = function(cl,args) {
	var _g = args.length;
	switch(_g) {
	case 0:
		return new cl();
	case 1:
		return new cl(args[0]);
	case 2:
		return new cl(args[0],args[1]);
	case 3:
		return new cl(args[0],args[1],args[2]);
	case 4:
		return new cl(args[0],args[1],args[2],args[3]);
	case 5:
		return new cl(args[0],args[1],args[2],args[3],args[4]);
	case 6:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5]);
	case 7:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6]);
	case 8:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7]);
	case 9:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8]);
	case 10:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9]);
	case 11:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9],args[10]);
	case 12:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9],args[10],args[11]);
	case 13:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9],args[10],args[11],args[12]);
	case 14:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9],args[10],args[11],args[12],args[13]);
	default:
		throw new (js__$Boot_HaxeError().default)("Too many arguments");
	}
}
Type.createEmptyInstance = function(cl) {
	function empty() {}; empty.prototype = cl.prototype;
	return new empty();
}
Type.createEnum = function(e,constr,params) {
	var f = (Reflect().default).field(e,constr);
	if(f == null) {
		throw new (js__$Boot_HaxeError().default)("No such constructor " + constr);
	}
	if((Reflect().default).isFunction(f)) {
		if(params == null) {
			throw new (js__$Boot_HaxeError().default)("Constructor " + constr + " need parameters");
		}
		return (Reflect().default).callMethod(e,f,params);
	}
	if(params != null && params.length != 0) {
		throw new (js__$Boot_HaxeError().default)("Constructor " + constr + " does not need parameters");
	}
	return f;
}
Type.getEnumConstructs = function(e) {
	return e.__constructs__.slice();
}
Type.typeof = function(v) {
	var _g = typeof(v);
	switch(_g) {
	case "boolean":
		return (ValueType().default).TBool;
	case "function":
		if((js_Boot().default).isClass(v) || (js_Boot().default).isEnum(v)) {
			return (ValueType().default).TObject;
		}
		return (ValueType().default).TFunction;
	case "number":
		if(Math.ceil(v) == v % 2147483648.0) {
			return (ValueType().default).TInt;
		}
		return (ValueType().default).TFloat;
	case "object":
		if(v == null) {
			return (ValueType().default).TNull;
		}
		var e = v.__enum__;
		if(e != null) {
			return (ValueType().default).TEnum(e);
		}
		var c = (js_Boot().default).getClass(v);
		if(c != null) {
			return (ValueType().default).TClass(c);
		}
		return (ValueType().default).TObject;
	case "string":
		return (ValueType().default).TClass(String);
	case "undefined":
		return (ValueType().default).TNull;
	default:
		return (ValueType().default).TUnknown;
	}
}
Type.enumIndex = function(e) {
	return e[1];
}


// Export

exports.default = Type;