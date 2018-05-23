// Class: haxe.ds.ObjectMap

var $global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this



var __map_reserved = {};

// Imports

var $hxClasses = require("./../../hxClasses_stub").default;
var $import = require("./../../import_stub").default;
function haxe_IMap() {return require("./../../haxe/IMap");}
function HxOverrides() {return require("./../../HxOverrides");}

// Constructor

var ObjectMap = function() {
	this.h = { __keys__ : { }};
}

// Meta

ObjectMap.__name__ = ["haxe","ds","ObjectMap"];
ObjectMap.__interfaces__ = [(haxe_IMap().default)];
ObjectMap.prototype = {
	set: function(key,value) {
		var id = ObjectMap.getId(key) || ObjectMap.assignId(key);
		this.h[id] = value;
		this.h.__keys__[id] = key;
	},
	get: function(key) {
		return this.h[ObjectMap.getId(key)];
	},
	exists: function(key) {
		return this.h.__keys__[ObjectMap.getId(key)] != null;
	},
	remove: function(key) {
		var id = ObjectMap.getId(key);
		if(this.h.__keys__[id] == null) {
			return false;
		}
		delete(this.h[id]);
		delete(this.h.__keys__[id]);
		return true;
	},
	keys: function() {
		var a = [];
		for( var key in this.h.__keys__ ) {
		if(this.h.hasOwnProperty(key)) {
			a.push(this.h.__keys__[key]);
		}
		}
		return (HxOverrides().default).iter(a);
	}
};
ObjectMap.prototype.__class__ = ObjectMap.prototype.constructor = $hxClasses["haxe.ds.ObjectMap"] = ObjectMap;

// Init



// Statics

ObjectMap.assignId = function(obj) {
	return obj.__id__ = ++ObjectMap.count;
}
ObjectMap.getId = function(obj) {
	return obj.__id__;
}
ObjectMap.count = 0

// Export

exports.default = ObjectMap;