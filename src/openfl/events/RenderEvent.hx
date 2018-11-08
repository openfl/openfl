package openfl.events;


import openfl.display.DisplayObjectRenderer;
import openfl.events.Event;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.geom.ColorTransform)


@:beta class RenderEvent extends Event {
	
	
	public static inline var CLEAR_DOM = "clearDOM";
	public static inline var RENDER_CAIRO = "renderCairo";
	public static inline var RENDER_CANVAS = "renderCanvas";
	public static inline var RENDER_DOM = "renderDOM";
	public static inline var RENDER_OPENGL = "renderOpenGL";
	
	public var allowSmoothing:Bool;
	public var objectColorTransform:ColorTransform;
	public var objectMatrix:Matrix;
	public var renderer (default, null):DisplayObjectRenderer;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, objectMatrix:Matrix = null, objectColorTransform:ColorTransform = null, allowSmoothing:Bool = true):Void {
		
		super (type, bubbles, cancelable);
		
		this.objectMatrix = objectMatrix;
		this.objectColorTransform = objectColorTransform;
		this.allowSmoothing = allowSmoothing;
		
	}
	
	
	public override function clone ():Event {
		
		var event = new RenderEvent (type, bubbles, cancelable, objectMatrix.clone (), #if flash null #else objectColorTransform.__clone () #end, allowSmoothing);
		#if !flash
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		#end
		return event;
		
	}
	
	
	#if !flash
	public override function toString ():String {
		
		return __formatToString ("RenderEvent", [ "type", "bubbles", "cancelable" ]);
		
	}
	#end
	
	
}