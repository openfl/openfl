/**
	This class provides values that are used by the `PrintJob.orientation`
	property for the image position of a printed page.
**/
export enum PrintJobOrientation
{
	/**
		The landscape (horizontal) image orientation for printing. This
		constant is used with the `PrintJob.orientation` property. Use the
		syntax `PrintJobOrientation.LANDSCAPE`.
	**/
	LANDSCAPE = "landscape",

	/**
		The portrait (vertical) image orientation for printing. This constant
		is used with the `PrintJob.orientation` property. Use the syntax
		`PrintJobOrientation.PORTRAIT`.
	**/
	PORTRAIT = "portrait"
}

export default PrintJobOrientation;
