package openfl._internal.renderer.opengl;


import lime.graphics.GLRenderContext;
import lime.math.Matrix4;
import openfl._internal.renderer.AbstractRenderer;
import openfl.display.OpenGLView;
import openfl.display.Stage;
import openfl.geom.Matrix;

@:access(openfl.display.Stage)
@:access(openfl.geom.Matrix)


class GLRenderer extends AbstractRenderer {
	
	
	public var projection:Matrix4;
	
	private var displayHeight:Int;
	private var displayMatrix:Matrix;
	private var displayWidth:Int;
	private var gl:GLRenderContext;
	private var matrix:Matrix4;
	private var offsetX:Int;
	private var offsetY:Int;
	
	
	public function new (stage:Stage, gl:GLRenderContext) {
		
		super (stage);
		
		this.gl = gl;
		matrix = new Matrix4 ();
		
		renderSession = new RenderSession ();
		renderSession.gl = gl;
		renderSession.roundPixels = true;
		renderSession.renderer = this;
		renderSession.blendModeManager = new GLBlendModeManager (gl);
		renderSession.shaderManager = new GLShaderManager (gl);
		renderSession.maskManager = new GLMaskManager (renderSession);
		
		if (stage.window != null) {
			
			resize (stage.window.width, stage.window.height);
			
		}
		
	}
	
	
	public override function clear ():Void {
		
		if (stage.__transparent) {
			
			gl.clearColor (0, 0, 0, 0);
			
		} else {
			
			gl.clearColor (stage.__colorSplit[0], stage.__colorSplit[1], stage.__colorSplit[2], 1);
			
		}
		
		gl.clear (gl.COLOR_BUFFER_BIT);
		
		for (stage3D in stage.stage3Ds) {
			
			if (stage3D.context3D != null) {
				
				renderSession.shaderManager.setShader (null);
				renderSession.blendModeManager.setBlendMode (null);
				break;
				
			}
			
		}
		
	}
	
	
	public function getMatrix (transform:Matrix):Matrix4 {
		
		var _matrix = Matrix.__temp;
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
		matrix.append (projection);
		
		return matrix;
		
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
	
	
	public override function resize (width:Int, height:Int):Void {
		
		super.resize (width, height);
		
		displayMatrix = stage.__displayMatrix;
		
		offsetX = Math.round (displayMatrix.__transformX (0, 0));
		offsetY = Math.round (displayMatrix.__transformY (0, 0));
		displayWidth = Math.round (displayMatrix.__transformX (stage.stageWidth, 0) - offsetX);
		displayHeight = Math.round (displayMatrix.__transformY (0, stage.stageHeight) - offsetY);
		
		projection = Matrix4.createOrtho (offsetX, displayWidth + offsetX, displayHeight + offsetY, offsetY, -1000, 1000);
		
	}
	
	
}