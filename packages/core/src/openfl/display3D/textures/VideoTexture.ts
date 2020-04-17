import TextureBase from "../../display3D/textures/TextureBase";
import Context3D from "../../display3D/Context3D";
import NetStream from "../../net/NetStream";

/**
	Prior to Flash Player 21, the use of video in Stage3D required the use of the Video
	object (which is not hardware accelerated), copying of video frame to a BitmapData
	object, and loading of the data onto the GPU which is CPU intensive. Thus, Video
	texture object was introduced. It allows hardware decoded video to be used in Stage 3D
	content.

	For Flash Player 22, video texture objects were added to support NetStream and Cameras
	in a manner consistent/ similar to StageVideo. Such textures can be used as source
	textures in the stage3D rendering pipeline. The textures can be used as rectangular,
	RGB, no mipmap textures in the rendering of a scene. They are treated as ARGB texture
	by the shaders (that is, the AGAL shaders do not have to bother about YUV->RGB
	conversion) and so the standard shaders with static images can be used without change.
	The image used by the rendering pipeline is the latest up-to-date frame at the time the
	rendering occurs using this texture. There is no tearing in a video frame, however if
	the same texture is used several times, some of the instances may be from different
	timestamps.
**/
export default class VideoTexture extends TextureBase
{
	protected __videoHeight: number;
	protected __videoWidth: number;

	protected constructor(context: Context3D)
	{
		super(context, 0, 0, null, false, 0);
	}

	/**
		Specifies a video stream from a camera to be rendered within the texture of the
		VideoTexture object.

		Use this method to attach live video captured by the user to the VideoTexture
		object. To drop the connection to the VideoTexture object, set the value of the
		`theCamera` parameter to `null`.

		@param	theCamera
	**/
	// public attachCamera(theCamera:Camera):Void {}

	/**
		Specifies a video stream to be rendered within the texture of the VideoTexture
		object.

		A video file can be stored on the local file system or on Flash Media Server. If
		the value of the netStream argument is `null`, the video is no longer played in the
		VideoTexture object.

		@param	netStream
	**/
	public attachNetStream(netStream: NetStream): void
	{
		// __backend.attachNetStream(netStream);
	}

	public dispose(): void
	{
		// __backend.dispose();
	}

	// Get & Set Methods

	/**
		An integer specifying the height of the video stream, in pixels.

		For a live stream, this value is the same as the Camera.height property of the
		Camera object that is capturing the video stream. For a recorded video file, this
		value is the height of the video. The `NetStream.Video.DimensionChange` event is
		dispatched in the case of recorded videos when this value changes.
	**/
	public get videoHeight(): number
	{
		return this.__videoHeight;
	}

	/**
		An integer specifying the width of the video stream, in pixels.

		For a live stream, this value is the same as the Camera.width property of the
		Camera object that is capturing the video stream. For a recorded video file, this
		value is the width of the video. The `NetStream.Video.DimensionChange` event is
		dispatched in the case of recorded videos when this value changes.
	**/
	public get videoWidth(): number
	{
		return this.__videoWidth;
	}
}
