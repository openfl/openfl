import EventDispatcher from "openfl/events/EventDispatcher";

namespace openfl.display3D.textures
{
	/**
		The TextureBase class is the base class for Context3D texture objects.

		**Note:** You cannot create your own texture classes using TextureBase. To add
		functionality to a texture class, extend either Texture or CubeTexture instead.
	**/
	export class TextureBase extends EventDispatcher
	{
		protected __baseBackend: TextureBaseBackend;
		protected __context: Context3D;
		protected __format: Context3DTextureFormat;
		protected __height: number;
		protected __optimizeForRenderToTexture: boolean;
		protected __streamingLevels: number;
		protected __width: number;

		protected constructor(context: Context3D, width: number, height: number, format: Context3DTextureFormat, optimizeForRenderToTexture: boolean,
			streamingLevels: number)
		{
			super();

			__context = context;
			__width = width;
			__height = height;
			__format = format;
			__optimizeForRenderToTexture = optimizeForRenderToTexture;
			__streamingLevels = streamingLevels;
		}

		/**
			Frees all GPU resources associated with this texture. After disposal, calling
			`upload()` or rendering with this object fails.
		**/
		public dispose(): void
		{
			__baseBackend.dispose();
		}
	}
}

export default openfl.display3D.textures.TextureBase;
