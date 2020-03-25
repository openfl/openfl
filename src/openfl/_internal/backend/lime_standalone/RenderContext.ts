namespace openfl._internal.backend.lime_standalone;

#if openfl_html5
class RenderContext
{
	public attributes(default , null): RenderContextAttributes;
	public canvas2D(default , null): Canvas2DRenderContext;
	public dom(default , null): DOMRenderContext;
	public type(default , null): RenderContextType;
	public version(default , null): string;
	public webgl(default , null): WebGLRenderContext;
	public webgl2(default , null): WebGL2RenderContext;
	public window(default , null): Window;

	protected new() { }
}
#end
