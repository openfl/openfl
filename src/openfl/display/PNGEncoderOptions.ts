namespace openfl.display
{
	/**
		The PNGEncoderOptions class defines a compression algorithm for the
		`openfl.display.BitmapData.encode()` method.
	**/
	export class PNGEncoderOptions
	{
		/**
			Chooses compression speed over file size. Setting this property to true improves
			compression speed but creates larger files.
		**/
		public fastCompression: boolean;

		/**
			Creates a PNGEncoderOptions object, optionally specifying compression settings.

			@param	fastCompression	The initial compression mode.
		**/
		public constructor(fastCompression: boolean = false)
		{
			this.fastCompression = fastCompression;
		}
	}
}

export default openfl.display.PNGEncoderOptions;
