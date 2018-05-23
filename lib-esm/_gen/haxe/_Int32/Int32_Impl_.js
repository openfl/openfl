// Class: haxe._Int32.Int32_Impl_

var $global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this



var __map_reserved = {};

// Imports

var $hxClasses = require("./../../hxClasses_stub").default;
var $import = require("./../../import_stub").default;

// Constructor

var Int32_Impl_ = function(){}

// Meta

Int32_Impl_.__name__ = ["haxe","_Int32","Int32_Impl_"];
Int32_Impl_.prototype = {
	
};
Int32_Impl_.prototype.__class__ = Int32_Impl_.prototype.constructor = $hxClasses["haxe._Int32.Int32_Impl_"] = Int32_Impl_;

// Init



// Statics

Int32_Impl_.preIncrement = function(this1) {
	this1 = ++this1 | 0;
	return this1;
}
Int32_Impl_.postIncrement = function(this1) {
	var ret = this1++;
	this1 |= 0;
	return ret;
}
Int32_Impl_.preDecrement = function(this1) {
	this1 = --this1 | 0;
	return this1;
}
Int32_Impl_.postDecrement = function(this1) {
	var ret = this1--;
	this1 |= 0;
	return ret;
}
Int32_Impl_.add = function(a,b) {
	return a + b | 0;
}
Int32_Impl_.addInt = function(a,b) {
	return a + b | 0;
}
Int32_Impl_.sub = function(a,b) {
	return a - b | 0;
}
Int32_Impl_.subInt = function(a,b) {
	return a - b | 0;
}
Int32_Impl_.intSub = function(a,b) {
	return a - b | 0;
}
Int32_Impl_.mul = function(a,b) {
	return a * (b & 65535) + (a * (b >>> 16) << 16 | 0) | 0;
}
Int32_Impl_.mulInt = function(a,b) {
	return Int32_Impl_.mul(a,b);
}
Int32_Impl_.toFloat = function(this1) {
	return this1;
}
Int32_Impl_.ucompare = function(a,b) {
	if(a < 0) {
		if(b < 0) {
			return ~b - ~a | 0;
		} else {
			return 1;
		}
	}
	if(b < 0) {
		return -1;
	} else {
		return a - b | 0;
	}
}
Int32_Impl_.clamp = function(x) {
	return x | 0;
}


// Export

exports.default = Int32_Impl_;