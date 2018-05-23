// Class: haxe.ds.StringMap

var $global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this



var __map_reserved = {};

// Imports

var $hxClasses = require("./../../hxClasses_stub").default;
var $import = require("./../../import_stub").default;
function haxe_IMap() {return require("./../../haxe/IMap");}
function HxOverrides() {return require("./../../HxOverrides");}
function haxe_ds__$StringMap_StringMapIterator() {return require("./../../haxe/ds/_StringMap/StringMapIterator");}

// Constructor

var StringMap = function() {
	this.h = { };
}

// Meta

StringMap.__name__ = ["haxe","ds","StringMap"];
StringMap.__interfaces__ = [(haxe_IMap().default)];
StringMap.prototype = {
	isReserved: function(key) {
		return __map_reserved[key] != null;
	},
	set: function(key,value) {
		if(this.isReserved(key)) {
			this.setReserved(key,value);
		} else {
			this.h[key] = value;
		}
	},
	get: function(key) {
		if(this.isReserved(key)) {
			return this.getReserved(key);
		}
		return this.h[key];
	},
	exists: function(key) {
		if(this.isReserved(key)) {
			return this.existsReserved(key);
		}
		return this.h.hasOwnProperty(key);
	},
	setReserved: function(key,value) {
		if(this.rh == null) {
			this.rh = { };
		}
		this.rh["$" + key] = value;
	},
	getReserved: function(key) {
		if(this.rh == null) {
			return null;
		} else {
			return this.rh["$" + key];
		}
	},
	existsReserved: function(key) {
		if(this.rh == null) {
			return false;
		}
		return this.rh.hasOwnProperty("$" + key);
	},
	remove: function(key) {
		if(this.isReserved(key)) {
			key = "$" + key;
			if(this.rh == null || !this.rh.hasOwnProperty(key)) {
				return false;
			}
			delete(this.rh[key]);
			return true;
		} else {
			if(!this.h.hasOwnProperty(key)) {
				return false;
			}
			delete(this.h[key]);
			return true;
		}
	},
	keys: function() {
		return (HxOverrides().default).iter(this.arrayKeys());
	},
	arrayKeys: function() {
		var out = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) {
			out.push(key);
		}
		}
		if(this.rh != null) {
			for( var key in this.rh ) {
			if(key.charCodeAt(0) == 36) {
				out.push(key.substr(1));
			}
			}
		}
		return out;
	},
	iterator: function() {
		return new (haxe_ds__$StringMap_StringMapIterator().default)(this,this.arrayKeys());
	}
};
StringMap.prototype.__class__ = StringMap.prototype.constructor = $hxClasses["haxe.ds.StringMap"] = StringMap;

// Init

var __map_reserved = {};;

// Statics




// Export

exports.default = StringMap;