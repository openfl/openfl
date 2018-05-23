// Class: haxe.ds.IntMap

var $global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this



var __map_reserved = {};

// Imports

var $hxClasses = require("./../../hxClasses_stub").default;
var $import = require("./../../import_stub").default;
function haxe_IMap() {return require("./../../haxe/IMap");}
function HxOverrides() {return require("./../../HxOverrides");}

// Constructor

var IntMap = function() {
	this.h = { };
}

// Meta

IntMap.__name__ = ["haxe","ds","IntMap"];
IntMap.__interfaces__ = [(haxe_IMap().default)];
IntMap.prototype = {
	set: function(key,value) {
		this.h[key] = value;
	},
	get: function(key) {
		return this.h[key];
	},
	exists: function(key) {
		return this.h.hasOwnProperty(key);
	},
	remove: function(key) {
		if(!this.h.hasOwnProperty(key)) {
			return false;
		}
		delete(this.h[key]);
		return true;
	},
	keys: function() {
		var a = [];
		for( var key in this.h ) if(this.h.hasOwnProperty(key)) {
			a.push(key | 0);
		}
		return (HxOverrides().default).iter(a);
	},
	iterator: function() {
		return { ref : this.h, it : this.keys(), hasNext : function() {
			return this.it.hasNext();
		}, next : function() {
			var i = this.it.next();
			return this.ref[i];
		}};
	}
};
IntMap.prototype.__class__ = IntMap.prototype.constructor = $hxClasses["haxe.ds.IntMap"] = IntMap;

// Init



// Statics




// Export

exports.default = IntMap;