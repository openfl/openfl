// Class: openfl.Lib

var $global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this



var __map_reserved = {};

// Imports

var $hxClasses = require("./../hxClasses_stub").default;
var $import = require("./../import_stub").default;
function haxe_ds_StringMap() {return require("./../haxe/ds/StringMap");}
function haxe_ds_IntMap() {return require("./../haxe/ds/IntMap");}
function Std() {return require("./../Std");}
function openfl_display_MovieClip() {return require("./../openfl/display/MovieClip");}
function Type() {return require("./../Type");}
function lime_system_System() {return require("./../lime/system/System");}
function openfl_net_URLVariables() {return require("./../openfl/net/URLVariables");}
function Reflect() {return require("./../Reflect");}
function StringTools() {return require("./../StringTools");}
function lime_utils_Log() {return require("./../lime/utils/Log");}
function js_Browser() {return require("./../js/Browser");}
function openfl_net_URLLoader() {return require("./../openfl/net/URLLoader");}
function haxe_Timer() {return require("./../haxe/Timer");}
function haxe_Log() {return require("./../haxe/Log");}
function openfl__$internal_Lib() {return require("./../openfl/_internal/Lib");}

// Constructor

var Lib = function(){}

// Meta

Lib.__name__ = ["openfl","Lib"];
Lib.prototype = {
	
};
Lib.prototype.__class__ = Lib.prototype.constructor = $hxClasses["openfl.Lib"] = Lib;

// Init

Object.defineProperties(Lib,{ "application" : { get : function() {
	return Lib.get_application();
}}, "current" : { get : function() {
	return Lib.get_current();
}}});

// Statics

Lib.as = function(v,c) {
	if((Std().default)["is"](v,c)) {
		return v;
	} else {
		return null;
	}
}
Lib.attach = function(name) {
	return new (openfl_display_MovieClip().default)();
}
Lib.clearInterval = function(id) {
	if(Lib.__timers.exists(id)) {
		var timer = Lib.__timers.get(id);
		timer.stop();
		Lib.__timers.remove(id);
	}
}
Lib.clearTimeout = function(id) {
	if(Lib.__timers.exists(id)) {
		var timer = Lib.__timers.get(id);
		timer.stop();
		Lib.__timers.remove(id);
	}
}
Lib.getDefinitionByName = function(name) {
	return (Type().default).resolveClass(name);
}
Lib.getQualifiedClassName = function(value) {
	return (Type().default).getClassName((Type().default).getClass(value));
}
Lib.getQualifiedSuperclassName = function(value) {
	var ref = (Type().default).getSuperClass((Type().default).getClass(value));
	if(ref != null) {
		return (Type().default).getClassName(ref);
	} else {
		return null;
	}
}
Lib.getTimer = function() {
	return (lime_system_System().default).getTimer();
}
Lib.getURL = function(request,target) {
	Lib.navigateToURL(request,target);
}
Lib.navigateToURL = function(request,window) {
	if(window == null) {
		window = "_blank";
	}
	var uri = request.url;
	if((Std().default)["is"](request.data,(openfl_net_URLVariables().default))) {
		var query = "";
		var fields = (Reflect().default).fields(request.data);
		var _g = 0;
		while(_g < fields.length) {
			var field = fields[_g];
			++_g;
			if(query.length > 0) {
				query += "&";
			}
			query += (StringTools().default).urlEncode(field) + "=" + (StringTools().default).urlEncode((Std().default).string((Reflect().default).field(request.data,field)));
		}
		if(uri.indexOf("?") > -1) {
			uri += "&" + query;
		} else {
			uri += "?" + query;
		}
	}
	(lime_system_System().default).openURL(uri,window);
}
Lib.notImplemented = function(posInfo) {
	var api = posInfo.className + "." + posInfo.methodName;
	if(!Lib.__sentWarnings.exists(api)) {
		Lib.__sentWarnings.set(api,true);
		(lime_utils_Log().default).warn(posInfo.methodName + " is not implemented",posInfo);
	}
}
Lib.preventDefaultTouchMove = function() {
	(js_Browser().default).get_document().addEventListener("touchmove",function(evt) {
		evt.preventDefault();
	},false);
}
Lib.sendToURL = function(request) {
	var urlLoader = new (openfl_net_URLLoader().default)();
	urlLoader.load(request);
}
Lib.setInterval = function(closure,delay,args) {
	var id = ++Lib.__lastTimerID;
	var timer = new (haxe_Timer().default)(delay);
	Lib.__timers.set(id,timer);
	timer.run = function() {
		(Reflect().default).callMethod(closure,closure,args);
	};
	return id;
}
Lib.setTimeout = function(closure,delay,args) {
	var id = ++Lib.__lastTimerID;
	var this1 = Lib.__timers;
	var v = (haxe_Timer().default).delay(function() {
		(Reflect().default).callMethod(closure,closure,args);
	},delay);
	this1.set(id,v);
	return id;
}
Lib.trace = function(arg) {
	(haxe_Log().default).trace(arg,{ fileName : "Lib.hx", lineNumber : 282, className : "openfl.Lib", methodName : "trace"});
}
Lib.get_application = function() {
	return (openfl__$internal_Lib().default).application;
}
Lib.get_current = function() {
	if((openfl__$internal_Lib().default).current == null) {
		(openfl__$internal_Lib().default).current = new (openfl_display_MovieClip().default)();
	}
	return (openfl__$internal_Lib().default).current;
}
Lib.__lastTimerID = 0
Lib.__sentWarnings = new (haxe_ds_StringMap().default)()
Lib.__timers = new (haxe_ds_IntMap().default)()

// Export

exports.default = Lib;