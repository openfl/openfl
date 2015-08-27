package openfl.profiler; #if !flash


#if (cpp && hxtelemetry)
import hxtelemetry.HxTelemetry;
#end

@:allow(openfl.display.Stage)


@:final class Telemetry {
	
	
	public static var connected (get, never):Bool;
	public static var spanMarker (default, null) = 0.0;
	
	#if (cpp && hxtelemetry)
	private static var telemetry:HxTelemetry;
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
	
	
	private static inline function __advanceFrame ():Void {
		
		#if (cpp && hxtelemetry)
		telemetry.advance_frame ();
		#end
		
	}
	
	
	private static inline function __endTiming (name:String):Void {
		
		#if (cpp && hxtelemetry)
		telemetry.end_timing (name);
		#end
		
	}
	
	
	private static inline function __initialize ():Void {
		
		#if (cpp && hxtelemetry)
		var config:hxtelemetry.Config;
		
		#if !lime_legacy
		config = (Lib.application.config:Dynamic).telemetry;
		#else
		config = ApplicationMain.telemetryConfig;
		#end
		
		config.activity_descriptors = [ { name: TelemetryCommandName.EVENT, description: "Event Handler", color: 0x2288cc }, { name: TelemetryCommandName.RENDER, description: "Rendering", color:0x66aa66 } ];
		telemetry = new HxTelemetry (config);
		#end
		
	}
	
	
	private static inline function __rewindStack (stack:String):Void {
		
		#if (cpp && hxtelemetry)
		telemetry.rewind_stack (stack);
		#end
		
	}
	
	
	private static inline function __startTiming (name:String):Void {
		
		#if (cpp && hxtelemetry)
		telemetry.start_timing (name);
		#end
		
	}
	
	
	private static inline function __unwindStack ():String {
		
		#if (cpp && hxtelemetry)
		return telemetry.unwind_stack ();
		#else
		return "";
		#end
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private static function get_connected ():Bool {
		
		#if (cpp && hxtelemetry)
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
