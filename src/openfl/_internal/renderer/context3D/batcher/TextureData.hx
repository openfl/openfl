package openfl._internal.renderer.context3D.batcher;

import lime.graphics.opengl.GLTexture;

@SuppressWarnings("checkstyle:FieldDocComment")
class TextureData
{
	/** Actual GL texture **/
	public var glTexture:GLTexture;

	public function new(glTexture:GLTexture)
	{
		this.glTexture = glTexture;
	}
}
