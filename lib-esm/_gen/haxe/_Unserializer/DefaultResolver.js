// Class: haxe._Unserializer.DefaultResolver

var $global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this



var __map_reserved = {};

// Imports

var $hxClasses = require("./../../hxClasses_stub").default;
var $import = require("./../../import_stub").default;
function Type() {return require("./../../Type");}

// Constructor

var DefaultResolver = function() {
}

// Meta

DefaultResolver.__name__ = ["haxe","_Unserializer","DefaultResolver"];
DefaultResolver.prototype = {
	resolveClass: function(name) {
		return (Type().default).resolveClass(name);
	},
	resolveEnum: function(name) {
		return (Type().default).resolveEnum(name);
	}
};
DefaultResolver.prototype.__class__ = DefaultResolver.prototype.constructor = $hxClasses["haxe._Unserializer.DefaultResolver"] = DefaultResolver;

// Init



// Statics




// Export

exports.default = DefaultResolver;