package openfl.filters;


import openfl._internal.renderer.RenderSession;
import openfl.display.Shader;


class ShaderFilter extends BitmapFilter {
	
	
	public var bottomExtension:Int;
	public var leftExtension:Int;
	public var rightExtension:Int;
	public var shader:Shader;
	public var topExtension:Int;
	
	
	public function new (shader:Shader) {
		
		super ();
		
		this.shader = shader;
		
		// __numShaderPasses = 1;
		__numShaderPasses = 0;
		
	}
	
	
	public override function clone ():BitmapFilter {
		
		var filter = new ShaderFilter (shader);
		filter.bottomExtension = bottomExtension;
		filter.leftExtension = leftExtension;
		filter.rightExtension = rightExtension;
		filter.topExtension = topExtension;
		return filter;
		
	}
	
	
	private override function __initShader (renderSession:RenderSession, pass:Int):Shader {
		
		return shader;
		
	}
	
	
}