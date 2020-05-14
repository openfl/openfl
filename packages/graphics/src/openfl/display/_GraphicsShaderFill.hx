package openfl.display;

import openfl._internal.renderer.GraphicsDataType;
import openfl._internal.renderer.GraphicsFillType;
import openfl.geom.Matrix;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _GraphicsShaderFill implements _IGraphicsData implements _IGraphicsFill
{
	public var matrix:Matrix;
	public var shader:Shader;

	public var __graphicsDataType(default, null):GraphicsDataType;
	public var __graphicsFillType(default, null):GraphicsFillType;

	private var graphicsShaderFill:GraphicsShaderFill;

	public function new(graphicsShaderFill:GraphicsShaderFill, shader:Shader, matrix:Matrix = null)
	{
		this.graphicsShaderFill = graphicsShaderFill;

		this.shader = shader;
		this.matrix = matrix;

		this.__graphicsDataType = SHADER;
		this.__graphicsFillType = SHADER_FILL;
	}
}
