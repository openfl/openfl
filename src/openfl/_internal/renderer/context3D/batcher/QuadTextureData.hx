package openfl._internal.renderer.context3D.batcher;

import lime.utils.Float32Array;
import openfl.display.BitmapData;

@SuppressWarnings("checkstyle:FieldDocComment")
class QuadTextureData
{
	public var bitmapData(default, null):BitmapData;

	/** Texture coordinates (0x0-1x1 for full texture, some region for atlas sub-textures) **/
	public var uvs(default, null):Float32Array;

	/** Is the texture with premultiplied alpha or not **/
	public var premultipliedAlpha(default, null):Bool;

	private static var fullFrameUVs:Float32Array = new Float32Array([
		0, 0,
		1, 0,
		1, 1,
		0, 1
	]);

	public static inline function createFullFrame(bitmapData:BitmapData, pma:Bool = true):QuadTextureData
	{
		return new QuadTextureData(bitmapData, fullFrameUVs, pma);
	}

	public static inline function createRegion(bitmapData:BitmapData, u0:Float, v0:Float, u1:Float, v1:Float, u2:Float, v2:Float, u3:Float, v3:Float,
			pma:Bool = true):QuadTextureData
	{
		return new QuadTextureData(bitmapData, new Float32Array([
			u0, v0,
			u1, v1,
			u2, v2,
			u3, v3
		]), pma);
	}

	private function new(bitmapData:BitmapData, uvs:Float32Array, premultipliedAlpha:Bool)
	{
		this.bitmapData = bitmapData;
		this.uvs = uvs;
		this.premultipliedAlpha = premultipliedAlpha;
	}
}
