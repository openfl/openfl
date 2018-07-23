package openfl.display; #if !flash


import openfl.display3D.Context3DMipFilter;
import openfl.display3D.Context3DTextureFilter;
import openfl.display3D.Context3DWrapMode;

#if (lime >= "7.0.0")
import lime.graphics.RenderContext;
#else
import lime.graphics.GLRenderContext;
#end

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
	
	
	@:noCompletion private function __updateGL (context:#if (lime >= "7.0.0") RenderContext #else GLRenderContext #end, id:Int, overrideInput:T = null, overrideFilter:Context3DTextureFilter = null, overrideMipFilter:Context3DMipFilter = null, overrideWrap:Context3DWrapMode = null):Void {
		
		#if (lime >= "7.0.0")
		var gl = context.webgl;
		#else
		var gl = context;
		#end
		
		var input = overrideInput != null ? overrideInput : this.input;
		var filter = overrideFilter != null ? overrideFilter : this.filter;
		var mipFilter = overrideMipFilter != null ? overrideMipFilter : this.mipFilter;
		var wrap = overrideWrap != null ? overrideWrap : this.wrap;
		
		if (input != null) {
			
			// TODO: Improve for other input types? Use an interface perhaps
			
			var bitmapData:BitmapData = cast input;
			
			gl.activeTexture (gl.TEXTURE0 + id);
			gl.bindTexture (gl.TEXTURE_2D, bitmapData.getTexture (context));
			
			// TODO: Support anisotropic filter modes
			var smooth = (filter == Context3DTextureFilter.LINEAR);
			
			switch (mipFilter) {
				
				case Context3DMipFilter.MIPLINEAR:
					
					gl.generateMipmap (gl.TEXTURE_2D);
					gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, smooth ? gl.LINEAR_MIPMAP_LINEAR : gl.NEAREST_MIPMAP_LINEAR);
				
				case Context3DMipFilter.MIPNEAREST:
					
					gl.generateMipmap (gl.TEXTURE_2D);
					gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, smooth ? gl.LINEAR_MIPMAP_NEAREST : gl.NEAREST_MIPMAP_NEAREST);
				
				default:
					
					gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, smooth ? gl.LINEAR : gl.NEAREST);
				
			}
			
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, smooth ? gl.LINEAR : gl.NEAREST);
			
			var repeatS = (wrap == Context3DWrapMode.REPEAT || wrap == Context3DWrapMode.REPEAT_U_CLAMP_V);
			var repeatT = (wrap == Context3DWrapMode.REPEAT || wrap == Context3DWrapMode.CLAMP_U_REPEAT_V);
			
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, repeatS ? gl.REPEAT : gl.CLAMP_TO_EDGE);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, repeatT ? gl.REPEAT : gl.CLAMP_TO_EDGE);
			
		} else {
			
			gl.activeTexture (gl.TEXTURE0 + id);
			gl.bindTexture (gl.TEXTURE_2D, null);
			
		}
		
	}
	
	
}


#else
typedef ShaderInput<T> = flash.display.ShaderInput<T>;
#end