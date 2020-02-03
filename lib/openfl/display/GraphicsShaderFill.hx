package openfl.display;

#if (display || !flash)
import openfl.geom.Matrix;

@:jsRequire("openfl/display/GraphicsShaderFill", "default")
@:final extern class GraphicsShaderFill implements IGraphicsData implements IGraphicsFill
{
	public var matrix:Matrix;
	public var shader:Shader;
	public function new(shader:Shader = null, matrix:Matrix = null);
}
#else
typedef GraphicsShaderFill = flash.display.GraphicsShaderFill;
#end
