// Class: haxe.Log

var $global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this



var __map_reserved = {};

// Imports

var $hxClasses = require("./../hxClasses_stub").default;
var $import = require("./../import_stub").default;
function js_Boot() {return require("./../js/Boot");}

// Constructor

var Log = function(){}

// Meta

Log.__name__ = ["haxe","Log"];
Log.prototype = {
	
};
Log.prototype.__class__ = Log.prototype.constructor = $hxClasses["haxe.Log"] = Log;

// Init



// Statics

Log.trace = function(v,infos) {
	(js_Boot().default).__trace(v,infos);
}


// Export

exports.default = Log;