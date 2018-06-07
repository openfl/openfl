package openfl.filters;


import openfl.display.BlendMode;
import openfl.display.DisplayObjectRenderer;
import openfl.display.Shader;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class ShaderFilter extends BitmapFilter {
	
	
	@:beta public var blendMode:BlendMode;
	public var bottomExtension:Int;
	public var leftExtension:Int;
	public var rightExtension:Int;
	public var shader:Shader;
	public var topExtension:Int;
	
	
	public function new (shader:Shader) {
		
		super ();
		
		this.shader = shader;
		
		__numShaderPasses = 1;
		
	}
	
	
	public override function clone ():BitmapFilter {
		
		var filter = new ShaderFilter (shader);
		filter.bottomExtension = bottomExtension;
		filter.leftExtension = leftExtension;
		filter.rightExtension = rightExtension;
		filter.topExtension = topExtension;
		return filter;
		
	}
	
	
	private override function __initShader (renderer:DisplayObjectRenderer, pass:Int):Shader {
		
		__shaderBlendMode = blendMode;
		return shader;
		
	}
	
	
}
