package openfl.display;

import openfl._internal.renderer.DisplayObjectType;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

@:noCompletion
interface _IBitmapDrawable
{
	public var __blendMode:BlendMode;
	public var __isMask:Bool;
	public var __mask:DisplayObject;
	public var __renderable:Bool;
	public var __renderTransform:Matrix;
	public var __scrollRect:Rectangle;
	public var __transform:Matrix;
	public var __type:DisplayObjectType;
	public var __worldAlpha:Float;
	public var __worldColorTransform:ColorTransform;
	public var __worldTransform:Matrix;
	public function __getBounds(rect:Rectangle, matrix:Matrix):Void;
	public function __update(transformOnly:Bool, updateChildren:Bool):Void;
}
