package openfl._internal.renderer.opengl;


import lime.graphics.GLRenderContext;
import lime.math.Matrix4;
import openfl._internal.renderer.AbstractRenderer;
import openfl.display.OpenGLView;
import openfl.display.Stage;
import openfl.geom.Matrix;

@:access(openfl.display.Stage)


class GLRenderer extends AbstractRenderer {
	
	
	public var projection:Matrix4;
	
	private var gl:GLRenderContext;
	private var matrix:Matrix4;
	private var windowHeight:Int;
	private var windowWidth:Int;
	
	
	public function new (width:Int, height:Int, gl:GLRenderContext) {
		
		super (width, height);
		
		this.gl = gl;
		matrix = new Matrix4 ();
		
		renderSession = new RenderSession ();
		renderSession.gl = gl;
		renderSession.roundPixels = true;
		renderSession.renderer = this;
		renderSession.blendModeManager = new GLBlendModeManager (gl);
		renderSession.shaderManager = new GLShaderManager (gl);
		renderSession.maskManager = new GLMaskManager (renderSession);
		
		projection = Matrix4.createOrtho (0, width, height, 0, -1000, 1000);
		
	}
	
	
	public function getMatrix (transform:Matrix):Matrix4 {
		
		matrix.identity ();
		matrix[0] = transform.a;
		matrix[1] = transform.b;
		matrix[4] = transform.c;
		matrix[5] = transform.d;
		matrix[12] = transform.tx;
		matrix[13] = transform.ty;
		matrix.append (projection);
		
		return matrix;
		
	}
	
	
	public override function init (stage:Stage):Void {
		
		if (stage.__transparent) {
			
			gl.clearColor (0, 0, 0, 0);
			
		} else {
			
			gl.clearColor (stage.__colorSplit[0], stage.__colorSplit[1], stage.__colorSplit[2], 1);
			
		}
		
		gl.clear (gl.COLOR_BUFFER_BIT);
		
		if (stage.stage3Ds[0].context3D != null) {
			
			renderSession.shaderManager.setShader (null);
			renderSession.blendModeManager.setBlendMode (null);
			
		}
		
	}
	
	
	public override function render (stage:Stage):Void {
		
		var displayMatrix = stage.__displayMatrix;
		var offsetX = Math.round (displayMatrix.__transformX (0, 0));
		var offsetY = Math.round (displayMatrix.__transformY (0, 0));
		var displayWidth = Math.round (displayMatrix.__transformX (width, 0) - offsetX);
		var displayHeight = Math.round (displayMatrix.__transformY (0, height) - offsetY);
		
		gl.viewport (offsetX, offsetY, displayWidth, displayHeight);
		
		windowWidth = stage.window.width;
		windowHeight = stage.window.height;
		
		stage.__renderGL (renderSession);
		
		if (offsetX > 0 || offsetY > 0) {
			
			gl.clearColor (0, 0, 0, 1);
			gl.enable (gl.SCISSOR_TEST);
			
			if (offsetX > 0) {
				
				gl.scissor (0, 0, offsetX, windowHeight);
				gl.clear (gl.COLOR_BUFFER_BIT);
				
				gl.scissor (offsetX + displayWidth, 0, windowWidth, windowHeight);
				gl.clear (gl.COLOR_BUFFER_BIT);
				
			}
			
			if (offsetY > 0) {
				
				gl.scissor (0, 0, windowWidth, offsetY);
				gl.clear (gl.COLOR_BUFFER_BIT);
				
				gl.scissor (0, offsetY + displayHeight, windowWidth, windowHeight);
				gl.clear (gl.COLOR_BUFFER_BIT);
				
			}
			
			gl.disable (gl.SCISSOR_TEST);
			
		}
		
	}
	
	
	public override function resize (width:Int, height:Int):Void {
		
		super.resize (width, height);
		
		projection = Matrix4.createOrtho (0, width, height, 0, -1000, 1000);
		
	}
	
	
}