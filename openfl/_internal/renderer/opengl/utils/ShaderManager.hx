package openfl._internal.renderer.opengl.utils ;


import lime.graphics.GLRenderContext;
import openfl._internal.renderer.opengl.shaders.AbstractShader;
import openfl._internal.renderer.opengl.shaders.ComplexPrimitiveShader;
import openfl._internal.renderer.opengl.shaders.DefaultShader;
import openfl._internal.renderer.opengl.shaders.DrawTrianglesShader;
import openfl._internal.renderer.opengl.shaders.FastShader;
import openfl._internal.renderer.opengl.shaders.FillShader;
import openfl._internal.renderer.opengl.shaders.PatternFillShader;
import openfl._internal.renderer.opengl.shaders.PrimitiveShader;
import openfl._internal.renderer.opengl.shaders.StripShader;


class ShaderManager {
	
	
	public var attribState:Array<Bool>;
	public var complexPrimitiveShader:ComplexPrimitiveShader;
	public var currentShader:AbstractShader;
	public var defaultShader:DefaultShader;
	public var fastShader:FastShader;
	public var gl:GLRenderContext;
	public var maxAttibs:Int;
	public var primitiveShader:PrimitiveShader;
	
	public var fillShader:FillShader;
	public var patternFillShader:PatternFillShader;
	public var drawTrianglesShader:DrawTrianglesShader;
	
	public var shaderMap:Array<AbstractShader>;
	public var stripShader:StripShader;
	public var tempAttribState:Array<Bool>;
	
	private var _currentId:Int;
	
	
	public function new (gl:GLRenderContext) {
		
		maxAttibs = 10;
		attribState = [];
		tempAttribState = [];
		shaderMap = [];
		
		for (i in 0...this.maxAttibs) {
			
			attribState[i] = false;
			
		}
		
		setContext (gl);
		
	}
	
	
	public function destroy ():Void {
		
		attribState = null;
		tempAttribState = null;
		primitiveShader.destroy ();
		defaultShader.destroy ();
		fastShader.destroy ();
		stripShader.destroy ();
		
		fillShader.destroy();
		patternFillShader.destroy();
		drawTrianglesShader.destroy();
		
		gl = null;
		
	}
	
	
	public function setAttribs (attribs:Array<Dynamic>):Void {
		
		for (i in 0...tempAttribState.length) {
			
			tempAttribState[i] = false;
			
		}
		
		for (i in 0...attribs.length) {
			
			var attribId = attribs[i];
			tempAttribState[attribId] = true;
			
		}
		
		var gl = this.gl;
		
		for (i in 0...attribState.length) {
			
			if (attribState[i] != tempAttribState[i]) {
				
				attribState[i] = tempAttribState[i];
				
				if (tempAttribState[i]) {
					
					gl.enableVertexAttribArray (i);
					
				} else {
					
					gl.disableVertexAttribArray (i);
					
				}
				
			}
			
		}
		
	}
	
	
	public function setContext (gl:GLRenderContext):Void {
		
		this.gl = gl;
		
		primitiveShader = new PrimitiveShader (gl);
		complexPrimitiveShader = new ComplexPrimitiveShader (gl);
		defaultShader = new DefaultShader (gl);
		fastShader = new FastShader (gl);
		stripShader = new StripShader (gl);
		
		fillShader = new FillShader(gl);
		patternFillShader = new PatternFillShader(gl);
		drawTrianglesShader = new DrawTrianglesShader(gl);
		
		setShader (defaultShader);
		
	}
	
	
	public function setShader (shader:AbstractShader):Bool {
		
		if (this._currentId == shader._UID) return false;
		
		this._currentId = shader._UID;
		this.currentShader = shader;
		
		gl.useProgram (shader.program);
		setAttribs (shader.attributes);
		
		return true;
		
	}
	
	
}