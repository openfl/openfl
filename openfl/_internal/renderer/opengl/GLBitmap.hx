package openfl._internal.renderer.opengl;


import lime.graphics.GLRenderContext;
import lime.graphics.Image;
import openfl._internal.renderer.opengl.utils.FilterTexture;
import openfl._internal.renderer.RenderSession;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.IBitmapDrawable;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)
@:access(openfl.display.IBitmapDrawable)


class GLBitmap {
	
	private static var fbData:Array<{texture:FilterTexture, viewPort:Rectangle, transparent:Bool}> = [];
	
	public static inline function render (bitmap:Bitmap, renderSession:RenderSession):Void {
		
		if (!bitmap.__renderable || bitmap.__worldAlpha <= 0 || bitmap.bitmapData == null || !bitmap.bitmapData.__isValid) return;
		
		renderSession.spriteBatch.renderBitmapData(bitmap.bitmapData, bitmap.smoothing, bitmap.__worldTransform, bitmap.__worldColorTransform, bitmap.__worldAlpha, bitmap.__blendMode, bitmap.__shader, bitmap.pixelSnapping);
	}
	
	/**
	 * Push a texture to render. Binds the framebuffer of that texture.
	 * @param	renderSession
	 * @param	texture
	 * @param	viewPort
	 * @param	smoothing
	 * @param	transparent
	 * @param	clearBuffer
	 */
	public static function pushFramebuffer (renderSession:RenderSession, texture:FilterTexture, viewPort:Rectangle, smoothing:Bool, ?transparent:Bool = true, ?clearBuffer:Bool = false) {
		var gl:GLRenderContext = renderSession.gl;
		if (gl == null) return null;
		
		var renderer = renderSession.renderer;
		var spritebatch = renderSession.spriteBatch;
		var x:Int = Std.int(viewPort.x);
		var y:Int = Std.int(viewPort.y);
		var width:Int = Std.int(viewPort.width);
		var height:Int = Std.int(viewPort.height);
		
		trace("PUSH FRAMEBUFFER " + viewPort);
		spritebatch.finish();
		
		// push the default framebuffer
		if (fbData.length <= 0) {
			trace("\t pushing defaultFramebuffer");
			fbData.push( { texture: null, viewPort: null, transparent: renderer.transparent } );
		}
		
		if (texture == null) {
			texture = new FilterTexture(gl, width, height, smoothing);
			trace("\t Creating framebuffer " + texture.frameBuffer.id);
		}
		
		trace("\t Pushing framebuffer " + texture.frameBuffer.id);
		
		texture.resize(width, height);
		renderer.transparent = transparent;
		
		gl.bindFramebuffer (gl.FRAMEBUFFER, texture.frameBuffer);
		renderer.setViewport (x, y, width, height);
		
		// enable writing to all the colors and alpha
		gl.colorMask (true, true, true, true);
		renderSession.blendModeManager.setBlendMode (BlendMode.NORMAL);
		
		if (clearBuffer) {
			trace("\t Clearing framebuffer " + texture.frameBuffer.id);
			texture.clear();
		}
		
		fbData.push( { texture:texture, viewPort:viewPort, transparent: transparent } );
		
		return texture;
	}
	
	/**
	 * Render an object to the binded framebuffer
	 * @param	renderSession
	 * @param	self
	 * @param	source
	 * @param	matrix
	 * @param	colorTransform
	 * @param	blendMode
	 * @param	clipRect
	 */
	public static function drawBitmapDrawable (renderSession:RenderSession, target:BitmapData, source:IBitmapDrawable, ?matrix:Matrix, ?colorTransform:ColorTransform, ?blendMode:BlendMode, ?clipRect:Rectangle) {
		var data = fbData[fbData.length - 1];
		if (data == null) throw "No data to draw to";
		
		var gl:GLRenderContext = renderSession.gl;
		if (gl == null) return;
		
		trace("\t DRAW FB " + data.texture.frameBuffer.id);
		
		var viewPort = data.viewPort;
		var renderer = renderSession.renderer;
		var spritebatch = renderSession.spriteBatch;
		var drawTarget = target != null;
		
		var tmpRect = clipRect == null ? new Rectangle (viewPort.x, viewPort.y, viewPort.width, viewPort.height) : clipRect.clone ();
		
		spritebatch.begin (renderSession, drawTarget ? null : tmpRect);
		
		if (drawTarget) {
			
			target.__worldTransform.identity ();
			GLBitmap.flipMatrix (target.__worldTransform, viewPort.height);
			trace("\t\t Drawing target " + target.__worldTransform);
			target.__renderGL (renderSession);
			spritebatch.stop ();
			if(target.__texture != null) gl.deleteTexture (target.__texture);
			spritebatch.start (tmpRect);
			
		}
		
		var ctCache = source.__worldColorTransform;
		var matrixCache = source.__worldTransform;
		var blendModeCache = source.__blendMode;
		var cached = source.__cacheAsBitmap;
		
		var m = matrix != null ? matrix.clone () : new Matrix ();
		
		GLBitmap.flipMatrix (m, viewPort.height);
		
		trace("\t\t Drawing source " + m, matrixCache);
		
		source.__worldTransform = m;
		source.__worldColorTransform = colorTransform != null ? colorTransform : new ColorTransform ();
		source.__blendMode = blendMode;
		source.__cacheAsBitmap = false;
		
		source.__updateChildren (false);
		
		source.__renderGL (renderSession);
		
		source.__worldColorTransform = ctCache;
		source.__worldTransform = matrixCache;
		source.__blendMode = blendModeCache;
		source.__cacheAsBitmap = cached;
		
		source.__updateChildren (false);
	}
	
	/**
	 * Pop the framebuffer and binds the last framebuffer
	 * @param	renderSession
	 * @param	transparent
	 * @param	image
	 */
	public static function popFramebuffer (renderSession:RenderSession, ?image:Image) {
		var gl:GLRenderContext = renderSession.gl;
		if (gl == null) return;
		
		renderSession.spriteBatch.finish();
		
		// remove the actual binded framebuffer from the array
		fbData.pop();
		var data = fbData[fbData.length - 1];
		if (data == null) {
			throw "oh";
		}
		
		var x:Int, y:Int, width:Int, height:Int;
		
		if (data.viewPort == null) {
			x = y = 0;
			width = renderSession.renderer.width;
			height = renderSession.renderer.height;
		} else {
			x = Math.floor(data.viewPort.x);
			y = Math.floor(data.viewPort.y);
			width = Math.ceil(data.viewPort.width);
			height = Math.ceil(data.viewPort.height);			
		}
		
		trace("POP FRAMEBUFFER " + (data.texture != null ? data.texture.frameBuffer.id : "DEFAULT"));
		
		if (image != null) {
			
			// TODO is this possible?
			if (image.width != width || image.height != height) {
				
				image.resize (width, height);
				
			}
			
			gl.readPixels (x, y, width, height, gl.RGBA, gl.UNSIGNED_BYTE, image.buffer.data);
			
			image.dirty = false;
			image.premultiplied = true;
			
		}
		
		gl.bindFramebuffer (gl.FRAMEBUFFER, data.texture == null ? renderSession.defaultFramebuffer : renderSession.defaultFramebuffer);
		renderSession.renderer.setViewport (x, y, width, height);
		renderSession.renderer.transparent = data.transparent;
	}
	
	private static inline function flipMatrix (m:Matrix, height:Float):Void {
		
		var tx = m.tx;
		var ty = m.ty;
		m.tx = 0;
		m.ty = 0;
		m.scale (1, -1);
		m.translate (0, height);
		m.tx += tx;
		m.ty -= ty;
		
	}
	
}