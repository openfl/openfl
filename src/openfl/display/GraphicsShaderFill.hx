package openfl.display;


import openfl.display.IGraphicsData;
import openfl.display.IGraphicsFill;
import openfl.geom.Matrix;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


@:final class GraphicsShaderFill implements IGraphicsData implements IGraphicsFill {
	
	
	public var shader:Shader;
	public var matrix:Matrix;
	
	public var __graphicsDataType (default, null):GraphicsDataType;
	public var __graphicsFillType (default, null):GraphicsFillType;
	
	
	public function new (shader:Shader, matrix:Matrix = null) {
		
		this.shader = shader;
		this.matrix = matrix;
		
		this.__graphicsDataType = SHADER;
		this.__graphicsFillType = SHADER_FILL;
		
	}
	
	
}