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
		renderSession.blendModeManager = new GLBlendModeManager (gl);
		renderSession.shaderManager = new GLShaderManager (gl);
		renderSession.renderer = this;
		
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
		
		gl.viewport (0, 0, width, height);
		
		if (this.transparent) {
			
			gl.clearColor (1, 0, 0, 1);
			
		} else {
			
			gl.clearColor (stage.__colorSplit[0], stage.__colorSplit[1], stage.__colorSplit[2], 1);
			
		}
		
		gl.clear (gl.COLOR_BUFFER_BIT);
		
		stage.__renderGL (renderSession);
		
	}
	
	
	public override function resize (width:Int, height:Int):Void {
		
		this.width = width;
		this.height = height;
		
		super.resize (width, height);
		
		projection = Matrix4.createOrtho (0, width, height, 0, -1000, 1000);
		
	}
	
	
}