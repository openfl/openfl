package openfl._internal.renderer.opengl.batcher;

import lime.utils.Float32Array;
import lime.utils.ObjectPool;
import openfl.geom.ColorTransform;

class Quad {
	public static var pool(default,never) = new ObjectPool(Quad.new, function(quad) quad.cleanup());

	/** Absolute vertex coordinates **/
	public var vertexData(default,null):Float32Array;

	/** Link to the texture information **/
	public var texture:QuadTextureData;

	public var alpha:Float;

	public var colorTransform:ColorTransform;

	public var blendMode:BlendMode;

	public var smoothing:Bool;

	public function new() {
		vertexData = new Float32Array(4 * 2);
		alpha = 1;
		smoothing = false;
	}
	
	function cleanup() {
		texture = null;
		colorTransform = null;
	}
}
