package openfl.profiler; #if !flash


#if (cpp && hxtelemetry)
import hxtelemetry.HxTelemetry;
import hxtelemetry.HxTelemetry.Config;
#end

@:allow(openfl.display.Stage)


class Telemetry {
	
	
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
	
	
	#if (cpp && hxtelemetry)
	private static var hxtConfig:Config = new Config();
	public static var config(get, null):Config;
	public static function get_config():Config
	{
		if (telemetry!=null) throw "Must setup Telemetry.config before Telemetry is initialized!";
		return hxtConfig;
	}
	#else
	public static var config(get, null):Dynamic;
	public static function get_config():Dynamic return {};
	#end

	private static inline function __initialize ():Void {
		
		#if (cpp && hxtelemetry)
		hxtConfig.app_name = Lib.application.config.title;
		hxtConfig.activity_descriptors = [ { name: TelemetryCommandName.EVENT, description: "Event Handler", color: 0x2288cc }, { name: TelemetryCommandName.RENDER, description: "Rendering", color:0x66aa66 } ];
		telemetry = new HxTelemetry (hxtConfig);
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


@:noCompletion @:enum abstract TelemetryCommandName(String) from String to String {
	
	var EVENT = ".event";
	var RENDER = ".render";
	
}


#else
typedef Telemetry = flash.profiler.Telemetry;
#end
