package openfl._internal.renderer.opengl;


import lime.graphics.GLRenderContext;
import lime.graphics.opengl.GLFramebuffer;
import lime.math.Matrix4;
import openfl._internal.renderer.AbstractRenderer;
import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.display.Stage;
import openfl.geom.Matrix;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.BitmapData)
@:access(openfl.display.Graphics)
@:access(openfl.display.Stage)
@:access(openfl.display.Stage3D)
@:access(openfl.display3D.Context3D)
@:access(openfl.display3D.Program3D)
@:access(openfl.geom.Matrix)


class GLRenderer extends AbstractRenderer {
	
	
	public var projection:Matrix4;
	public var projectionFlipped:Matrix4;
	
	public var defaultRenderTarget:BitmapData;
	
	// private var cacheObject:BitmapData;
	private var currentRenderTarget:BitmapData;
	private var displayHeight:Int;
	private var displayMatrix:Matrix;
	private var displayWidth:Int;
	private var flipped:Bool;
	private var gl:GLRenderContext;
	private var matrix:Matrix4;
	private var renderTargetA:BitmapData;
	private var renderTargetB:BitmapData;
	private var offsetX:Int;
	private var offsetY:Int;
	private var values:Array<Float>;
	
	
	public function new (stage:Stage, gl:GLRenderContext, ?defaultRenderTarget:BitmapData) {
		
		super (stage);
		
		this.gl = gl;
		this.defaultRenderTarget = defaultRenderTarget;
		this.flipped = (defaultRenderTarget == null);
		
		if (Graphics.maxTextureWidth == null) {
			
			Graphics.maxTextureWidth = Graphics.maxTextureHeight = gl.getInteger (gl.MAX_TEXTURE_SIZE);
			
		}
		
		matrix = new Matrix4 ();
		values = new Array ();
		
		renderSession = new RenderSession ();
		renderSession.clearRenderDirty = true;
		renderSession.gl = gl;
		//renderSession.roundPixels = true;
		renderSession.renderer = this;
		renderSession.renderType = OPENGL;
		renderSession.blendModeManager = new GLBlendModeManager (gl);
		renderSession.filterManager = new GLFilterManager (this, renderSession);
		renderSession.shaderManager = new GLShaderManager (gl);
		renderSession.maskManager = new GLMaskManager (renderSession);
		
		if (stage.window != null) {
			
			if (stage.stage3Ds[0].context3D == null) {
				
				stage.stage3Ds[0].__createContext (stage, renderSession);
				
			}
			
			var width:Int = (defaultRenderTarget != null) ? defaultRenderTarget.width : Math.ceil (stage.window.width * stage.window.scale);
			var height:Int = (defaultRenderTarget != null) ? defaultRenderTarget.height : Math.ceil (stage.window.height * stage.window.scale);
			
			resize (width, height);
			
		}
		
	}
	
	
	public override function clear ():Void {
		
		if (stage.__transparent) {
			
			gl.clearColor (0, 0, 0, 0);
			
		} else {
			
			gl.clearColor (stage.__colorSplit[0], stage.__colorSplit[1], stage.__colorSplit[2], 1);
			
		}
		
		gl.clear (gl.COLOR_BUFFER_BIT);
		
	}
	
	
	public function getCacheObject ():Void {
		
		// gl.bindFramebuffer (gl.FRAMEBUFFER, cacheObject.__getFramebuffer (gl));
		// gl.viewport (0, 0, width, height);
		// gl.clearColor (0, 0, 0, 0);
		// gl.clear (gl.COLOR_BUFFER_BIT);
		
		// flipped = false;
		
	}
	
	
	public function getMatrix (transform:Matrix):Array<Float> {
		
		var _matrix = Matrix.__pool.get ();
		_matrix.copyFrom (transform);
		_matrix.concat (displayMatrix);
		
		if (renderSession.roundPixels) {
			
			_matrix.tx = Math.round (_matrix.tx);
			_matrix.ty = Math.round (_matrix.ty);
			
		}
		
		matrix.identity ();
		matrix[0] = _matrix.a;
		matrix[1] = _matrix.b;
		matrix[4] = _matrix.c;
		matrix[5] = _matrix.d;
		matrix[12] = _matrix.tx;
		matrix[13] = _matrix.ty;
		matrix.append (flipped ? projectionFlipped : projection);
		
		for (i in 0...16) {
			
			values[i] = matrix[i];
			
		}
		
		Matrix.__pool.release (_matrix);
		
		return values;
		
	}
	
	
	public function getRenderTarget (framebuffer:Bool):Void {
		
		if (framebuffer) {
			
			if (renderTargetA == null) {
				
				renderTargetA = BitmapData.fromTexture (stage.stage3Ds[0].context3D.createRectangleTexture (width, height, BGRA, true));
				
				gl.bindTexture (gl.TEXTURE_2D, renderTargetA.getTexture (gl));
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
				
			}
			
			if (renderTargetB == null) {
				
				renderTargetB = BitmapData.fromTexture (stage.stage3Ds[0].context3D.createRectangleTexture (width, height, BGRA, true));
				
				gl.bindTexture (gl.TEXTURE_2D, renderTargetB.getTexture (gl));
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
				
			}
			
			if (currentRenderTarget == renderTargetA) {
				
				currentRenderTarget = renderTargetB;
				
			} else {
				
				currentRenderTarget = renderTargetA;
				
			}
			
			gl.bindFramebuffer (gl.FRAMEBUFFER, currentRenderTarget.__getFramebuffer (gl));
			gl.viewport (0, 0, width, height);
			gl.clearColor (0, 0, 0, 0);
			gl.clear (gl.COLOR_BUFFER_BIT);
			
			flipped = false;
			
		} else {
			
			currentRenderTarget = defaultRenderTarget;
			var frameBuffer:GLFramebuffer = (currentRenderTarget != null) ? currentRenderTarget.__getFramebuffer (gl) : null;
			
			gl.bindFramebuffer (gl.FRAMEBUFFER, frameBuffer);
			
			flipped = (currentRenderTarget == null);
		}
		
	}
	
	
	public override function render ():Void {
		
		gl.viewport (offsetX, offsetY, displayWidth, displayHeight);
		
		renderSession.allowSmoothing = (stage.quality != LOW);
		renderSession.upscaled = (displayMatrix.a != 1 || displayMatrix.d != 1);
		
		stage.__renderGL (renderSession);
		
		if (offsetX > 0 || offsetY > 0) {
			
			gl.clearColor (0, 0, 0, 1);
			gl.enable (gl.SCISSOR_TEST);
			
			if (offsetX > 0) {
				
				gl.scissor (0, 0, offsetX, height);
				gl.clear (gl.COLOR_BUFFER_BIT);
				
				gl.scissor (offsetX + displayWidth, 0, width, height);
				gl.clear (gl.COLOR_BUFFER_BIT);
				
			}
			
			if (offsetY > 0) {
				
				gl.scissor (0, 0, width, offsetY);
				gl.clear (gl.COLOR_BUFFER_BIT);
				
				gl.scissor (0, offsetY + displayHeight, width, height);
				gl.clear (gl.COLOR_BUFFER_BIT);
				
			}
			
			gl.disable (gl.SCISSOR_TEST);
			
		}
		
	}
	
	
	public override function renderStage3D ():Void {
		
		for (stage3D in stage.stage3Ds) {
			
			stage3D.__renderGL (stage, renderSession);
			
		}
		
	}
	
	
	public override function resize (width:Int, height:Int):Void {
		
		super.resize (width, height);
		
		// if (cacheObject == null || cacheObject.width != width || cacheObject.height != height) {
			
		// 	cacheObject = BitmapData.fromTexture (stage.stage3Ds[0].context3D.createRectangleTexture (width, height, BGRA, true));
			
		// 	gl.bindTexture (gl.TEXTURE_2D, cacheObject.getTexture (gl));
		// 	gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
		// 	gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
			
		// }
		
		if (width > 0 && height > 0) {
			
			if (renderTargetA != null && (renderTargetA.width != width || renderTargetA.height != height)) {
				
				renderTargetA = BitmapData.fromTexture (stage.stage3Ds[0].context3D.createRectangleTexture (width, height, BGRA, true));
				
				gl.bindTexture (gl.TEXTURE_2D, renderTargetA.getTexture (gl));
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
				
			}
			
			if (renderTargetB != null && (renderTargetB.width != width || renderTargetB.height != height)) {
				
				renderTargetB = BitmapData.fromTexture (stage.stage3Ds[0].context3D.createRectangleTexture (width, height, BGRA, true));
				
				gl.bindTexture (gl.TEXTURE_2D, renderTargetB.getTexture (gl));
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
				
			}
			
		}
		
		displayMatrix = (defaultRenderTarget == null) ? stage.__displayMatrix : new Matrix ();
		
		var w = (defaultRenderTarget == null) ? stage.stageWidth : defaultRenderTarget.width;
		var h = (defaultRenderTarget == null) ? stage.stageHeight : defaultRenderTarget.height;
		
		offsetX = Math.round (displayMatrix.__transformX (0, 0));
		offsetY = Math.round (displayMatrix.__transformY (0, 0));
		displayWidth = Math.round (displayMatrix.__transformX (w, 0) - offsetX);
		displayHeight = Math.round (displayMatrix.__transformY (0, h) - offsetY);
		
		projection = Matrix4.createOrtho (offsetX, displayWidth + offsetX, offsetY, displayHeight + offsetY, -1000, 1000);
		projectionFlipped = Matrix4.createOrtho (offsetX, displayWidth + offsetX, displayHeight + offsetY, offsetY, -1000, 1000);
		
	}
	
	
}