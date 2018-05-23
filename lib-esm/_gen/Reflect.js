// Class: Reflect

var $global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this



var __map_reserved = {};

// Imports

var $hxClasses = require("./hxClasses_stub").default;
var $import = require("./import_stub").default;
function js_Boot() {return require("./js/Boot");}

// Constructor

var Reflect = function(){}

// Meta

Reflect.__name__ = ["Reflect"];
Reflect.prototype = {
	
};
Reflect.prototype.__class__ = Reflect.prototype.constructor = $hxClasses["Reflect"] = Reflect;

// Init



// Statics

Reflect.hasField = function(o,field) {
	return Object.prototype.hasOwnProperty.call(o,field);
}
Reflect.field = function(o,field) {
	try {
		return o[field];
	} catch( e ) {
		return null;
	}
}
Reflect.setField = function(o,field,value) {
	o[field] = value;
}
Reflect.callMethod = function(o,func,args) {
	return func.apply(o,args);
}
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(f != "__id__" && f != "hx__closures__" && hasOwnProperty.call(o,f)) {
			a.push(f);
		}
		}
	}
	return a;
}
Reflect.isFunction = function(f) {
	if(typeof(f) == "function") {
		return !((js_Boot().default).isClass(f) || (js_Boot().default).isEnum(f));
	} else {
		return false;
	}
}
Reflect.compare = function(a,b) {
	if(a == b) {
		return 0;
	} else if(a > b) {
		return 1;
	} else {
		return -1;
	}
}
Reflect.compareMethods = function(f1,f2) {
	if(f1 == f2) {
		return true;
	}
	if(!Reflect.isFunction(f1) || !Reflect.isFunction(f2)) {
		return false;
	}
	if(f1.scope == f2.scope && f1.method == f2.method) {
		return f1.method != null;
	} else {
		return false;
	}
}
Reflect.deleteField = function(o,field) {
	if(!Reflect.hasField(o,field)) {
		return false;
	}
	delete(o[field]);
	return true;
}
Reflect.makeVarArgs = function(f) {
	return function() {
		var a = Array.prototype.slice.call(arguments);
		return f(a);
	};
}


// Export

exports.default = Reflect;