package flash.display;

#if flash
import openfl.geom.Matrix;

@:final extern class GraphicsShaderFill implements IGraphicsData implements IGraphicsFill
{
	public var matrix:Matrix;
	public var shader:Shader;
	public function new(?shader:Shader, ?matrix:Matrix):Void;
}
#else
typedef GraphicsShaderFill = openfl.display.GraphicsShaderFill;
#end
