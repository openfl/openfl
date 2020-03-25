/**
		The TouchscreenType class is an enumeration class that provides values for
		the different types of touch screens.
		Use the values defined by the TouchscreenType class with the
		`Capabilities.touchscreenType` property.
	**/
export enum TouchscreenType
{
	/**
		A touchscreen designed to respond to finger touches.
	**/
	FINGER = "finger",

	/**
		The computer or device does not have a supported touchscreen.
	**/
	NONE = "none",

	/**
		A touchscreen designed for use with a stylus.
	**/
	STYLUS = "stylus"
}

export default TouchscreenType;
