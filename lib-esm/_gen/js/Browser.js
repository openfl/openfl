// Class: js.Browser

var $global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this



var __map_reserved = {};

// Imports

var $hxClasses = require("./../hxClasses_stub").default;
var $import = require("./../import_stub").default;
function js__$Boot_HaxeError() {return require("./../js/_Boot/HaxeError");}
function js_Boot() {return require("./../js/Boot");}

// Constructor

var Browser = function(){}

// Meta

Browser.__name__ = ["js","Browser"];
Browser.prototype = {
	
};
Browser.prototype.__class__ = Browser.prototype.constructor = $hxClasses["js.Browser"] = Browser;

// Init



// Statics

Browser.get_window = function() {
	return window;
}
Browser.get_document = function() {
	return window.document;
}
Browser.get_location = function() {
	return window.location;
}
Browser.get_navigator = function() {
	return window.navigator;
}
Browser.get_console = function() {
	return window.console;
}
Browser.get_supported = function() {
	return typeof window != "undefined";
}
Browser.getLocalStorage = function() {
	try {
		var s = Browser.get_window().localStorage;
		s.getItem("");
		return s;
	} catch( e ) {
		return null;
	}
}
Browser.getSessionStorage = function() {
	try {
		var s = Browser.get_window().sessionStorage;
		s.getItem("");
		return s;
	} catch( e ) {
		return null;
	}
}
Browser.createXMLHttpRequest = function() {
	if(typeof XMLHttpRequest != "undefined") {
		return new XMLHttpRequest();
	}
	if(typeof ActiveXObject != "undefined") {
		return new ActiveXObject("Microsoft.XMLHTTP");
	}
	throw new (js__$Boot_HaxeError().default)("Unable to create XMLHttpRequest object.");
}
Browser.alert = function(v) {
	Browser.get_window().alert((js_Boot().default).__string_rec(v,""));
}


// Export

exports.default = Browser;