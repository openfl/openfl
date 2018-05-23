// Class: haxe.Utf8

var $global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this



var __map_reserved = {};

// Imports

var $hxClasses = require("./../hxClasses_stub").default;
var $import = require("./../import_stub").default;
function HxOverrides() {return require("./../HxOverrides");}

// Constructor

var Utf8 = function(){}

// Meta

Utf8.__name__ = ["haxe","Utf8"];
Utf8.prototype = {
	
};
Utf8.prototype.__class__ = Utf8.prototype.constructor = $hxClasses["haxe.Utf8"] = Utf8;

// Init



// Statics

Utf8.sub = function(s,pos,len) {
	return (HxOverrides().default).substr(s,pos,len);
}


// Export

exports.default = Utf8;