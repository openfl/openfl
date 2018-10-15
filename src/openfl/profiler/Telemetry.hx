package openfl.profiler; #if !flash


#if ((cpp || neko) && hxtelemetry && !macro)
import hxtelemetry.HxTelemetry;
#end

import openfl._internal.Lib;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:allow(openfl.display.Stage)


@:final class Telemetry {
	
	
	public static var connected (get, never):Bool;
	public static var spanMarker (default, null) = 0.0;
	
	#if ((cpp || neko) && hxtelemetry && !macro)
	@:noCompletion private static var telemetry:HxTelemetry;
	#end
	
	
	#if openfljs
	@:noCompletion private static function __init__ () {
		
		untyped Object.defineProperty (Telemetry, "connected", { get: function () { return Telemetry.get_connected (); } });
		
	}
	#end
	
	
	public static function registerCommandHandler (commandName:String, handler:Dynamic):Bool {
		
		return false;
		
	}
	
	
	public static function sendMetric (metric:String, value:Dynamic):Void {
		
		
		
	}
	
	
	public static function sendSpanMetric (metric:String, startSpanMarker:Float, value:Dynamic = null):Void {
		
		
		
	}
	
	
	public static function unregisterCommandHandler (commandName:String):Bool {
		
		return false;
		
	}
	
	
	@:noCompletion private static inline function __advanceFrame ():Void {
		
		#if ((cpp || neko) && hxtelemetry && !macro)
		telemetry.advance_frame ();
		#end
		
	}
	
	
	@:noCompletion private static inline function __endTiming (name:String):Void {
		
		#if ((cpp || neko) && hxtelemetry && !macro)
		telemetry.end_timing (name);
		#end
		
	}
	
	
	@:noCompletion private static inline function __initialize ():Void {
		
		#if ((cpp || neko) && hxtelemetry && !macro)
		var meta = Lib.application.meta;
		
		var config = new hxtelemetry.HxTelemetry.Config ();
		config.allocations = (!meta.exists ("hxtelemetry-allocations") || meta.get ("hxtelemetry-allocations") == "true");
		config.host = (!meta.exists ("hxtelemetry-host") ? "localhost" : meta.get ("hxtelemetry-host"));
		config.app_name = meta.get ("name");
		
		config.activity_descriptors = [ { name: TelemetryCommandName.EVENT, description: "Event Handler", color: 0x2288cc }, { name: TelemetryCommandName.RENDER, description: "Rendering", color:0x66aa66 } ];
		telemetry = new HxTelemetry (config);
		#end
		
	}
	
	
	@:noCompletion private static inline function __rewindStack (stack:String):Void {
		
		#if ((cpp || neko) && hxtelemetry && !macro)
		telemetry.rewind_stack (stack);
		#end
		
	}
	
	
	@:noCompletion private static inline function __startTiming (name:String):Void {
		
		#if ((cpp || neko) && hxtelemetry && !macro)
		telemetry.start_timing (name);
		#end
		
	}
	
	
	@:noCompletion private static inline function __unwindStack ():String {
		
		#if ((cpp || neko) && hxtelemetry && !macro)
		return telemetry.unwind_stack ();
		#else
		return "";
		#end
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private static function get_connected ():Bool {
		
		#if ((cpp || neko) && hxtelemetry && !macro)
		return true;
		#else
		return false;
		#end
		
	}
	
	
	
}


@:noCompletion @:dox(hide) @:enum abstract TelemetryCommandName(String) from String to String {
	
	var EVENT = ".event";
	var RENDER = ".render";
	
}


#else
typedef Telemetry = flash.profiler.Telemetry;
#end