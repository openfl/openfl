// Class: Std

var $global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this



var __map_reserved = {};

// Imports

var $hxClasses = require("./hxClasses_stub").default;
var $import = require("./import_stub").default;
function js_Boot() {return require("./js/Boot");}
function HxOverrides() {return require("./HxOverrides");}

// Constructor

var Std = function(){}

// Meta

Std.__name__ = ["Std"];
Std.prototype = {
	
};
Std.prototype.__class__ = Std.prototype.constructor = $hxClasses["Std"] = Std;

// Init

{
	String.prototype.__class__ = $hxClasses["String"] = String
	String.__name__ = ["String"];
	$hxClasses["Array"] = Array
	Array.__name__ = ["Array"];
	Date.prototype.__class__ = $hxClasses["Date"] = Date;
	Date.__name__ = ["Date"];
	var Int = $hxClasses["Int"] = { __name__ : ["Int"]};
	var Dynamic = $hxClasses["Dynamic"] = { __name__ : ["Dynamic"]};
	var Float = $hxClasses["Float"] = Number;
	Float.__name__ = ["Float"];
	var Bool = $hxClasses["Bool"] = Boolean;
	Bool.__ename__ = ["Bool"];
	var Class = $hxClasses["Class"] = { __name__ : ["Class"]};
	var Enum = { };
};

// Statics

Std.is = function(v,t) {
	return (js_Boot().default).__instanceof(v,t);
}
Std.string = function(s) {
	return (js_Boot().default).__string_rec(s,"");
}
Std.int = function(x) {
	return x | 0;
}
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && ((HxOverrides().default).cca(x,1) == 120 || (HxOverrides().default).cca(x,1) == 88)) {
		v = parseInt(x);
	}
	if(isNaN(v)) {
		return null;
	}
	return v;
}
Std.parseFloat = function(x) {
	return parseFloat(x);
}


// Export

exports.default = Std;