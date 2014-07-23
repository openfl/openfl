package openfl._internal.renderer.opengl;


import lime.graphics.GL;
import lime.graphics.GLFramebuffer;
import lime.graphics.GLRenderContext;
import openfl._internal.renderer.opengl.utils.*;
import openfl._internal.renderer.opengl.utils.MaskManager;
import openfl.display.DisplayObject;
import openfl.display.Stage;
import openfl.errors.Error;
import openfl.geom.Point;


@:access(lime.graphics.GL)
@:access(openfl.display.Stage)


class GLRenderer {
	
	
	public static var blendModesWebGL = null;
	public static var glContextId:Int = 0;
	public static var glContexts = [];
	
	public var blendModeManager:BlendModeManager;
	public var contextLost:Bool;
	public var filterManager:FilterManager;
	public var gl:GLRenderContext;
	public var _glContextId:Int;
	public var height:Int;
	public var maskManager:openfl._internal.renderer.opengl.utils.MaskManager;
	public var offset:Point;
	public var options:Dynamic;
	public var preserveDrawingBuffer:Bool;
	public var projection:Point;
	public var renderSession:Dynamic;
	public var shaderManager:ShaderManager;
	public var spriteBatch:SpriteBatch;
	public var stencilManager:StencilManager;
	public var transparent:Bool;
	public var view:Dynamic;
	public var width:Int;
	
	private var __stage:Dynamic;
	
	
	public function new (width:Int = 800, height:Int = 600, gl:GLRenderContext /*view:Dynamic = null*/, transparent:Bool = false, antialias:Bool = false, preserveDrawingBuffer:Bool = false) {
		
		this.transparent = transparent;
		this.preserveDrawingBuffer = preserveDrawingBuffer;
		this.width = width;
		this.height = height;
		
		this.options = {
			alpha: transparent,
			antialias: antialias, 
			premultipliedAlpha: transparent,
			stencil: true,
			preserveDrawingBuffer: preserveDrawingBuffer
		};
		
		_glContextId = glContextId ++;
		this.gl = gl;
		
		glContexts[_glContextId] = gl;
		
		if (blendModesWebGL == null) {
			
			blendModesWebGL = [];
			blendModesWebGL[cast BlendMode.NORMAL] = [ gl.ONE, gl.ONE_MINUS_SRC_ALPHA ];
			blendModesWebGL[cast BlendMode.ADD] = [ gl.SRC_ALPHA, gl.DST_ALPHA ];
			blendModesWebGL[cast BlendMode.MULTIPLY] = [ gl.DST_COLOR, gl.ONE_MINUS_SRC_ALPHA ];
			blendModesWebGL[cast BlendMode.SCREEN] = [ gl.SRC_ALPHA, gl.ONE ];
			blendModesWebGL[cast BlendMode.OVERLAY] = [ gl.ONE, gl.ONE_MINUS_SRC_ALPHA ];
			blendModesWebGL[cast BlendMode.DARKEN] = [ gl.ONE, gl.ONE_MINUS_SRC_ALPHA ];
			blendModesWebGL[cast BlendMode.LIGHTEN] = [ gl.ONE, gl.ONE_MINUS_SRC_ALPHA ];
			blendModesWebGL[cast BlendMode.COLOR_DODGE] = [ gl.ONE, gl.ONE_MINUS_SRC_ALPHA ];
			blendModesWebGL[cast BlendMode.COLOR_BURN] = [ gl.ONE, gl.ONE_MINUS_SRC_ALPHA ];
			blendModesWebGL[cast BlendMode.HARD_LIGHT] = [ gl.ONE, gl.ONE_MINUS_SRC_ALPHA ];
			blendModesWebGL[cast BlendMode.SOFT_LIGHT] = [ gl.ONE, gl.ONE_MINUS_SRC_ALPHA ];
			blendModesWebGL[cast BlendMode.DIFFERENCE] = [ gl.ONE, gl.ONE_MINUS_SRC_ALPHA ];
			blendModesWebGL[cast BlendMode.EXCLUSION] = [ gl.ONE, gl.ONE_MINUS_SRC_ALPHA ];
			blendModesWebGL[cast BlendMode.HUE] = [ gl.ONE, gl.ONE_MINUS_SRC_ALPHA ];
			blendModesWebGL[cast BlendMode.SATURATION] = [ gl.ONE, gl.ONE_MINUS_SRC_ALPHA ];
			blendModesWebGL[cast BlendMode.COLOR] = [ gl.ONE, gl.ONE_MINUS_SRC_ALPHA ];
			blendModesWebGL[cast BlendMode.LUMINOSITY] = [ gl.ONE, gl.ONE_MINUS_SRC_ALPHA ];
			
		}
		
		projection = new Point ();
		projection.x =  this.width / 2;
		projection.y =  -this.height / 2;
		
		offset = new Point (0, 0);
		
		resize (this.width, this.height);
		contextLost = false;
		
		shaderManager = new ShaderManager (gl);
		spriteBatch = new SpriteBatch (gl);
		maskManager = new openfl._internal.renderer.opengl.utils.MaskManager (gl);
		filterManager = new FilterManager (gl, this.transparent);
		stencilManager = new StencilManager (gl);
		blendModeManager = new BlendModeManager (gl);
		
		renderSession = {};
		renderSession.gl = this.gl;
		renderSession.drawCount = 0;
		renderSession.shaderManager = this.shaderManager;
		renderSession.maskManager = this.maskManager;
		renderSession.filterManager = this.filterManager;
		renderSession.blendModeManager = this.blendModeManager;
		renderSession.spriteBatch = this.spriteBatch;
		renderSession.stencilManager = this.stencilManager;
		renderSession.renderer = this;
		
		gl.useProgram (shaderManager.defaultShader.program);
		
		gl.disable (gl.DEPTH_TEST);
		gl.disable (gl.CULL_FACE);
		
		gl.enable (gl.BLEND);
		gl.colorMask (true, true, true, transparent);
		
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
		
		gl.disable (gl.DEPTH_TEST);
		gl.disable (gl.CULL_FACE);
		
		gl.enable (gl.BLEND);
		gl.colorMask (true, true, true, transparent);
		
		gl.viewport (0, 0, width, height);
		
		/*for (key in Texture.TextureCache.keys ()) {
			
			var texture = Texture.TextureCache.get (key).baseTexture;
			texture._glTextures = [];
			
		}*/
		
		contextLost = false;
		
	}
	
	
	public function render (stage:Stage):Void {
		
		if (contextLost) return;
		
		//updateTextures ();
		
		var gl = this.gl;
		gl.viewport (0, 0, width, height);
		gl.bindFramebuffer (gl.FRAMEBUFFER, null);
		
		if (this.transparent) {
			
			gl.clearColor (0, 0, 0, 0);
			
		} else {
			
			gl.clearColor (Std.int (stage.__colorSplit[0]), Std.int (stage.__colorSplit[1]), Std.int (stage.__colorSplit[2]), 1);
			
		}
		
		gl.clear (gl.COLOR_BUFFER_BIT);
		renderDisplayObject (stage, projection);
		
	}
	
	
	public function renderDisplayObject (displayObject:DisplayObject, projection:Point, buffer:GLFramebuffer = null):Void {
		
		renderSession.blendModeManager.setBlendMode (BlendMode.NORMAL);
		
		renderSession.drawCount = 0;
		renderSession.currentBlendMode = 9999;
		
		renderSession.projection = projection;
		renderSession.offset = offset;
		
		spriteBatch.begin (renderSession);
		filterManager.begin (renderSession, buffer);
		displayObject.__renderGL (renderSession);
		
		spriteBatch.end ();
		
	}
	
	
	public function resize (width:Int, height:Int):Void {
		
		this.width = width;
		this.height = height;
		
		gl.viewport (0, 0, width, height);
		
		projection.x =  width / 2;
		projection.y =  -height / 2;
		
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


@:enum abstract BlendMode(Int) {
	
	var NORMAL = 0;
	var ADD = 1;
	var MULTIPLY = 2;
	var SCREEN = 3;
	var OVERLAY = 4;
	var DARKEN = 5;
	var LIGHTEN = 6;
	var COLOR_DODGE = 7;
	var COLOR_BURN = 8;
	var HARD_LIGHT = 9;
	var SOFT_LIGHT = 10;
	var DIFFERENCE = 11;
	var EXCLUSION = 12;
	var HUE = 13;
	var SATURATION = 14;
	var COLOR = 15;
	var LUMINOSITY = 16;
	
}