// Class: haxe.io.Path

var $global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this



var __map_reserved = {};

// Imports

var $hxClasses = require("./../../hxClasses_stub").default;
var $import = require("./../../import_stub").default;
function HxOverrides() {return require("./../../HxOverrides");}

// Constructor

var Path = function(path) {
	switch(path) {
	case ".":case "..":
		this.dir = path;
		this.file = "";
		return;
	}
	var c1 = path.lastIndexOf("/");
	var c2 = path.lastIndexOf("\\");
	if(c1 < c2) {
		this.dir = (HxOverrides().default).substr(path,0,c2);
		path = (HxOverrides().default).substr(path,c2 + 1,null);
		this.backslash = true;
	} else if(c2 < c1) {
		this.dir = (HxOverrides().default).substr(path,0,c1);
		path = (HxOverrides().default).substr(path,c1 + 1,null);
	} else {
		this.dir = null;
	}
	var cp = path.lastIndexOf(".");
	if(cp != -1) {
		this.ext = (HxOverrides().default).substr(path,cp + 1,null);
		this.file = (HxOverrides().default).substr(path,0,cp);
	} else {
		this.ext = null;
		this.file = path;
	}
}

// Meta

Path.__name__ = ["haxe","io","Path"];
Path.prototype = {
	toString: function() {
		return (this.dir == null ? "" : this.dir + (this.backslash ? "\\" : "/")) + this.file + (this.ext == null ? "" : "." + this.ext);
	}
};
Path.prototype.__class__ = Path.prototype.constructor = $hxClasses["haxe.io.Path"] = Path;

// Init



// Statics

Path.withoutDirectory = function(path) {
	var s = new Path(path);
	s.dir = null;
	return s.toString();
}
Path.directory = function(path) {
	var s = new Path(path);
	if(s.dir == null) {
		return "";
	}
	return s.dir;
}
Path.extension = function(path) {
	var s = new Path(path);
	if(s.ext == null) {
		return "";
	}
	return s.ext;
}


// Export

exports.default = Path;