package openfl.events;

import openfl.display.DisplayObjectRenderer;
import openfl.events.Event;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;

@:jsRequire("openfl/events/RenderEvent", "default")
extern class RenderEvent extends Event
{
	public static inline var CLEAR_DOM = "clearDOM";
	public static inline var RENDER_CAIRO = "renderCairo";
	public static inline var RENDER_CANVAS = "renderCanvas";
	public static inline var RENDER_DOM = "renderDOM";
	public static inline var RENDER_OPENGL = "renderOpenGL";
	public var allowSmoothing:Bool;
	public var objectColorTransform:ColorTransform;
	public var objectMatrix:Matrix;
	public var renderer(default, null):DisplayObjectRenderer;
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, objectMatrix:Matrix = null, objectColorTransform:ColorTransform = null,
		allowSmoothing:Bool = true):Void;
}
