package openfl._internal.renderer.opengl.batcher;

import lime.utils.Float32Array;

class QuadTextureData {
	public var data(default,null):TextureData;

	/** Texture coordinates (0x0-1x1 for full texture, some region for atlas sub-textures) **/
	public var uvs(default,null):Float32Array;
	
	/** Is the texture with premultiplied alpha or not **/
	public var premultipliedAlpha(default,null):Bool;

	static var fullFrameUVs = new Float32Array([
		0, 0,
		1, 0,
		1, 1,
		0, 1
	]);

	public static inline function createFullFrame(data:TextureData, pma:Bool = true):QuadTextureData {
		return new QuadTextureData(data, fullFrameUVs, pma);
	}

	public static inline function createRegion(data:TextureData, u0:Float, v0:Float, u1:Float, v1:Float, u2:Float, v2:Float, u3:Float, v3:Float, pma:Bool = true):QuadTextureData {
		return new QuadTextureData(data, new Float32Array([
			u0, v0,
			u1, v1,
			u2, v2,
			u3, v3
		]), pma);
	}

	function new(data, uvs, premultipliedAlpha) {
		this.data = data;
		this.uvs = uvs;
		this.premultipliedAlpha = premultipliedAlpha;
	}
}
