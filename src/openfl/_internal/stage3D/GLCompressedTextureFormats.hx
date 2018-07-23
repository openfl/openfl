package openfl._internal.stage3D;


import lime.graphics.opengl.GL;
import openfl._internal.stage3D.atf.ATFGPUFormat;
import openfl.errors.IllegalOperationError;

#if (lime >= "7.0.0")
import lime.graphics.RenderContext;
#else
import lime.graphics.GLRenderContext;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class GLCompressedTextureFormats {
	
	
	private var __formatMap = new Map<Int, Int> ();
	private var __formatMapAlpha = new Map<Int, Int> ();
	
	
	public function new (context:#if (lime >= "7.0.0") RenderContext #else GLRenderContext #end) {
		
		checkDXT (context);
		checkETC1 (context);
		checkPVRTC (context);
		
	}
	
	
	public function checkDXT (context:#if (lime >= "7.0.0") RenderContext #else GLRenderContext #end):Void {
		
		#if (lime >= "7.0.0")
		var gl = context.webgl;
		#else
		var gl = context;
		#end
		
		#if (js && html5)
		var compressedExtension = gl.getExtension ("WEBGL_compressed_texture_s3tc");
		#else
		var compressedExtension = gl.getExtension ("EXT_texture_compression_s3tc");
		#end
		
		if (compressedExtension != null) {
			
			__formatMap[ATFGPUFormat.DXT] = compressedExtension.COMPRESSED_RGBA_S3TC_DXT1_EXT;
			__formatMapAlpha[ATFGPUFormat.DXT] = compressedExtension.COMPRESSED_RGBA_S3TC_DXT5_EXT;
			
		}
		
	}
	
	
	public function checkETC1 (context:#if (lime >= "7.0.0") RenderContext #else GLRenderContext #end):Void {
		
		#if (lime >= "7.0.0")
		var gl = context.webgl;
		#else
		var gl = context;
		#end
		
		#if (js && html5)
		
		var compressedExtension = gl.getExtension ("WEBGL_compressed_texture_etc1");
		if (compressedExtension != null) {
			
			__formatMap[ATFGPUFormat.ETC1] = compressedExtension.COMPRESSED_RGB_ETC1_WEBGL;
			__formatMapAlpha[ATFGPUFormat.ETC1] = compressedExtension.COMPRESSED_RGB_ETC1_WEBGL;
			
		}
		
		#else
		
		var compressedExtension = gl.getExtension ("OES_compressed_ETC1_RGB8_texture");
		if (compressedExtension != null) {
			
			__formatMap[ATFGPUFormat.ETC1] = compressedExtension.ETC1_RGB8_OES;
			__formatMapAlpha[ATFGPUFormat.ETC1] = compressedExtension.ETC1_RGB8_OES;
			
		}
		
		#end
		
	}
	
	
	public function checkPVRTC (context:#if (lime >= "7.0.0") RenderContext #else GLRenderContext #end):Void {
		
		#if (lime >= "7.0.0")
		var gl = context.webgl;
		#else
		var gl = context;
		#end
		
		#if (js && html5)
		// WEBGL_compressed_texture_pvrtc is not available on iOS Safari
		var compressedExtension = gl.getExtension ("WEBKIT_WEBGL_compressed_texture_pvrtc");
		#else
		var compressedExtension = gl.getExtension ("IMG_texture_compression_pvrtc");
		#end
		
		if (compressedExtension != null) {
			
			__formatMap[ATFGPUFormat.PVRTC] = compressedExtension.COMPRESSED_RGB_PVRTC_4BPPV1_IMG;
			__formatMapAlpha[ATFGPUFormat.PVRTC] = compressedExtension.COMPRESSED_RGBA_PVRTC_4BPPV1_IMG;
			
		}
		
	}
	
	
	public function toTextureFormat (alpha:Bool, gpuFormat:ATFGPUFormat):Int {
		
		if (alpha) {
			
			return __formatMapAlpha[gpuFormat];
			
		} else {
			
			return __formatMap[gpuFormat];
			
		}
		
	}
	
	
}