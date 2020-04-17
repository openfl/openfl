import Context3D from "../../display3D/Context3D";
import Context3DTextureFormat from "../../display3D/Context3DTextureFormat";
import EventDispatcher from "../../events/EventDispatcher";

/**
	The TextureBase class is the base class for Context3D texture objects.

	**Note:** You cannot create your own texture classes using TextureBase. To add
	functionality to a texture class, extend either Texture or CubeTexture instead.
**/
export default class TextureBase extends EventDispatcher
{
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

		this.__context = context;
		this.__width = width;
		this.__height = height;
		this.__format = format;
		this.__optimizeForRenderToTexture = optimizeForRenderToTexture;
		this.__streamingLevels = streamingLevels;
	}

	/**
		Frees all GPU resources associated with this texture. After disposal, calling
		`upload()` or rendering with this object fails.
	**/
	public dispose(): void
	{
		// __baseBackend.dispose();
	}
}
