package openfl._internal.stage3D;


import lime.graphics.opengl.GL;
import lime.graphics.GLRenderContext;
import openfl._internal.stage3D.atf.ATFGPUFormat;
import openfl.errors.IllegalOperationError;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

class GLCompressedTextureFormats {


	private var __formatMap = new Map<ATFGPUFormat, Int>();
	private var __formatMapAlpha = new Map<ATFGPUFormat, Int>();


	public function new( gl: GLRenderContext ) {

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



	public function toTextureFormat( alpha:Bool, gpuFormat: ATFGPUFormat ):Int {
		
		if (alpha)
			return __formatMap[gpuFormat];
		else
			return __formatMapAlpha[gpuFormat];
	
	}
}