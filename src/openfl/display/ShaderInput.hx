package openfl.display;


import lime.graphics.GLRenderContext;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

#if !js @:generic #end


@:final class ShaderInput<T> /*implements Dynamic*/ {
	
	
	public var channels (default, null):Int;
	public var height:Int;
	public var index (default, null):Dynamic;
	public var input:T;
	@:noCompletion public var name:String;
	public var smoothing:Bool;
	public var width:Int;
	
	private var __isUniform:Bool;
	
	
	public function new () {
		
		channels = 0;
		height = 0;
		index = 0;
		width = 0;
		
	}
	
	
	private function __updateGL (gl:GLRenderContext, id:Int, overrideInput:T = null, overrideSmoothing:Null<Bool> = null):Void {
		
		var input = overrideInput != null ? overrideInput : this.input;
		var smoothing = overrideSmoothing != null ? overrideSmoothing : this.smoothing;
		
		if (input != null) {
			
			// TODO: Improve
			var bitmapData:BitmapData = cast input;
			
			gl.activeTexture (gl.TEXTURE0 + id);
			gl.bindTexture (gl.TEXTURE_2D, bitmapData.getTexture (gl));
			
			if (smoothing) {
				
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
				
			} else {
				
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
				
			}
			
		}
		
	}
	
	
}