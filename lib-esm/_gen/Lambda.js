// Class: Lambda

var $global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this



var __map_reserved = {};

// Imports

var $hxClasses = require("./hxClasses_stub").default;
var $iterator = require("./iterator_stub").default;

// Constructor

var Lambda = function(){}

// Meta

Lambda.__name__ = ["Lambda"];
Lambda.prototype = {
	
};
Lambda.prototype.__class__ = Lambda.prototype.constructor = $hxClasses["Lambda"] = Lambda;

// Init



// Statics

Lambda.array = function(it) {
	var a = [];
	var i = $iterator(it)();
	while(i.hasNext()) {
		var i1 = i.next();
		a.push(i1);
	}
	return a;
}


// Export

exports.default = Lambda;