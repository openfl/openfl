package openfl.events;


import lime.graphics.CairoRenderContext;
import lime.graphics.CanvasRenderContext;
import lime.graphics.GLRenderContext;
import lime.math.Matrix3;
import lime.math.Matrix4;
import openfl.events.Event;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;


@:beta extern class RenderEvent extends Event {
	
	
	public static inline var CLEAR_DOM = "clearDOM";
	public static inline var RENDER_CAIRO = "renderCairo";
	public static inline var RENDER_CANVAS = "renderCanvas";
	public static inline var RENDER_DOM = "renderDOM";
	public static inline var RENDER_OPENGL = "renderOpenGL";
	
	public var allowSmoothing:Bool;
	public var cairo (default, null):CairoRenderContext;
	public var context (default, null):CanvasRenderContext;
	public var element (default, null):Dynamic;
	public var gl (default, null):GLRenderContext;
	public var renderTransform:Matrix;
	public var worldColorTransform:ColorTransform;
	public var worldTransform:Matrix;
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false):Void;
	public function applyDOMStyle (childElement:Dynamic):Void;
	public function clearDOMStyle (childElement:Dynamic):Void;
	public function getCairoMatrix (transform:Matrix):Matrix3;
	public function getOpenGLMatrix (transform:Matrix):Matrix4;
	
	
}