package openfl._internal.renderer.context3D.batcher;

import lime.graphics.opengl.GLTexture;

@SuppressWarnings("checkstyle:FieldDocComment")
class TextureData
{
	/** Actual GL texture **/
	public var glTexture:GLTexture;

	/** Batcher-specific data about this texture (so we don't have to allocate more storage and do lookups) **/
	public var textureUnitId:Int = -1;

	public var enabledTick:Int = 0;
	public var lastSmoothing:Bool = false;

	public function new(glTexture:GLTexture)
	{
		this.glTexture = glTexture;
	}
}
