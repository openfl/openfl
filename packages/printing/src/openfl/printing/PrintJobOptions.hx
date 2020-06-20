package openfl.printing;

#if !flash
/**
	The PrintJobOptions class contains properties to use with the `options`
	parameter of the `PrintJob.addPage()` method. For more information about
	`addPage()`, see the PrintJob class.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class PrintJobOptions
{
	/**
		Specifies whether the content in the print job is printed as a bitmap
		or as a vector. The default value is `false`, for vector printing.
		If the content that you're printing includes a bitmap image, set
		`printAsBitmap` to `true` to include any alpha transparency and color
		effects. If the content does not include bitmap images, print the
		content in higher quality vector format (the default option).

		For example, to print your content as a bitmap, use the following
		syntax:

		```haxe
		var options = new PrintJobOptions();
		options.printAsBitmap = true;
		myPrintJob.addPage(mySprite, null, options);
		```

		_Note:_ Adobe AIR does not support vector printing on Mac OS.
	**/
	public var printAsBitmap:Bool;

	/**
		Creates a new PrintJobOptions object. Pass this object to the
		`options` parameter of the `PrintJob.addPage()` method.

		@param printAsBitmap If `true`, this object is printed as a bitmap. If
							 `false`, this object is printed as a vector.
							 If the content that you're printing includes a
							 bitmap image, set the `printAsBitmap` property to
							 `true` to include any alpha transparency and
							 color effects. If the content does not include
							 bitmap images, omit this parameter to print the
							 content in higher quality vector format (the
							 default option).

							 _Note:_Adobe AIR does not support vector printing
							 on Mac OS.
	**/
	public function new(printAsBitmap:Bool = false)
	{
		this.printAsBitmap = printAsBitmap;
	}
}
#else
typedef PrintJobOptions = flash.printing.PrintJobOptions;
#end
