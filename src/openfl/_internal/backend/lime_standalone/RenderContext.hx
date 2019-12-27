package openfl._internal.backend.lime_standalone;

#if openfl_html5
class RenderContext
{
	public var attributes(default, null):RenderContextAttributes;
	public var canvas2D(default, null):Canvas2DRenderContext;
	public var dom(default, null):DOMRenderContext;
	public var type(default, null):RenderContextType;
	public var version(default, null):String;
	public var webgl(default, null):WebGLRenderContext;
	public var webgl2(default, null):WebGL2RenderContext;
	public var window(default, null):Window;

	@:noCompletion private function new() {}
}
#end
