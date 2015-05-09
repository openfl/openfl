package openfl._internal.renderer; #if !flash


import lime.graphics.CairoRenderContext;
import lime.graphics.CanvasRenderContext;
import lime.graphics.DOMRenderContext;
import lime.graphics.GLRenderContext;
import lime.graphics.opengl.GLFramebuffer;
import openfl._internal.renderer.opengl.utils.BlendModeManager;
import openfl._internal.renderer.opengl.utils.FilterManager;
import openfl._internal.renderer.opengl.utils.ShaderManager;
import openfl._internal.renderer.opengl.utils.SpriteBatch;
import openfl._internal.renderer.opengl.utils.StencilManager;
import openfl.display.BlendMode;
import openfl.geom.Matrix;
import openfl.geom.Point;


class RenderSession {
	
	
	public var cairo:CairoRenderContext;
	public var context:CanvasRenderContext;
	public var element:DOMRenderContext;
	public var gl:GLRenderContext;
	public var renderer:AbstractRenderer;
	public var roundPixels:Bool;
	public var transformProperty:String;
	public var transformOriginProperty:String;
	public var vendorPrefix:String;
	public var z:Int;
	public var projectionMatrix:Matrix;
	
	public var drawCount:Int;
	public var currentBlendMode:BlendMode;
	
	public var shaderManager:ShaderManager;
	public var maskManager:AbstractMaskManager;
	public var filterManager:FilterManager;
	public var blendModeManager:BlendModeManager;
	public var spriteBatch:SpriteBatch;
	public var stencilManager:StencilManager;
	public var defaultFramebuffer:GLFramebuffer;
	
	
	public function new () {
		
		//maskManager = new MaskManager (this);
		
	}
	
	
} #end