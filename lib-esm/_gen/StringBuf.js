// Class: StringBuf

var $global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this



var __map_reserved = {};

// Imports

var $hxClasses = require("./hxClasses_stub").default;
var $import = require("./import_stub").default;
function Std() {return require("./Std");}

// Constructor

var StringBuf = function() {
	this.b = "";
}

// Meta

StringBuf.__name__ = ["StringBuf"];
StringBuf.prototype = {
	add: function(x) {
		this.b += (Std().default).string(x);
	},
	addChar: function(c) {
		this.b += String.fromCharCode(c);
	},
	toString: function() {
		return this.b;
	}
};
StringBuf.prototype.__class__ = StringBuf.prototype.constructor = $hxClasses["StringBuf"] = StringBuf;

// Init



// Statics




// Export

exports.default = StringBuf;