package openfl._internal.stage3D.opengl;


import lime.graphics.GLRenderContext;
import lime.math.Rectangle in LimeRectangle;
import lime.math.Vector2;
import lime.utils.Float32Array;
import openfl._internal.stage3D.GLUtils;
import openfl._internal.stage3D.SamplerState;
import openfl.display3D.textures.CubeTexture;
import openfl.display3D.textures.RectangleTexture;
import openfl.display3D.textures.TextureBase;
import openfl.display3D.textures.Texture;
import openfl.display3D.Context3DBlendFactor;
import openfl.display3D.Context3DClearMask;
import openfl.display3D.Context3DCompareMode;
import openfl.display3D.Context3DMipFilter;
import openfl.display3D.Context3DProgramType;
import openfl.display3D.Context3DStencilAction;
import openfl.display3D.Context3DTextureFilter;
import openfl.display3D.Context3DTriangleFace;
import openfl.display3D.Context3DVertexBufferFormat;
import openfl.display3D.Context3DWrapMode;
import openfl.display3D.Context3D;
import openfl.display3D.IndexBuffer3D;
import openfl.display3D.Program3D;
import openfl.display3D.VertexBuffer3D;
import openfl.display.BitmapData;
import openfl.display.Stage3D;
import openfl.errors.Error;
import openfl.errors.IllegalOperationError;
import openfl.geom.Matrix3D;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import openfl.Vector;

#if gl_stats
import openfl._internal.renderer.opengl.stats.GLStats;
import openfl._internal.renderer.opengl.stats.DrawCallContext;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl._internal.stage3D.Context3DStateCache)
@:access(openfl._internal.stage3D.GLUtils)
@:access(openfl.display3D.textures.TextureBase)
@:access(openfl.display3D.Context3D)
@:access(openfl.display3D.IndexBuffer3D)
@:access(openfl.display3D.Program3D)
@:access(openfl.display3D.VertexBuffer3D)
@:access(openfl.display.Stage3D)


class GLContext3D {
	
	
	private static var context:Context3D;
	private static var gl:GLRenderContext;
	
	
	public static function create (context:Context3D) {
		
		var gl = context.__renderSession.gl;
		
		context.__vertexConstants = new Float32Array (4 * Context3D.MAX_PROGRAM_REGISTERS);
		context.__fragmentConstants = new Float32Array (4 * Context3D.MAX_PROGRAM_REGISTERS);
		
		context.__positionScale = new Float32Array ([ 1.0, 1.0, 1.0, 1.0 ]);
		context.__samplerDirty = 0;
		context.__samplerTextures = new Vector<TextureBase> (Context3D.MAX_SAMPLERS);
		context.__samplerStates = [];
		
		for (i in 0 ... Context3D.MAX_SAMPLERS) {
			
			context.__samplerStates[i] = new SamplerState (gl.LINEAR, gl.LINEAR, gl.CLAMP_TO_EDGE, gl.CLAMP_TO_EDGE);
			
		}
		
		#if (js && html5)
		context.maxBackBufferHeight = context.maxBackBufferWidth = gl.getParameter (gl.MAX_VIEWPORT_DIMS);
		#else
		context.maxBackBufferHeight = context.maxBackBufferWidth = 16384;
		#end
		
		context.__backBufferAntiAlias = 0;
		context.__backBufferEnableDepthAndStencil = true;
		context.__backBufferWantsBestResolution = false;
		
		context.__frameCount = 0;
		context.__rttDepthAndStencil = false;
		context.__samplerDirty = 0;
		context.__stencilCompareMode = Context3DCompareMode.ALWAYS;
		context.__stencilRef = 0;
		context.__stencilReadMask = 0xFF;
		
		var anisoExtension:Dynamic = gl.getExtension ("EXT_texture_filter_anisotropic");
		
		#if (js && html5)
		
		if (anisoExtension == null || !Reflect.hasField (anisoExtension, "MAX_TEXTURE_MAX_ANISOTROPY_EXT"))
			anisoExtension = gl.getExtension ("MOZ_EXT_texture_filter_anisotropic");
		if (anisoExtension == null || !Reflect.hasField (anisoExtension, "MAX_TEXTURE_MAX_ANISOTROPY_EXT"))
			anisoExtension = gl.getExtension ("WEBKIT_EXT_texture_filter_anisotropic");
		
		context.__supportsPackedDepthStencil = true;
		Context3D.DEPTH_STENCIL = gl.DEPTH_STENCIL;
		
		#else
		
		if (gl.type == GLES && gl.version >= 3) {
			
			context.__supportsPackedDepthStencil = true;
			Context3D.DEPTH_STENCIL = gl.DEPTH24_STENCIL8;
			
		} else {
			
			var stencilExtension = gl.getExtension ("OES_packed_depth_stencil");
			
			if (stencilExtension != null) {
				
				context.__supportsPackedDepthStencil = true;
				Context3D.DEPTH_STENCIL = stencilExtension.DEPTH24_STENCIL8_OES;
				
			} else {
				
				stencilExtension = gl.getExtension ("EXT_packed_depth_stencil");
				
				if (stencilExtension != null) {
					
					context.__supportsPackedDepthStencil = true;
					Context3D.DEPTH_STENCIL = stencilExtension.DEPTH24_STENCIL8_EXT;
					
				}
				
			}
			
		}
		
		#end
		
		context.__supportsAnisotropicFiltering = (anisoExtension != null);
		
		if (context.__supportsAnisotropicFiltering) {
			
			Context3D.TEXTURE_MAX_ANISOTROPY_EXT = anisoExtension.TEXTURE_MAX_ANISOTROPY_EXT;
			
			var maxAnisotropy:Int = gl.getParameter (anisoExtension.MAX_TEXTURE_MAX_ANISOTROPY_EXT);
			context.__maxAnisotropyTexture2D = maxAnisotropy;
			context.__maxAnisotropyTexture2D = maxAnisotropy;
			
		}
		
		// __stats = new Vector<Int> (Context3DTelemetry.length);
		// __statsCache = new Vector<Int> (Context3DTelemetry.length);
		
		#if telemetry
		//__spanPresent = new Telemetry.Span (".rend.molehill.present");
		//__valueFrame = new Telemetry.Value (".rend.molehill.frame");
		#end
		
		GLUtils.CheckGLError ();
		
		var vendor = gl.getParameter (gl.VENDOR);
		GLUtils.CheckGLError ();
		
		var version = gl.getParameter (gl.VERSION);
		GLUtils.CheckGLError ();
		
		var renderer = gl.getParameter (gl.RENDERER);
		GLUtils.CheckGLError ();
		
		var glslVersion = gl.getParameter (gl.SHADING_LANGUAGE_VERSION);
		GLUtils.CheckGLError ();
		
		context.driverInfo = "OpenGL" +
					 " Vendor=" + vendor +
					 " Version=" + version +
					 " Renderer=" + renderer +
					 " GLSL=" + glslVersion;
		
		#if telemetry
		//Telemetry.Session.WriteValue (".platform.3d.driverinfo", driverInfo);
		#end
		
		// for (i in 0...__stats.length) {
			
		// 	__stats[i] = 0;
			
		// }
		
		// __stateCache.clearSettings ();
		
	}
	
	
	public static function clear (context:Context3D, red:Float = 0, green:Float = 0, blue:Float = 0, alpha:Float = 1, depth:Float = 1, stencil:UInt = 0, mask:UInt = Context3DClearMask.ALL):Void {
		
		var gl = context.__renderSession.gl;
		var clearMask = 0;
		
		if (mask & Context3DClearMask.COLOR != 0) {
			
			clearMask |= gl.COLOR_BUFFER_BIT;
			
			gl.clearColor (red, green, blue, alpha);
			GLUtils.CheckGLError ();
			
		}
		
		if (mask & Context3DClearMask.DEPTH != 0) {
			
			clearMask |= gl.DEPTH_BUFFER_BIT;
			
			gl.clearDepthf (depth);
			GLUtils.CheckGLError ();
			
		}
		
		if (mask & Context3DClearMask.STENCIL != 0) {
			
			clearMask |= gl.STENCIL_BUFFER_BIT;
			
			gl.clearStencil (stencil);
			GLUtils.CheckGLError ();
			
		}
		
		gl.clear (clearMask);
		GLUtils.CheckGLError ();
		
	}
	
	
	public static function configureBackBuffer (context:Context3D, width:Int, height:Int, antiAlias:Int, enableDepthAndStencil:Bool = true, wantsBestResolution:Bool = false, wantsBestResolutionOnBrowserZoom:Bool = false):Void {
		
		GLContext3D.context = context;
		GLContext3D.gl = context.__renderSession.gl;
		
		__updateBackbufferViewport ();
		
		var scale = context.__stage3D.__stage.window.scale;
		
		context.backBufferWidth = Math.ceil (width * scale);
		context.backBufferHeight = Math.ceil (height * scale);
		
		context.__backBufferAntiAlias = antiAlias;
		context.__backBufferEnableDepthAndStencil = enableDepthAndStencil;
		context.__backBufferWantsBestResolution = wantsBestResolution;
		
		Context3D.__stateCache.clearSettings ();
		
	}
	
	
	public static function dispose (context:Context3D, recreate:Bool = true):Void {
		
		// TODO
		
	}
	
	
	public static function drawToBitmapData (context:Context3D, destination:BitmapData):Void {
		
		var window = context.__stage3D.__stage.window;
		
		if (window != null) {
			
			var image = window.renderer.readPixels ();
			var heightOffset = image.height - context.backBufferHeight;
			
			destination.image.copyPixels (image, new LimeRectangle (Std.int (context.__stage3D.x), Std.int (context.__stage3D.y + heightOffset), context.backBufferWidth, context.backBufferHeight), new Vector2 ());
			
		}
		
	}
	
	
	public static function drawTriangles (context:Context3D, indexBuffer:IndexBuffer3D, firstIndex:Int = 0, numTriangles:Int = -1):Void {
		
		if (context.__program == null) {
			
			return;
			
		}
		
		GLContext3D.context = context;
		GLContext3D.gl = context.__renderSession.gl;
		
		__flushSamplerState ();
		context.__program.__flush ();
		
		var count = (numTriangles == -1) ? indexBuffer.__numIndices : (numTriangles * 3);
		
		gl.bindBuffer (gl.ELEMENT_ARRAY_BUFFER, indexBuffer.__id);
		GLUtils.CheckGLError ();
		
		gl.drawElements (gl.TRIANGLES, count, indexBuffer.__elementType, firstIndex);
		GLUtils.CheckGLError ();
		
		#if gl_stats
			GLStats.incrementDrawCall (DrawCallContext.STAGE3D);
		#end
		// __statsIncrement (Context3DTelemetry.DRAW_CALLS);
		
	}
	
	
	
	public static function present (context:Context3D):Void {
		
		// __statsSendToTelemetry ();
		
		#if telemetry
		//__spanPresent.End ();
		//__spanPresent.Begin ();
		#end
		
		// __statsClear (Context3DTelemetry.DRAW_CALLS);
		
		// __frameCount++;
		
	}
	
	
	public static function setBlendFactors (context:Context3D, sourceFactor:Context3DBlendFactor, destinationFactor:Context3DBlendFactor):Void {
		
		var gl = context.__renderSession.gl;
		
		if (Context3D.__stateCache.updateBlendFactors (sourceFactor, destinationFactor)) {
		
			gl.enable (gl.BLEND);
			GLUtils.CheckGLError ();
			gl.blendFunc (__getGLBlendFactor (sourceFactor), __getGLBlendFactor (destinationFactor));
			GLUtils.CheckGLError ();
			
		}
		
	}
	
	
	public static function setColorMask (context:Context3D, red:Bool, green:Bool, blue:Bool, alpha:Bool):Void {
		
		var gl = context.__renderSession.gl;
		
		gl.colorMask (red, green, blue, alpha);
		
	}
	
	
	public static function setCulling (context:Context3D, triangleFaceToCull:Context3DTriangleFace):Void {
		
		var gl = context.__renderSession.gl;
		
		if (Context3D.__stateCache.updateCullingMode (triangleFaceToCull)) {
			
			if (triangleFaceToCull == NONE) {
				
				gl.disable (gl.CULL_FACE);
				
			} else {
				
				gl.enable (gl.CULL_FACE);
				gl.cullFace (__getGLTriangleFace (triangleFaceToCull, true));
				
			}
			
		}
		
	}
	
	
	public static function setDepthTest (context:Context3D, depthMask:Bool, passCompareMode:Context3DCompareMode):Void {
		
		var gl = context.__renderSession.gl;
		var depthTestEnabled = context.__backBufferEnableDepthAndStencil;
		
		if (Context3D.__stateCache.updateDepthTestEnabled (depthTestEnabled)) {
			
			if (depthTestEnabled) {
				
				gl.enable (gl.DEPTH_TEST);
				
			} else {
				
				gl.disable (gl.DEPTH_TEST);
				
			}
			
		}
		
		if (Context3D.__stateCache.updateDepthTestMask (depthMask)) {
			
			gl.depthMask (depthMask);
			
		}
		
		if (Context3D.__stateCache.updateDepthCompareMode (passCompareMode)) {
			
			gl.depthFunc (__getGLCompareMode (passCompareMode));
			
		}
		
	}
	
	
	public static function setEnableErrorChecking (value:Bool):Void {
		
		GLUtils.debug = value;
		
	}
	
	
	public static function setProgram (context:Context3D, program:Program3D):Void {
		
		if (Context3D.__stateCache.updateProgram3D (program)) {
			
			program.__use ();
			program.__setPositionScale (context.__positionScale);
			
			context.__program = program;
			
			context.__samplerDirty |= context.__program.__samplerUsageMask;
			
			for (i in 0...Context3D.MAX_SAMPLERS) {
				
				context.__samplerStates[i].copyFrom (context.__program.__getSamplerState (i));
				
			}
			
		}
		
	}
	
	
	public static function setProgramConstantsFromByteArray (context:Context3D, programType:Context3DProgramType, firstRegister:Int, numRegisters:Int, data:ByteArray, byteArrayOffset:UInt):Void {
		
		var gl = context.__renderSession.gl;
		
		if (numRegisters == -1) {
			
			numRegisters = ((data.length >> 2) - byteArrayOffset);
			
		}
		
		var isVertex = (programType == Context3DProgramType.VERTEX);
		var dest = isVertex ? context.__vertexConstants : context.__fragmentConstants;
		
		var floatData = Float32Array.fromBytes (data, 0, data.length);
		var outOffset = firstRegister * 4;
		var inOffset = Std.int (byteArrayOffset / 4);
		
		for (i in 0...(numRegisters * 4)) {
			
			dest[outOffset + i] = floatData[inOffset + i];
			
		}
		
		if (context.__program != null) {
			
			context.__program.__markDirty (isVertex, firstRegister, numRegisters);
			
		}
		
	}
	
	
	public static function setProgramConstantsFromMatrix (context:Context3D, programType:Context3DProgramType, firstRegister:Int, matrix:Matrix3D, transposedMatrix:Bool = false):Void {
		
		var isVertex = (programType == Context3DProgramType.VERTEX);
		var dest = isVertex ? context.__vertexConstants : context.__fragmentConstants;
		var source = matrix.rawData;
		var i = firstRegister * 4;
		
		if (transposedMatrix) {
			
			dest[i++] = source[0];
			dest[i++] = source[4];
			dest[i++] = source[8];
			dest[i++] = source[12];
			
			dest[i++] = source[1];
			dest[i++] = source[5];
			dest[i++] = source[9];
			dest[i++] = source[13];
			
			dest[i++] = source[2];
			dest[i++] = source[6];
			dest[i++] = source[10];
			dest[i++] = source[14];
			
			dest[i++] = source[3];
			dest[i++] = source[7];
			dest[i++] = source[11];
			dest[i++] = source[15];
			
		} else {
			
			dest[i++] = source[0];
			dest[i++] = source[1];
			dest[i++] = source[2];
			dest[i++] = source[3];
			
			dest[i++] = source[4];
			dest[i++] = source[5];
			dest[i++] = source[6];
			dest[i++] = source[7];
			
			dest[i++] = source[8];
			dest[i++] = source[9];
			dest[i++] = source[10];
			dest[i++] = source[11];
			
			dest[i++] = source[12];
			dest[i++] = source[13];
			dest[i++] = source[14];
			dest[i++] = source[15];
			
		}
		
		if (context.__program != null) {
			
			context.__program.__markDirty (isVertex, firstRegister, 4);
			
		}
		
	}
	
	
	public static function setProgramConstantsFromVector (context:Context3D, programType:Context3DProgramType, firstRegister:Int, data:Vector<Float>, numRegisters:Int = -1):Void {
		
		if (numRegisters == -1) {
			
			numRegisters = (data.length >> 2);
			
		}
		
		var isVertex = (programType == VERTEX);
		var dest = isVertex ? context.__vertexConstants : context.__fragmentConstants;
		var source = data;
		
		var sourceIndex = 0;
		var destIndex = firstRegister * 4;
		
		for (i in 0...numRegisters) {
			
			dest[destIndex++] = source[sourceIndex++];
			dest[destIndex++] = source[sourceIndex++];
			dest[destIndex++] = source[sourceIndex++];
			dest[destIndex++] = source[sourceIndex++];
			
		}
		
		if (context.__program != null) {
			
			context.__program.__markDirty (isVertex, firstRegister, numRegisters);
			
		}
		
	}
	
	
	public static function setRenderToBackBuffer (context:Context3D):Void {
		
		var gl = context.__renderSession.gl;
		
		gl.bindFramebuffer (gl.FRAMEBUFFER, null);
		GLUtils.CheckGLError ();
		
		gl.frontFace (gl.CCW);
		GLUtils.CheckGLError ();
		
		context.__renderToTexture = null;
		__updateBackbufferViewport ();
		__disableScissorRectangle ();
		__updateDepthAndStencilState ();
		
		context.__positionScale[1] = 1.0;
		
		if (context.__program != null) {
			
			context.__program.__setPositionScale (context.__positionScale);
			
		}
		
	}
	
	
	public static function setRenderToTexture (context:Context3D, texture:TextureBase, enableDepthAndStencil:Bool = false, antiAlias:Int = 0, surfaceSelector:Int = 0):Void {
		
		var gl = context.__renderSession.gl;
		
		var width = texture.__width;
		var height = texture.__height;
		var create = texture.__framebuffer == null;
		
		if (create) {
			
			texture.__framebuffer = gl.createFramebuffer ();
			GLUtils.CheckGLError ();
			
		}
		
		gl.bindFramebuffer (gl.FRAMEBUFFER, texture.__framebuffer);
		GLUtils.CheckGLError ();
		
		if (create) {
			
			if (Std.is (texture, Texture)) {
				
				gl.framebufferTexture2D (gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_2D, texture.__textureID, 0);
				GLUtils.CheckGLError ();
				
			} else if (Std.is (texture, RectangleTexture)) {
				
				gl.framebufferTexture2D (gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_2D, texture.__textureID, 0);
				GLUtils.CheckGLError ();
				
			} else if (Std.is (texture, CubeTexture)) {
				
				for (i in 0...6) {
					
					gl.framebufferTexture2D (gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_CUBE_MAP_POSITIVE_X + i, texture.__textureID, 0);
					GLUtils.CheckGLError ();
					
				}
				
			} else {
				
				throw new Error ("Invalid texture");
				
			}
			
		}
		
		if (create && enableDepthAndStencil) {
			
			if (context.__supportsPackedDepthStencil) {
				
				texture.__depthStencilRenderbuffer = gl.createRenderbuffer ();
				GLUtils.CheckGLError ();
				
				gl.bindRenderbuffer (gl.RENDERBUFFER, texture.__depthStencilRenderbuffer);
				GLUtils.CheckGLError ();
				gl.renderbufferStorage (gl.RENDERBUFFER, Context3D.DEPTH_STENCIL, width, height);
				GLUtils.CheckGLError ();
				
				gl.framebufferRenderbuffer (gl.FRAMEBUFFER, gl.DEPTH_STENCIL_ATTACHMENT, gl.RENDERBUFFER, texture.__depthStencilRenderbuffer);
				GLUtils.CheckGLError ();
				
			} else {
				
				texture.__depthRenderbuffer = gl.createRenderbuffer ();
				texture.__stencilRenderbuffer = gl.createRenderbuffer ();
				
				gl.bindRenderbuffer (gl.RENDERBUFFER, texture.__stencilRenderbuffer);
				GLUtils.CheckGLError ();
				gl.renderbufferStorage (gl.RENDERBUFFER, gl.DEPTH_COMPONENT16, width, height);
				GLUtils.CheckGLError ();
				
				gl.bindRenderbuffer (gl.RENDERBUFFER, texture.__stencilRenderbuffer);
				GLUtils.CheckGLError ();
				gl.renderbufferStorage (gl.RENDERBUFFER, gl.STENCIL_INDEX8, width, height);
				GLUtils.CheckGLError ();
				
				gl.framebufferRenderbuffer (gl.FRAMEBUFFER, gl.DEPTH_ATTACHMENT, gl.RENDERBUFFER, texture.__depthRenderbuffer);
				GLUtils.CheckGLError ();
				gl.framebufferRenderbuffer (gl.FRAMEBUFFER, gl.STENCIL_ATTACHMENT, gl.RENDERBUFFER, texture.__stencilRenderbuffer);
				GLUtils.CheckGLError ();
				
			}
			
			gl.bindRenderbuffer (gl.RENDERBUFFER, null);
			GLUtils.CheckGLError ();
			
		}
		
		if (create && context.__enableErrorChecking) {
			
			var code = gl.checkFramebufferStatus (gl.FRAMEBUFFER);
			
			if (code != gl.FRAMEBUFFER_COMPLETE) {
				
				trace ('Error: Context3D.setRenderToTexture status:${code} width:${width} height:${height}');
				
			}
			
		}
		
		__setViewport (0, 0, width, height);
		
		context.__positionScale[1] = -1.0;
		
		if (context.__program != null) {
			
			context.__program.__setPositionScale (context.__positionScale);
			
		}
		
		gl.frontFace (gl.CW);
		GLUtils.CheckGLError ();
		
		context.__renderToTexture = texture;
		context.__rttDepthAndStencil = enableDepthAndStencil;
		__disableScissorRectangle();
		__updateDepthAndStencilState ();
		
	}
	
	
	public static function setSamplerStateAt (context:Context3D, sampler:Int, wrap:Context3DWrapMode, filter:Context3DTextureFilter, mipfilter:Context3DMipFilter):Void {
		
		if (sampler < 0 || sampler > Context3D.MAX_SAMPLERS) {
			
			throw new Error ("sampler out of range");
			
		}
		
		var gl = context.__renderSession.gl;
		var state = context.__samplerStates[sampler];
		
		switch (wrap) {
			
			case Context3DWrapMode.CLAMP:
				
				state.wrapModeS = gl.CLAMP_TO_EDGE;
				state.wrapModeT = gl.CLAMP_TO_EDGE;
			
			case Context3DWrapMode.CLAMP_U_REPEAT_V:
				
				state.wrapModeS = gl.CLAMP_TO_EDGE;
				state.wrapModeT = gl.REPEAT;
			
			case Context3DWrapMode.REPEAT:
				
				state.wrapModeS = gl.REPEAT;
				state.wrapModeT = gl.REPEAT;
			
			case Context3DWrapMode.REPEAT_U_CLAMP_V:
				
				state.wrapModeS = gl.REPEAT;
				state.wrapModeT = gl.CLAMP_TO_EDGE;
			
			default:
				
				throw new Error ("wrap bad enum");
			
		}
		
		switch (filter) {
			
			case Context3DTextureFilter.LINEAR:
				
				state.magFilter = gl.LINEAR;
				
				if (context.__supportsAnisotropicFiltering) {
					
					state.maxAniso = 1;
					
				}
			
			case Context3DTextureFilter.NEAREST:
				
				state.magFilter = gl.NEAREST;
				
				if (context.__supportsAnisotropicFiltering) {
					
					state.maxAniso = 1;
					
				}
			
			case Context3DTextureFilter.ANISOTROPIC2X:
				
				if (context.__supportsAnisotropicFiltering) {
					
					state.maxAniso = (context.__maxAnisotropyTexture2D < 2 ? context.__maxAnisotropyTexture2D : 2);
					
				}
			
			case Context3DTextureFilter.ANISOTROPIC4X:
				
				if (context.__supportsAnisotropicFiltering) {
					
					state.maxAniso = (context.__maxAnisotropyTexture2D < 4 ? context.__maxAnisotropyTexture2D : 4);
					
				}
			
			case Context3DTextureFilter.ANISOTROPIC8X:
				
				if (context.__supportsAnisotropicFiltering) {
					
					state.maxAniso = (context.__maxAnisotropyTexture2D < 8 ? context.__maxAnisotropyTexture2D : 8);
					
				}
				
			case Context3DTextureFilter.ANISOTROPIC16X:
				
				if (context.__supportsAnisotropicFiltering) {
					
					state.maxAniso = (context.__maxAnisotropyTexture2D < 16 ? context.__maxAnisotropyTexture2D : 16);
					
				}
			
			default:
				
				throw new Error ("filter bad enum");
			
		}
		
		switch (mipfilter) {
			
			case Context3DMipFilter.MIPLINEAR:
				
				state.minFilter = filter == Context3DTextureFilter.NEAREST ? gl.NEAREST_MIPMAP_LINEAR : gl.LINEAR_MIPMAP_LINEAR;
			
			case Context3DMipFilter.MIPNEAREST:
				
				state.minFilter = filter == Context3DTextureFilter.NEAREST ? gl.NEAREST_MIPMAP_NEAREST : gl.LINEAR_MIPMAP_NEAREST;
			
			case Context3DMipFilter.MIPNONE:
				
				state.minFilter = filter == Context3DTextureFilter.NEAREST ? gl.NEAREST : gl.LINEAR;
			
			default:
				
				throw new Error ("mipfiter bad enum");
			
		}
		
	}
	
	
	public static function setScissorRectangle (context:Context3D, rectangle:Rectangle):Void {
		
		GLContext3D.context = context;
		GLContext3D.gl = context.__renderSession.gl;
		
		if (rectangle != null) {
			
			var scale = context.__stage3D.__stage.window.scale;
			__setScissorRectangle (Std.int (rectangle.x * scale), Std.int (rectangle.y * scale), 
								Std.int (rectangle.width * scale), Std.int (rectangle.height * scale));
			
		} else {
			
			__disableScissorRectangle ();
			
		}
		
	}
	
	
	public static function setStencilActions (context:Context3D, triangleFace:Context3DTriangleFace = FRONT_AND_BACK, compareMode:Context3DCompareMode = ALWAYS, actionOnBothPass:Context3DStencilAction = KEEP, actionOnDepthFail:Context3DStencilAction = KEEP, actionOnDepthPassStencilFail:Context3DStencilAction = KEEP):Void {
		
		GLContext3D.context = context;
		GLContext3D.gl = context.__renderSession.gl;
		
		context.__stencilCompareMode = compareMode;
		
		gl.stencilOpSeparate (__getGLTriangleFace (triangleFace), __getGLStencilAction (actionOnDepthPassStencilFail), __getGLStencilAction (actionOnDepthFail), __getGLStencilAction (actionOnBothPass));
		gl.stencilFunc (__getGLCompareMode (context.__stencilCompareMode), context.__stencilRef, context.__stencilReadMask);
		
	}
	
	
	public static function setStencilReferenceValue (context:Context3D, referenceValue:UInt, readMask:UInt = 0xFF, writeMask:UInt = 0xFF):Void {
		
		GLContext3D.context = context;
		GLContext3D.gl = context.__renderSession.gl;
		
		context.__stencilReadMask = readMask;
		context.__stencilRef = referenceValue;
		
		gl.stencilMask (writeMask);
		gl.stencilFunc (__getGLCompareMode (context.__stencilCompareMode), context.__stencilRef, context.__stencilReadMask);
		
	}
	
	
	public static function setTextureAt (context:Context3D, sampler:Int, texture:TextureBase):Void {
		
		if (context.__samplerTextures[sampler] != texture) {
			
			context.__samplerTextures[sampler] = texture;
			context.__samplerDirty |= (1 << sampler);
			
		}
		
	}
	
	
	public static function setVertexBufferAt (context:Context3D, index:Int, buffer:VertexBuffer3D, bufferOffset:Int = 0, format:Context3DVertexBufferFormat = FLOAT_4):Void {
		
		var gl = context.__renderSession.gl;
		
		if (buffer == null) {
			
			gl.disableVertexAttribArray (index);
			GLUtils.CheckGLError ();
			
			gl.bindBuffer (gl.ARRAY_BUFFER, null);
			GLUtils.CheckGLError ();
			
			return;
			
		}
		
		gl.enableVertexAttribArray (index);
		GLUtils.CheckGLError ();
		
		gl.bindBuffer (gl.ARRAY_BUFFER, buffer.__id);
		GLUtils.CheckGLError ();
		
		var byteOffset = bufferOffset * 4;
		
		switch (format) {
			
			case BYTES_4:
				
				gl.vertexAttribPointer (index, 4, gl.UNSIGNED_BYTE, true, buffer.__stride, byteOffset);
				GLUtils.CheckGLError ();
				
			case FLOAT_4:
				
				gl.vertexAttribPointer (index, 4, gl.FLOAT, false, buffer.__stride, byteOffset);
				GLUtils.CheckGLError ();
			
			case FLOAT_3:
				
				gl.vertexAttribPointer (index, 3, gl.FLOAT, false, buffer.__stride, byteOffset);
				GLUtils.CheckGLError ();
			
			case FLOAT_2:
				
				gl.vertexAttribPointer (index, 2, gl.FLOAT, false, buffer.__stride, byteOffset);
				GLUtils.CheckGLError ();
			
			case FLOAT_1:
				
				gl.vertexAttribPointer (index, 1, gl.FLOAT, false, buffer.__stride, byteOffset);
				GLUtils.CheckGLError ();
			
			default:
				
				throw new IllegalOperationError ();
			
		}
		
	}
	
	
	private static function __disableScissorRectangle ():Void {
		
		gl.disable (gl.SCISSOR_TEST);
		GLUtils.CheckGLError ();
		
	}
	
	
	private static function __flushSamplerState ():Void {
		
		var sampler = 0;
		
		while (context.__samplerDirty != 0) {
			
			if ((context.__samplerDirty & (1 << sampler)) != 0) {
				
				if (Context3D.__stateCache.updateActiveTextureSample (sampler)) {
					
					gl.activeTexture (gl.TEXTURE0 + sampler);
					GLUtils.CheckGLError ();
					
				}
				
				var texture = context.__samplerTextures[sampler];
				
				if (texture != null) {
					
					var target = texture.__textureTarget;
					
					gl.bindTexture (target, texture.__getTexture ());
					GLUtils.CheckGLError ();
					
					texture.__setSamplerState (context.__samplerStates[sampler]);
					
				} else {
					
					gl.bindTexture (gl.TEXTURE_2D, null);
					GLUtils.CheckGLError ();
					
				}
				
				context.__samplerDirty &= ~(1 << sampler);
				
			}
			
			sampler++;
			
		}
		
	}
	
	
	private static function __getGLBlendFactor (blendFactor:Context3DBlendFactor):Int {
		
		return switch (blendFactor) {
			
			case DESTINATION_ALPHA: gl.DST_ALPHA;
			case DESTINATION_COLOR: gl.DST_COLOR;
			case ONE: gl.ONE;
			case ONE_MINUS_DESTINATION_ALPHA: gl.ONE_MINUS_DST_ALPHA;
			case ONE_MINUS_DESTINATION_COLOR: gl.ONE_MINUS_DST_COLOR;
			case ONE_MINUS_SOURCE_ALPHA: gl.ONE_MINUS_SRC_ALPHA;
			case ONE_MINUS_SOURCE_COLOR: gl.ONE_MINUS_SRC_COLOR;
			case SOURCE_ALPHA: gl.SRC_ALPHA;
			case SOURCE_COLOR: gl.SRC_COLOR;
			case ZERO: gl.ZERO;
			default:
				throw new IllegalOperationError ();
				
		}
		
	}
	
	
	private static function __getGLCompareMode (compareMode:Context3DCompareMode):Int {
		
		return switch (compareMode) {
			
			case ALWAYS: gl.ALWAYS;
			case EQUAL: gl.EQUAL;
			case GREATER: gl.GREATER;
			case GREATER_EQUAL: gl.GEQUAL;
			case LESS: gl.LESS;
			case LESS_EQUAL: gl.LEQUAL;
			case NEVER: gl.NEVER;
			case NOT_EQUAL: gl.NOTEQUAL;
			default:
				throw new IllegalOperationError ();
				
		}
		
	}
	
	
	private static function __getGLTriangleFace (triangleFace:Context3DTriangleFace, swap:Bool = false):Int {
		
		return switch (triangleFace) {
			
			case FRONT: swap ? gl.BACK : gl.FRONT;
			case BACK: swap ? gl.FRONT : gl.BACK;
			case FRONT_AND_BACK: gl.FRONT_AND_BACK;
			case NONE: gl.NONE;
			default:
				throw new IllegalOperationError ();
				
		}
		
	}
	
	
	private static function __getGLStencilAction (stencilAction:Context3DStencilAction):Int {
		
		return switch (stencilAction) {
			
			case DECREMENT_SATURATE: gl.DECR;
			case DECREMENT_WRAP: gl.DECR_WRAP;
			case INCREMENT_SATURATE: gl.INCR;
			case INCREMENT_WRAP: gl.INCR_WRAP;
			case INVERT: gl.INVERT;
			case KEEP: gl.KEEP;
			case SET: gl.REPLACE;
			case ZERO: gl.ZERO;
			default:
				throw new IllegalOperationError ();
				
		}
		
	}
	
	
	private static function __hasGLExtension (name:String):Bool {
		
		return (gl.getSupportedExtensions ().indexOf (name) != -1);
		
	}
	
	
	private static function __setScissorRectangle (x: Int, y: Int, width: Int, height: Int):Void {
		
		gl.enable (gl.SCISSOR_TEST);
		GLUtils.CheckGLError ();
		
		var renderTargetHeight = 0;
		var offsetX = 0;
		var offsetY = 0;
		
		if (context.__renderToTexture != null) {
			
			renderTargetHeight = context.__renderToTexture.__height;
			
		} else {
			
			renderTargetHeight = context.backBufferHeight;
			offsetX = Std.int (context.__stage3D.x);
			offsetY = Std.int (context.__stage3D.y);
			
		}
		
		gl.scissor (x + offsetX, renderTargetHeight - y - height + offsetY, width, height);
		GLUtils.CheckGLError ();
		
	}
	
	
	private static function __setViewport (originX:Int, originY:Int, width:Int, height:Int):Void {
		
		if (Context3D.__stateCache.updateViewport (originX, originY, width, height)) {
			
			gl.viewport (originX, originY, width, height);
			GLUtils.CheckGLError ();
			
		}
		
	}
	
	
	// public function __statsAdd (stat:Int, value:Int):Int {
		
	// 	__stats[stat] += value;
	// 	return __stats [stat];
		
	// }
	
	
	// public function __statsClear (stat:Int):Void {
		
	// 	__stats[stat] = 0;
		
	// }
	
	
	// public function __statsDecrement (stat:Int):Void {
		
	// 	__stats[stat] -= 1;
		
	// }
	
	
	// public function __statsIncrement (stat:Int):Void {
		
	// 	__stats[stat] += 1;
		
	// }
	
	
	// private function __statsSendToTelemetry ():Void {
		
	// 	#if telemetry
		/*if (!Telemetry.Session.Connected) {
			
			return;
			
		}
		
		if (__statsValues == null) {
			
			__statsValues = new Array<Telemetry.Value> (Context3DTelemetry.length);
			
			// TODO: Should Context3DTelemetry have a toString()?
			
			var name:String;
			
			for (i in 0...Context3DTelemetry.length) {
				
				switch (i) {
					
					case Context3DTelemetry.DRAW_CALLS: name = ".3d.resource.drawCalls";
					default: name = ".3d.resource." + i.toString ().toLowerCase ().replace ('_', '.');
					
				}
				
				__statsValues[i] = new Telemetry.Value (name);
				
			}
			
		}
		
		for (i in 0...Context3DTelemetry.length) {
			
			if (__stats[i] != __statsCache[i]) {
				
				__statsValues[i].WriteValue (__stats[i]);
				__statsCache[i] = __stats[i];
				
			}
			
		}
		
		__valueFrame.WriteValue (__frameCount);*/
	// 	#end
		
	// }
	
	
	// public function __statsSubtract (stat:Int, value:Int):Int {
		
	// 	__stats[stat] -= value;
	// 	return __stats [stat];
		
	// }
	
	
	private static function __updateDepthAndStencilState ():Void {
		
		var depthAndStencil = context.__renderToTexture != null ? context.__rttDepthAndStencil : context.__backBufferEnableDepthAndStencil;
		
		if (depthAndStencil) {
			
			gl.enable (gl.DEPTH_TEST);
			GLUtils.CheckGLError ();
			gl.enable (gl.STENCIL_TEST);
			GLUtils.CheckGLError ();
			
		} else {
			
			gl.disable (gl.DEPTH_TEST);
			GLUtils.CheckGLError ();
			gl.disable (gl.STENCIL_TEST);
			GLUtils.CheckGLError ();
			
		}
		
	}
	
	
	public static function __updateBackbufferViewportTEMP (context:Context3D):Void {
		
		GLContext3D.context = context;
		GLContext3D.gl = context.__renderSession.gl;
		
		__updateBackbufferViewport ();
		
	}
	
	
	private static function __updateBackbufferViewport ():Void {
		
		if (!Stage3D.__active) {
			
			Stage3D.__active = true;
			context.__renderSession.renderer.clear ();
			
		}
		
		if (context.__renderToTexture == null && context.backBufferWidth > 0 && context.backBufferHeight > 0) {
			
			__setViewport (Std.int (context.__stage3D.x), Std.int (context.__stage3D.y), context.backBufferWidth, context.backBufferHeight);
			
		}
		
	}
	
	
}