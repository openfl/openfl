package openfl._internal.renderer.opengl;


import lime.graphics.GLRenderContext;
import lime.math.Matrix4;
import openfl._internal.renderer.AbstractRenderer;
import openfl.display.Stage;
import openfl.geom.Matrix;

@:access(openfl.display.Stage)


class GLRenderer extends AbstractRenderer {
	
	
	public var projection:Matrix4;
	
	private var gl:GLRenderContext;
	private var matrix:Matrix4;
	
	
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
	
	
	public override function render (stage:Stage):Void {
		
		var displayMatrix = stage.__displayMatrix;
		var offsetX = Math.round (displayMatrix.__transformInverseX (0, 0));
		var offsetY = Math.round (displayMatrix.__transformInverseY (0, 0));
		var displayWidth = Math.round (displayMatrix.__transformInverseX (width, 0) - offsetX);
		var displayHeight = Math.round (displayMatrix.__transformInverseY (0, height) - offsetY);
		
		gl.viewport (offsetX, offsetY, displayWidth, displayHeight);
		
		if (this.transparent) {
			
			gl.clearColor (1, 0, 0, 1);
			
		} else {
			
			gl.clearColor (stage.__colorSplit[0], stage.__colorSplit[1], stage.__colorSplit[2], 1);
			
		}
		
		gl.clear (gl.COLOR_BUFFER_BIT);
		
		stage.__renderGL (renderSession);
		
		if (offsetX > 0 || offsetY > 0) {
			
			gl.clearColor (0, 0, 0, 1);
			gl.enable (gl.SCISSOR_TEST);
			
			var window = stage.window;
			
			if (offsetX > 0) {
				
				gl.scissor (0, 0, offsetX, window.height);
				gl.clear (gl.COLOR_BUFFER_BIT);
				
				gl.scissor (offsetX + displayWidth, 0, window.width, window.height);
				gl.clear (gl.COLOR_BUFFER_BIT);
				
			}
			
			if (offsetY > 0) {
				
				gl.scissor (0, 0, stage.window.width, offsetY);
				gl.clear (gl.COLOR_BUFFER_BIT);
				
				gl.scissor (0, offsetY + displayHeight, window.width, window.height);
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