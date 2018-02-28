package openfl.display;


import openfl.display.IGraphicsData;
import openfl.display.IGraphicsFill;
import openfl.geom.Matrix;


@:final class GraphicsShaderFill implements IGraphicsData implements IGraphicsFill {
	
	
	public var shader:GraphicsShader;
	public var matrix:Matrix;
	
	public var __graphicsDataType (default, null):GraphicsDataType;
	public var __graphicsFillType (default, null):GraphicsFillType;
	
	
	public function new (shader:GraphicsShader, matrix:Matrix = null) {
		
		this.shader = shader;
		this.matrix = matrix;
		
		this.__graphicsDataType = SHADER;
		this.__graphicsFillType = SHADER_FILL;
		
	}
	
	
}