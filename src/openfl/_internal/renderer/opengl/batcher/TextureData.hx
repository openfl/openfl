package openfl._internal.renderer.opengl.batcher;

import lime.graphics.opengl.GLTexture;

class TextureData {
	/** Actual GL texture **/
	public var glTexture:GLTexture;

	/** Batcher-specific data about this texture (so we don't have to allocate more storage and do lookups) **/
	public var textureUnitId = -1;
	public var enabledTick = 0;

	public function new(glTexture) {
		this.glTexture = glTexture;
	}
}
