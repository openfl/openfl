package openfl._internal.renderer.context3D.batcher;

import lime.utils.Float32Array;
import lime.utils.ObjectPool;
import openfl.geom.ColorTransform;

@SuppressWarnings("checkstyle:FieldDocComment")
class Quad
{
	public static var pool(default, never) = new ObjectPool(Quad.new, function(quad) quad.cleanup());

	/** Absolute vertex coordinates **/
	public var vertexData(default, null):Float32Array;

	/** Link to the texture information **/
	public var texture:QuadTextureData;

	public var alpha(default, null):Float;

	public var colorTransform(default, null):ColorTransform;

	public var blendMode(default, null):BatchBlendMode;

	public var smoothing(default, null):Bool;

	public function new()
	{
		vertexData = new Float32Array(4 * 2);
		alpha = 1;
		smoothing = false;
	}

	public inline function setup(alpha:Float, colorTransform:ColorTransform, blendMode:BatchBlendMode, smoothing:Bool):Void
	{
		this.alpha = alpha;
		this.colorTransform = colorTransform;
		this.blendMode = blendMode;
		this.smoothing = smoothing;
	}

	private function cleanup():Void
	{
		texture = null;
		colorTransform = null;
	}
}
