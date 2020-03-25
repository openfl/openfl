namespace openfl.display
{
	/**
		The LineScaleMode class provides values for the `scaleMode`
		parameter in the `Graphics.lineStyle()` method.
	**/
	export enum LineScaleMode
	{
		/**
			With this setting used as the `scaleMode` parameter of the
			`lineStyle()` method, the thickness of the line scales
			_only_ vertically. For example, consider the following circles, drawn
			with a one-pixel line, and each with the `scaleMode` parameter
			set to `LineScaleMode.VERTICAL`. The circle on the left is
			scaled only vertically, and the circle on the right is scaled both
			vertically and horizontally.
		**/
		HORIZONTAL = "horizontal",

		/**
			With this setting used as the `scaleMode` parameter of the
			`lineStyle()` method, the thickness of the line never scales.
		**/
		NONE = "none",

		/**
			With this setting used as the `scaleMode` parameter of the
			`lineStyle()` method, the thickness of the line always scales
			when the object is scaled(the default).
		**/
		NORMAL = "normal",

		/**
			With this setting used as the `scaleMode` parameter of the
			`lineStyle()` method, the thickness of the line scales
			_only_ horizontally. For example, consider the following circles,
			drawn with a one-pixel line, and each with the `scaleMode`
			parameter set to `LineScaleMode.HORIZONTAL`. The circle on the
			left is scaled only horizontally, and the circle on the right is scaled
			both vertically and horizontally.
		**/
		VERTICAL = "vertical"
	}
}

export default openfl.display.LineScaleMode;
