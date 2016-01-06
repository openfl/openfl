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
import openfl.utils.ByteArray;

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
	
	
	public override function capture (stage:Stage, region:lime.math.Rectangle):Image {
		
		if (region == null) region = new lime.math.Rectangle();
		if (region.x < 0) region.x = 0;
		if (region.y < 0) region.y = 0;
		if (region.width  <= 0) region.width  = stage.stageWidth;
		if (region.height <= 0) region.height = stage.stageHeight;
		if (region.right  > stage.width)  region.right  = stage.stageWidth;
		if (region.bottom > stage.height) region.bottom = stage.stageHeight;
		
		var image = __captureImage(Std.int(region.x), Std.int(region.y), Std.int(region.width), Std.int(region.height));
		
		return image;
		
	}
	
	
	private function __captureImage(x:Int, y:Int, width:Int, height:Int ):Image {
		
		var size = width * height * 4;
		var pixels = new UInt8Array(size);
		
		GL.readBuffer(GL.FRONT);
		
		GL.pixelStorei(GL.PACK_ALIGNMENT, 1);
		GL.readPixels(x, y, width, height, GL.RGBA, GL.UNSIGNED_BYTE, pixels);
		
		GL.readBuffer(GL.BACK);
		
		var bytesFlipped = 0;
		var numBytes = Std.int(size / 4);
		
		for (i in 0...numBytes) {
			
			var y = Std.int(i / width);
			var x = i % width;
			
			var newy = (height - 1) - y;
			
			var oldi = i * 4;
			var newi = (newy * width + x) * 4;
			
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
		
		var imageBuffer = new ImageBuffer(pixels, width, height);
		imageBuffer.transparent = false;
		return new Image(imageBuffer);
		
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