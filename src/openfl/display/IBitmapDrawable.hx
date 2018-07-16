package openfl.display;


import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;


interface IBitmapDrawable {
	
	private var __blendMode:BlendMode;
	private var __isMask:Bool;
	private var __renderable:Bool;
	private var __renderTransform:Matrix;
	private var __transform:Matrix;
	private var __worldAlpha:Float;
	private var __worldColorTransform:ColorTransform;
	private var __worldTransform:Matrix;
	
	private function __getBounds (rect:Rectangle, matrix:Matrix):Void;
	private function __renderCairo (renderer:CairoRenderer):Void;
	private function __renderCairoMask (renderer:CairoRenderer):Void;
	private function __renderCanvas (renderer:CanvasRenderer):Void;
	private function __renderCanvasMask (renderer:CanvasRenderer):Void;
	private function __renderDOM (renderer:DOMRenderer):Void;
	private function __renderGL (renderer:OpenGLRenderer):Void;
	private function __renderGLMask (renderer:OpenGLRenderer):Void;
	private function __update (transformOnly:Bool, updateChildren:Bool):Void;
	private function __updateChildren (transformOnly:Bool):Void;
	private function __updateTransforms (?overrideTransform:Matrix = null):Void;
	
	private var __mask:DisplayObject;
	private var __scrollRect:Rectangle;
	
}