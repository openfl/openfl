namespace openfl.display
{
	/**
	The JPEGEncoderOptions class defines a compression algorithm for the
	`openfl.display.BitmapData.encode()` method.
**/
	export class JPEGEncoderOptions
	{
		/**
			A value between 1 and 100, where 1 means the lowest quality and 100 means the
			highest quality. The higher the value, the larger the size of the output of the
			compression, and the smaller the compression ratio.
		**/
		public quality: number;

		/**
			Creates a JPEGEncoderOptions object with the specified setting.

			@param	quality	The initial quality value.
		**/
		public constructor(quality: number = 80)
		{
			this.quality = quality;
		}
	}
}

export default openfl.display.JPEGEncoderOptions;
