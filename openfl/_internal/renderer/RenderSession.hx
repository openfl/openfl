package openfl._internal.renderer; #if !flash


import lime.graphics.CanvasRenderContext;
import lime.graphics.DOMRenderContext;
import lime.graphics.GLRenderContext;
import lime.math.Matrix4;
import openfl._internal.renderer.opengl.utils.BlendModeManager;
import openfl._internal.renderer.opengl.utils.FilterManager;
import openfl._internal.renderer.opengl.utils.MaskManager;
import openfl._internal.renderer.opengl.utils.ShaderManager;
import openfl._internal.renderer.opengl.utils.SpriteBatch;
import openfl._internal.renderer.opengl.utils.StencilManager;
import openfl.display.BlendMode;
import openfl.geom.Point;


class RenderSession {
	
	
	public var context:CanvasRenderContext;
	public var element:DOMRenderContext;
	public var gl:GLRenderContext;
	//public var glProgram:ShaderProgram;
	//public var mask:Bool;
	//public var maskManager:MaskManager;
	public var projectionMatrix:Matrix4;
	public var renderer:AbstractRenderer;
	//public var scaleMode:ScaleMode;
	public var roundPixels:Bool;
	public var transformProperty:String;
	public var transformOriginProperty:String;
	public var vendorPrefix:String;
	public var z:Int;
	//public var smoothProperty:Null<Bool> = null;
	
	public var drawCount:Int;
	public var currentBlendMode:BlendMode;
	public var projection:Point;
	public var offset:Point;
	
	public var shaderManager:ShaderManager;
	public var maskManager:Dynamic;
	public var filterManager:FilterManager;
	public var blendModeManager:BlendModeManager;
	public var spriteBatch:SpriteBatch;
	public var stencilManager:StencilManager;
	
	
	public function new () {
		
		//maskManager = new MaskManager (this);
		
	}
	
	
} #end