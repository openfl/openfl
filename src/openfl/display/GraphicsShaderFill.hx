package openfl.display; #if !flash


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
	
	@:noCompletion private var __graphicsDataType (default, null):GraphicsDataType;
	@:noCompletion private var __graphicsFillType (default, null):GraphicsFillType;
	
	
	public function new (shader:Shader, matrix:Matrix = null) {
		
		this.shader = shader;
		this.matrix = matrix;
		
		this.__graphicsDataType = SHADER;
		this.__graphicsFillType = SHADER_FILL;
		
	}
	
	
}


#else
typedef GraphicsShaderFill = flash.display.GraphicsShaderFill;
#end