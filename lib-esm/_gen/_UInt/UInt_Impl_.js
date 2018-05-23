// Class: _UInt.UInt_Impl_

var $global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this



var __map_reserved = {};

// Imports

var $hxClasses = require("./../hxClasses_stub").default;

// Constructor

var UInt_Impl_ = function(){}

// Meta

UInt_Impl_.__name__ = ["_UInt","UInt_Impl_"];
UInt_Impl_.prototype = {
	
};
UInt_Impl_.prototype.__class__ = UInt_Impl_.prototype.constructor = $hxClasses["_UInt.UInt_Impl_"] = UInt_Impl_;

// Init



// Statics

UInt_Impl_.gt = function(a,b) {
	var aNeg = a < 0;
	var bNeg = b < 0;
	if(aNeg != bNeg) {
		return aNeg;
	} else {
		return a > b;
	}
}
UInt_Impl_.toFloat = function(this1) {
	var $int = this1;
	if($int < 0) {
		return 4294967296.0 + $int;
	} else {
		return $int + 0.0;
	}
}


// Export

exports.default = UInt_Impl_;