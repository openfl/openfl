package openfl._internal.renderer.opengl.batcher;

import lime.utils.Float32Array;
import openfl.display.BlendMode;
import openfl.geom.ColorTransform;

class Quad {
	/** Absolute vertex coordinates **/
	public var vertexData(default,null):Float32Array;

	/** Link to the texture information **/
	public var texture:Texture;

	public var alpha:Float;

	public var colorTransform:ColorTransform;

	public var blendMode:BlendMode;

	public var smoothing:Bool;

	public function new() {
		vertexData = new Float32Array(4 * 2);
		alpha = 1;
		smoothing = false;
	}
}
