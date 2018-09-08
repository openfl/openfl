package openfl.display; #if !flash


import openfl.display3D.Context3DMipFilter;
import openfl.display3D.Context3DTextureFilter;
import openfl.display3D.Context3DWrapMode;
import openfl.display3D.Context3D;

@:access(openfl.display3D.Context3D)

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

#if (!js && !display) @:generic #end


@:final class ShaderInput<T> /*implements Dynamic*/ {
	
	
	public var channels (default, null):Int;
	public var filter:Context3DTextureFilter;
	public var height:Int;
	public var index (default, null):Dynamic;
	public var input:T;
	public var mipFilter:Context3DMipFilter;
	@:noCompletion public var name:String;
	public var width:Int;
	public var wrap:Context3DWrapMode;
	
	@:noCompletion private var __isUniform:Bool;
	
	
	public function new () {
		
		channels = 0;
		filter = NEAREST;
		height = 0;
		index = 0;
		mipFilter = MIPNONE;
		width = 0;
		wrap = CLAMP;
		
	}
	
	
	@:noCompletion private function __disableGL (context:Context3D, id:Int):Void {
		
		var gl = context.gl;
		context.setTextureAt (id, null);
		
	}
	
	
	@:noCompletion private function __updateGL (context:Context3D, id:Int, overrideInput:T = null, overrideFilter:Context3DTextureFilter = null, overrideMipFilter:Context3DMipFilter = null, overrideWrap:Context3DWrapMode = null):Void {
		
		var gl = context.gl;
		var input = overrideInput != null ? overrideInput : this.input;
		var filter = overrideFilter != null ? overrideFilter : this.filter;
		var mipFilter = overrideMipFilter != null ? overrideMipFilter : this.mipFilter;
		var wrap = overrideWrap != null ? overrideWrap : this.wrap;
		
		if (input != null) {
			
			// TODO: Improve for other input types? Use an interface perhaps
			
			var bitmapData:BitmapData = cast input;
			context.setTextureAt (id, bitmapData.getTexture (context));
			context.setSamplerStateAt (id, wrap, filter, mipFilter);
			
		} else {
			
			context.setTextureAt (id, null);
			
		}
		
	}
	
	
}


#else
typedef ShaderInput<T> = flash.display.ShaderInput<T>;
#end