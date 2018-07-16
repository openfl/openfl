package openfl._internal.renderer; #if (!display && !flash)


import openfl._internal.renderer.opengl.vao.VertexArrayObjectExtension;
import lime.graphics.opengl.GLContextType;
import openfl._internal.renderer.opengl.vao.VertexArrayObjectContext;
import openfl._internal.renderer.opengl.vao.IVertexArrayObjectContext;
import lime.graphics.opengl.GLFramebuffer;
import lime.graphics.CairoRenderContext;
import lime.graphics.CanvasRenderContext;
import lime.graphics.DOMRenderContext;
import lime.graphics.GLRenderContext;
import lime.graphics.RendererType;
//import openfl._internal.renderer.opengl.utils.BlendModeManager;
//import openfl._internal.renderer.opengl.utils.FilterManager;
//import openfl._internal.renderer.opengl.utils.ShaderManager;
//import openfl._internal.renderer.opengl.utils.SpriteBatch;
//import openfl._internal.renderer.opengl.utils.StencilManager;
import openfl.display.BlendMode;
import openfl.geom.Matrix;
import openfl.geom.Point;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class RenderSession {
	
	
	public var allowSmoothing:Bool;
	public var cairo:CairoRenderContext;
	public var clearRenderDirty:Bool;
	public var context:CanvasRenderContext;
	public var element:DOMRenderContext;
	public var forceSmoothing:Bool;
	public var gl(default, set):GLRenderContext;
	// public var lockTransform:Bool;
	public var renderer:AbstractRenderer;
	public var renderType:RendererType;
	public var roundPixels:Bool;
	public var transformProperty:String;
	public var transformOriginProperty:String;
	public var vendorPrefix:String;
	public var vaoContext:IVertexArrayObjectContext;
	public var pixelRatio:Float = 1.0;
	public var projectionMatrix:Matrix;	
	public var z:Int;
	
	public var drawCount:Int;
	public var currentBlendMode:BlendMode;
	public var activeTextures:Int = 0;
	
	//public var shaderManager:ShaderManager;
	public var blendModeManager:AbstractBlendModeManager;
	public var filterManager:AbstractFilterManager;
	public var maskManager:AbstractMaskManager;
	public var shaderManager:AbstractShaderManager;
	//public var filterManager:FilterManager;
	//public var blendModeManager:BlendModeManager;
	//public var spriteBatch:SpriteBatch;
	//public var stencilManager:StencilManager;
	//public var defaultFramebuffer:GLFramebuffer;
	
	
	private function set_gl(glContext: GLRenderContext): GLRenderContext {
		
		gl = glContext;
		
		#if vertex_array_object
		if (gl.type == GLContextType.WEBGL) { 
			
			if (gl.version == 2) {
				
				vaoContext = new VertexArrayObjectContext (gl);
				
			} else if (gl.version == 1) {
				
				var vertexArrayObjectsExtension = gl.getExtension ("OES_vertex_array_object");
				
				if (vertexArrayObjectsExtension != null) {
					
					vaoContext = new VertexArrayObjectExtension (vertexArrayObjectsExtension);
					
				}
				
			}
			
		}
		#end
		
		return gl;
		
	}
	
	
	public function new () {
		
		allowSmoothing = true;
		clearRenderDirty = false;
		//maskManager = new MaskManager (this);
		
	}
	
	
}

#else

class RenderSession {}

#end