package openfl.display;


import openfl._internal.renderer.RenderSession;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;


interface IBitmapDrawable {
	
	private var __blendMode:BlendMode;
	private var __isMask:Bool;
	private var __renderable:Bool;
	private var __transform:Matrix;
	private var __worldAlpha:Float;
	private var __worldColorTransform:ColorTransform;
	private var __worldTransform:Matrix;
	
	private function __getBounds (rect:Rectangle, matrix:Matrix):Void;
	private function __renderCairo (renderSession:RenderSession):Void;
	private function __renderCairoMask (renderSession:RenderSession):Void;
	private function __renderCanvas (renderSession:RenderSession):Void;
	private function __renderCanvasMask (renderSession:RenderSession):Void;
	private function __renderGL (renderSession:RenderSession):Void;
	private function __renderGLMask (renderSession:RenderSession):Void;
	private function __updateChildren (transformOnly:Bool):Void;
	private function __updateTransforms (?overrideTransform:Matrix = null):Void;
	
	private function __updateMask (maskGraphics:Graphics):Void;
	
}