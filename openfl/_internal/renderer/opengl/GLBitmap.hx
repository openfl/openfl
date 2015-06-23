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
	static var fbI = 0;
	public static function pushFramebuffer (renderSession:RenderSession, texture:FilterTexture, viewPort:Rectangle, smoothing:Bool, ?transparent:Bool = true, ?clearBuffer:Bool = false) {
		var gl:GLRenderContext = renderSession.gl;
		if (gl == null) return null;
		
		var renderer = renderSession.renderer;
		var spritebatch = renderSession.spriteBatch;
		var x:Int = Std.int(viewPort.x);
		var y:Int = Std.int(viewPort.y);
		var width:Int = Std.int(viewPort.width);
		var height:Int = Std.int(viewPort.height);
		
		//trace("PUSH FRAMEBUFFER " + viewPort);
		spritebatch.finish();
		
		// push the default framebuffer
		if (fbData.length <= 0) {
			//trace("\t pushing defaultFramebuffer " + ++fbI);
			fbData.push( { texture: null, viewPort: new Rectangle(0, 0, renderer.width, renderer.height), transparent: renderer.transparent } );
		}
		//trace("\t Pushing framebuffer " + ++fbI);
		
		if (texture == null) {
			//trace("\t Creating framebuffer");
			texture = new FilterTexture(gl, width, height, smoothing);
		}
		
		texture.resize(width, height);
		renderer.transparent = transparent;
		
		gl.bindFramebuffer (gl.FRAMEBUFFER, texture.frameBuffer);
		renderer.setViewport (x, y, width, height);
		
		// enable writing to all the colors and alpha
		gl.colorMask (true, true, true, true);
		renderSession.blendModeManager.setBlendMode (BlendMode.NORMAL);
		
		if (clearBuffer) {
			//trace("\t Clearing framebuffer");
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
	public static function drawInFramebuffer (renderSession:RenderSession, self:BitmapData, source:IBitmapDrawable, ?matrix:Matrix, ?colorTransform:ColorTransform, ?blendMode:BlendMode, ?clipRect:Rectangle) {
		var data = fbData[fbData.length - 1];
		if (data == null) throw "No data to draw to";
		
		var gl:GLRenderContext = renderSession.gl;
		if (gl == null) return;
		
		//trace("\t DRAW FB " + fbI);
		
		var viewPort = data.viewPort;
		var renderer = renderSession.renderer;
		var spritebatch = renderSession.spriteBatch;
		var drawSelf = self != null;
		
		var tmpRect = clipRect == null ? new Rectangle (viewPort.x, viewPort.y, viewPort.width, viewPort.height) : clipRect.clone ();
		
		spritebatch.begin (renderSession, drawSelf ? null : tmpRect);
		
		if (drawSelf) {
			
			//trace("\t\t Drawing self");
			self.__worldTransform.identity ();
			GLBitmap.flipMatrix (self.__worldTransform, viewPort.height);
			self.__renderGL (renderSession);
			spritebatch.stop ();
			gl.deleteTexture (self.__texture);
			spritebatch.start (tmpRect);
			
		}
		
		var ctCache = source.__worldColorTransform;
		var matrixCache = source.__worldTransform;
		var blendModeCache = source.__blendMode;
		var cached = source.__cacheAsBitmap;
		
		var m = matrix != null ? matrix.clone () : new Matrix ();
		
		GLBitmap.flipMatrix (m, viewPort.height);
		
		//trace("\t\t Drawing source " + m);
		
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
		
		var x:Int = Std.int(data.viewPort.x);
		var y:Int = Std.int(data.viewPort.y);
		var width:Int = Std.int(data.viewPort.width);
		var height:Int = Std.int(data.viewPort.height);
		
		//trace("POP FRAMEBUFFER " + --fbI + "  " + (data.texture != null));
		
		if (image != null) {
			
			// TODO is this possible?
			if (image.width != width || image.height != height) {
				
				image.resize (width, height);
				
			}
			
			gl.readPixels (x, y, width, height, gl.RGBA, gl.UNSIGNED_BYTE, image.buffer.data);
			
			image.dirty = false;
			image.premultiplied = true;
			
		}
		
		gl.bindFramebuffer (gl.FRAMEBUFFER, data.texture == null ? renderSession.defaultFramebuffer : data.texture.frameBuffer);
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