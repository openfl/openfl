namespace openfl.display
{
	/**
		The StageScaleMode class provides values for the
		`Stage.scaleMode` property.
	**/
	export enum StageScaleMode
	{
		/**
			Specifies that the entire application be visible in the specified area without
			trying to preserve the original aspect ratio. Distortion can occur.
		**/
		EXACT_FIT = "exactFit",

		/**
			Specifies that the entire application fill the specified area, without
			distortion but possibly with some cropping, while maintaining the original
			aspect ratio of the application.
		**/
		NO_BORDER = "noBorder",

		/**
			Specifies that the size of the application be fixed, so that it remains
			unchanged even as the size of the player window changes. Cropping might occur
			if the player window is smaller than the content.
		**/
		NO_SCALE = "noScale",

		/**
			Specifies that the entire application be visible in the specified area without
			distortion while maintaining the original aspect ratio of the application.
			Borders can appear on two sides of the application.
		**/
		SHOW_ALL = "showAll"
	}
}

export default openfl.display.StageScaleMode;
