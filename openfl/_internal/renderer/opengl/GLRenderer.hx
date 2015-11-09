package openfl._internal.renderer.opengl;

import lime.utils.UInt8Array;
import lime.graphics.cairo.Cairo;
import lime.graphics.cairo.CairoSurface;
import lime.graphics.Image;
import lime.graphics.ImageBuffer;
import lime.graphics.ImageChannel;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLFramebuffer;
import lime.graphics.GLRenderContext;
import lime.graphics.PixelFormat;
import lime.math.Vector2;
import lime.utils.ByteArray;
import openfl._internal.renderer.AbstractRenderer;
import openfl._internal.renderer.cairo.CairoGraphics;
import openfl._internal.renderer.cairo.CairoTextField;
import openfl._internal.renderer.opengl.utils.*;
import openfl._internal.renderer.opengl.utils.BlendModeManager.GLBlendMode;
import openfl._internal.renderer.RenderSession;
import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.display.BlendMode;
import openfl.display.DisplayObject;
import openfl.display.Graphics;
import openfl.display.Stage;
import openfl.errors.Error;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.TextField;

#if (js && html5)
import js.html.ImageData;
#end

@:access(lime.graphics.opengl.GL)
@:access(openfl.display.Stage)
@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.display.BitmapData)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)


class GLRenderer extends AbstractRenderer {
	
	
	public static var glContextId:Int = 0;
	public static var glContexts = [];
	
	public var blendModeManager:BlendModeManager;
	public var contextLost:Bool;
	public var defaultFramebuffer:GLFramebuffer;
	public var filterManager:FilterManager;
	public var gl:GLRenderContext;
	public var _glContextId:Int;
	public var maskManager:GLMaskManager;
	public var offset:Point;
	public var options:Dynamic;
	public var preserveDrawingBuffer:Bool;
	public var projection:Point;
	public var shaderManager:ShaderManager;
	public var spriteBatch:SpriteBatch;
	public var stencilManager:StencilManager;
	public var view:Dynamic;
	public var projectionMatrix:Matrix;
	
	private var __stage:Dynamic;
	
	private var vpX:Int = 0;
	private var vpY:Int = 0;
	private var vpWidth:Int = 0;
	private var vpHeight:Int = 0;
	
	private var __screenShotPending:Bool = false;
	private var __screenShotCallback:BitmapData->Void = null;
	private var __screenShotBounds: { x:Int, y:Int, width:Int, height:Int } = null;
	
	
	public function new (width:Int = 800, height:Int = 600, gl:GLRenderContext /*view:Dynamic = null*/, transparent:Bool = false, antialias:Bool = false, preserveDrawingBuffer:Bool = false) {
		
		super (width, height);
		
		this.transparent = transparent;
		this.preserveDrawingBuffer = preserveDrawingBuffer;
		this.width = width;
		this.height = height;
		this.viewport = new Rectangle ();
		
		this.options = {
			alpha: transparent,
			antialias: antialias, 
			premultipliedAlpha: transparent,
			stencil: true,
			preserveDrawingBuffer: preserveDrawingBuffer
		};
		
		_glContextId = glContextId ++;
		this.gl = gl;
		
		#if (ios || tvos)
		defaultFramebuffer = new GLFramebuffer (GL.version, GL.getParameter (GL.FRAMEBUFFER_BINDING));
		#else
		defaultFramebuffer = null;
		#end
		
		glContexts[_glContextId] = gl;
		
		projectionMatrix = new Matrix();
		
		projection = new Point ();
		projection.x =  this.width / 2;
		projection.y =  -this.height / 2;
		
		offset = new Point (0, 0);
		
		resize (this.width, this.height);
		contextLost = false;
		
		shaderManager = new ShaderManager (gl);
		spriteBatch = new SpriteBatch (gl);
		filterManager = new FilterManager (gl, this.transparent);
		stencilManager = new StencilManager (gl);
		blendModeManager = new BlendModeManager (gl);
		
		renderSession = new RenderSession ();
		renderSession.gl = this.gl;
		renderSession.drawCount = 0;
		renderSession.shaderManager = this.shaderManager;
		renderSession.filterManager = this.filterManager;
		renderSession.blendModeManager = this.blendModeManager;
		renderSession.spriteBatch = this.spriteBatch;
		renderSession.stencilManager = this.stencilManager;
		renderSession.renderer = this;
		renderSession.defaultFramebuffer = this.defaultFramebuffer;
		renderSession.projectionMatrix = this.projectionMatrix;
		
		maskManager = new GLMaskManager (renderSession);
		renderSession.maskManager = maskManager;
		
		shaderManager.setShader(shaderManager.defaultShader);
		
		gl.disable (gl.DEPTH_TEST);
		gl.disable (gl.CULL_FACE);
		
		gl.enable (gl.BLEND);
		gl.colorMask (true, true, true, this.transparent);
		
	}
	
	
	public function destroy ():Void {
		
		//this.view.removeEventListener('webglcontextlost', this.handleContextLost);
		//this.view.removeEventListener('webglcontextrestored', this.handleContextRestored);
		
		glContexts[_glContextId] = null;
		
		projection = null;
		offset = null;
		
		shaderManager.destroy ();
		spriteBatch.destroy ();
		maskManager.destroy ();
		filterManager.destroy ();
		
		shaderManager = null;
		spriteBatch = null;
		maskManager = null;
		filterManager = null;
		
		this.gl = null;
		
		renderSession = null;
		
	}
	
	public override function setViewport(x:Int, y:Int, width:Int, height:Int) {
		if (!(vpX == x && vpY == y && vpWidth == width && vpHeight == height)) {
			vpX = x;
			vpY = y;
			vpWidth = width;
			vpHeight = height;
			gl.viewport(x, y, width, height);
			setOrtho(x, y, width, height);
			viewport.setTo(x, y, width, height);
		}
	}
	
	public function setOrtho(x:Float, y:Float, width:Float, height:Float) {
		var o = projectionMatrix;
		o.identity();
		o.a = 1 / width * 2;
		o.d = -1 / height * 2;
		o.tx = -1 - x * o.a;
		o.ty = 1 - y * o.d;
	}
	
	/*private static function destroyTexture (texture:BaseTexture):Void {
		
		var i = texture._glTextures.length - 1;
		
		while (i >= 0) {
			
			var glTexture = texture._glTextures[i];
			var gl = glContexts[i];
			
			if (gl != null && glTexture != null) {
				
				gl.deleteTexture (glTexture);
				
			}
			
			i--;
			
		}
		
		texture._glTextures = [];
		
	}*/
	
	
	private function handleContextLost (event:Dynamic):Void {
		
		event.preventDefault ();
		contextLost = true;
		
	}
	
	
	private function handleContextRestored ():Void {
		
		/*try {
			
			gl = this.view.getContext ('experimental-webgl',  this.options);
			
		} catch (e:Dynamic) {
			
			try {
				
				this.gl = this.view.getContext ('webgl',  this.options);
				
			} catch (e2:Dynamic) {
				
				throw new Error ('This browser does not support webGL. Try using the canvas renderer' + this);
				
			}
			
		}*/
		
		var gl = this.gl;
		glContextId++;
		
		shaderManager.setContext (gl);
		spriteBatch.setContext (gl);
		maskManager.setContext (gl);
		filterManager.setContext (gl);
		
		renderSession.gl = gl;
		
		#if (ios || tvos)
		defaultFramebuffer = new GLFramebuffer (GL.version, GL.getParameter (GL.FRAMEBUFFER_BINDING));
		#else
		defaultFramebuffer = null;
		#end
		
		gl.disable (gl.DEPTH_TEST);
		gl.disable (gl.CULL_FACE);
		
		gl.enable (gl.BLEND);
		gl.colorMask (true, true, true, transparent);
		
		setViewport (0, 0, width, height);
		
		/*for (key in Texture.TextureCache.keys ()) {
			
			var texture = Texture.TextureCache.get (key).baseTexture;
			texture._glTextures = [];
			
		}*/
		
		contextLost = false;
		
	}
	
	
	public override function render (stage:Stage):Void {
		
		if (contextLost) return;
		
		//updateTextures ();
		
		var gl = this.gl;
		setViewport (0, 0, width, height);
		
		gl.bindFramebuffer (gl.FRAMEBUFFER, defaultFramebuffer);
		
		if (this.transparent) {
			
			gl.clearColor (0, 0, 0, 0);
			
		} else {
			
			gl.clearColor (stage.__colorSplit[0], stage.__colorSplit[1], stage.__colorSplit[2], 1);
			
		}
		
		gl.clear (gl.COLOR_BUFFER_BIT);
		renderDisplayObject (stage, projection);
		
		if (__screenShotPending && __screenShotCallback != null) {
			
			__screenShotCallback(__screenShot());
			__screenShotPending = false;
			__screenShotCallback = null;
			__screenShotBounds = null;
			
		}
	}
	
	
	public static function renderBitmap (shape:DisplayObject, renderSession:RenderSession, smooth:Bool = true):Void {
		
		if (!shape.__renderable || shape.__worldAlpha <= 0) return;
		if (shape.__graphics == null || shape.__graphics.__bitmap == null) return;
		
		var rect = openfl.geom.Rectangle.__temp;
		var matrix = openfl.geom.Matrix.__temp;
		
		rect.setEmpty ();
		matrix.identity ();
		
		shape.__getBounds (rect, matrix);
		
		var bitmap = shape.__graphics.__bitmap;
		
		matrix.translate (shape.__graphics.__bounds.x, shape.__graphics.__bounds.y);
		matrix.concat (shape.__renderTransform);
		
		renderSession.spriteBatch.renderBitmapData (bitmap, smooth, matrix, shape.__worldColorTransform, shape.__worldAlpha, shape.__blendMode, null, ALWAYS);
		
	}
	
	
	public function renderDisplayObject (displayObject:DisplayObject, projection:Point, buffer:GLFramebuffer = null):Void {
		
		renderSession.blendModeManager.setBlendMode (BlendMode.NORMAL);
		
		renderSession.drawCount = 0;
		renderSession.currentBlendMode = null;
		
		spriteBatch.begin (renderSession);
		filterManager.begin (renderSession, buffer);
		displayObject.__renderGL (renderSession);
		
		spriteBatch.finish();
		
	}
	
	
	public override function resize (width:Int, height:Int):Void {
		
		this.width = width;
		this.height = height;
		
		super.resize (width, height);
		
		setViewport (0, 0, width, height);
		
		projection.x =  width / 2;
		projection.y =  -height / 2;
		
	}
	
	
	public override function screenShot (callback:BitmapData->Void, x:Int=0, y:Int=0, width:Int=-1, height:Int=-1):Void {
		
		if (width  < 0) width  = this.width;
		if (height < 0) height = this.height;
		if (width  > this.width)  width = this.width;
		if (height > this.height) height = this.height;
		if (x < 0) x = 0;
		if (y < 0) y = 0;
		if (x > width)  x = width;
		if (y > height) y = height;
		__screenShotBounds = { x:x, y:y, width:width, height:height };
		__screenShotCallback = callback;
		__screenShotPending = __screenShotCallback != null;
		
	}
	
	
	private function __screenShot():BitmapData {
		
		var b = new BitmapData(__screenShotBounds.width, __screenShotBounds.height);
		var size = __screenShotBounds.width * __screenShotBounds.height * 4;
		var pixels = new UInt8Array(size);
		GL.pixelStorei(GL.PACK_ALIGNMENT, 1);
		GL.readPixels(__screenShotBounds.x, __screenShotBounds.y, __screenShotBounds.width, __screenShotBounds.height, GL.RGBA, GL.UNSIGNED_BYTE, pixels);
		
		var ww = __screenShotBounds.width;
		var hh = __screenShotBounds.height;
		
		var bytesFlipped = 0;
		var numBytes = Std.int(size / 4);
		
		for (i in 0...numBytes) {
			
			var y = Std.int(i / ww);
			var x = i % ww;
			
			var newy = (hh - 1) - y;
			
			var oldi = i * 4;
			var newi = (newy * ww + x) * 4;
			
			for (j in 0...4) {
				if(j < 3) {
					var oldVal = pixels[oldi + j];
					var newVal = pixels[newi + j];
					
					pixels[oldi + j] = newVal;
					pixels[newi + j] = oldVal;
				}
				else {
					pixels[oldi + j] = 0xFF;
					pixels[newi + j] = 0xFF;
				}
				bytesFlipped += 2;
			}
			
			if (bytesFlipped >= size) {
				break;
			}
		}
		
		var imageBuffer = new ImageBuffer(pixels, __screenShotBounds.width, __screenShotBounds.height);
		imageBuffer.transparent = false;
		var image = new Image(imageBuffer);
		return BitmapData.fromImage(image);
		
	}
	
	/*private static function updateTextureFrame (texture:Texture):Void {
		
		texture._updateWebGLuvs ();
		
	}
	
	
	public static function updateTextures ():Void {
		
		for (frame in Texture.frameUpdates) {
			
			updateTextureFrame (frame);
			
		}
		
		for (texture in Texture.texturesToDestroy) {
			
			destroyTexture (texture);
			
		}
		
		Texture.texturesToUpdate = [];
		Texture.texturesToDestroy = [];
		Texture.frameUpdates = [];
		
	}*/
	
	
}