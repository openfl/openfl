package openfl.printing;

#if !flash
import haxe.Timer;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.geom.Rectangle;
#if lime
import lime._internal.graphics.ImageCanvasUtil; // TODO
#end
#if (js && html5)
import js.html.DivElement;
import js.html.Image;
import js.html.StyleElement;
import js.Browser;
#end

/**
	The PrintJob class lets you create content and print it to one or more
	pages. This class lets you render content that is visible, dynamic or
	offscreen to the user, prompt users with a single Print dialog box, and
	print an unscaled document with proportions that map to the proportions of
	the content. This capability is especially useful for rendering and
	printing dynamic content, such as database content and dynamic text.
	**Mobile Browser Support:** This class is not supported in mobile
	browsers.

	_AIR profile support:_ This feature is supported on all desktop operating
	systems, but it is not supported on mobile devices or AIR for TV devices.
	You can test for support at run time using the `PrintJob.isSupported`
	property. See <a
	href="http://help.adobe.com/en_US/air/build/WS144092a96ffef7cc16ddeea2126bb46b82f-8000.html">
	AIR Profile Support</a> for more information regarding API support across
	multiple profiles.

	Use the `PrintJob()` constructor to create a print job.

	Additionally, with the PrintJob class's properties, you can read your
	user's printer settings, such as page height, width, and image
	orientation, and you can configure your document to dynamically format
	Flash content that is appropriate for the printer settings.

	**Note:** ActionScript 3.0 does not restrict a PrintJob object to a single
	frame (as did previous versions of ActionScript). However, since the
	operating system displays print status information to the user after the
	user has clicked the OK button in the Print dialog box, you should call
	`PrintJob.addPage()` and `PrintJob.send()` as soon as possible to send
	pages to the spooler. A delay reaching the frame containing the
	`PrintJob.send()` call delays the printing process.

	Additionally, a 15 second script timeout limit applies to the following
	intervals:

	* `PrintJob.start()` and the first `PrintJob.addPage()`
	* `PrintJob.addPage()` and the next `PrintJob.addPage()`
	* The last `PrintJob.addPage()` and `PrintJob.send()`

	If any of the above intervals span more than 15 seconds, the next call to
	`PrintJob.start()` on the PrintJob instance returns `false`, and the next
	`PrintJob.addPage()` on the PrintJob instance causes the Flash Player or
	Adobe AIR to throw a runtime exception.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(lime.graphics.ImageBuffer)
class PrintJob
{
	/**
		Indicates whether the PrintJob class is supported on the current
		platform (`true`) or not (`false`).
	**/
	public static var isSupported(default, null) = #if (js && html5) true #else false #end;

	/**
		The image orientation for printing. The acceptable values are defined
		as constants in the PrintJobOrientation class.
		**Note:** For AIR 2 or later, set this property before starting a
		print job to set the default orientation in the Page Setup and Print
		dialogs. Set the property while a print job is in progress (after
		calling `start()` or `start2()` to set the orientation for a range of
		pages within the job.
	**/
	public var orientation:PrintJobOrientation;

	/**
		The height of the largest area which can be centered in the actual
		printable area on the page, in points. Any user-set margins are
		ignored. This property is available only after a call to the
		`PrintJob.start()` method has been made.
		**Note:** For AIR 2 or later, this property is deprecated. Use
		`printableArea` instead, which measures the printable area in
		fractional points and describes off-center printable areas accurately.
	**/
	public var pageHeight(default, null):Int;

	/**
		The width of the largest area which can be centered in the actual
		printable area on the page, in points. Any user-set margins are
		ignored. This property is available only after a call to the
		`PrintJob.start()` method has been made.
		**Note:** For AIR 2 or later, this property is deprecated. Use
		`printableArea` instead, which measures the printable area in
		fractional points and describes off-center printable areas accurately.
	**/
	public var pageWidth(default, null):Int;

	/**
		The overall paper height, in points. This property is available only
		after a call to the `PrintJob.start()` method has been made.
		**Note:** For AIR 2 or later, this property is deprecated. Use
		`paperArea` instead, which measures the paper dimensions in fractional
		points.
	**/
	public var paperHeight(default, null):Int;

	/**
		The overall paper width, in points. This property is available only
		after a call to the `PrintJob.start()` method has been made.
		**Note:** For AIR 2 or later, this property is deprecated. Use
		`paperArea` instead, which measures the paper dimensions in fractional
		points.
	**/
	public var paperWidth(default, null):Int;

	@:noCompletion private var __bitmapData:Array<BitmapData>;
	@:noCompletion private var __started:Bool;

	/**
		Creates a PrintJob object that you can use to print one or more pages.
		After you create a PrintJob object, you need to use (in the following
		sequence) the `PrintJob.start()`, `PrintJob.addPage()`, and then
		`PrintJob.send()` methods to send the print job to the printer.
		For example, you can replace the `[params]` placeholder text for the
		`myPrintJob.addPage()` method calls with custom parameters as shown in
		the following code:

		```haxe
		// create PrintJob object
		var myPrintJob = new PrintJob();
		// display Print dialog box, but only initiate the print job
		// if start returns successfully.
		if (myPrintJob.start()) {
			// add specified page to print job
			// repeat once for each page to be printed
			try {
				myPrintJob.addPage([params]);
			} catch(e:Dynamic) {
				// handle error
			}
			try {
				myPrintJob.addPage([params]);
			} catch(e:Dynamic) {
				// handle error
			}
			// send pages from the spooler to the printer, but only if one or more
			// calls to addPage() was successful. You should always check for successful
			// calls to start() and addPage() before calling send().
			myPrintJob.send();
		}
		```

		In AIR 2 or later, you can create and use multiple PrintJob instances.
		Properties set on the PrintJob instance are retained after printing
		completes. This allows you to re-use a PrintJob instance and maintain
		a user's selected printing preferences, while offering different
		printing preferences for other content in your application. For
		content in Flash Player and in AIR prior to version 2, you cannot
		create a second PrintJob object while the first one is still active.
		If you create a second PrintJob object (by calling `new PrintJob()`)
		while the first PrintJob object is still active, the second PrintJob
		object will not be created. So, you may check for the `myPrintJob`
		value before creating a second PrintJob.

		@throws IllegalOperationError In Flash Player and AIR prior to AIR 2,
									  throws an exception if another PrintJob
									  object is still active.
	**/
	public function new() {}

	/**
		Sends the specified Sprite object as a single page to the print
		spooler. Before using this method, you must create a PrintJob object
		and then use `start()` or `start2()`. Then, after calling `addPage()`
		one or more times for a print job, use `send()` to send the spooled
		pages to the printer. In other words, after you create a PrintJob
		object, use (in the following sequence) `start()` or `start2()`,
		`addPage()`, and then `send()` to send the print job to the printer.
		You can call `addPage()` multiple times after a single call to
		`start()` to print several pages in a print job.
		If `addPage()` causes Flash Player to throw an exception (for example,
		if you haven't called `start()` or the user cancels the print job),
		any subsequent calls to `addPage()` fail. However, if previous calls
		to `addPage()` are successful, the concluding `send()` command sends
		the successfully spooled pages to the printer.

		If the print job takes more than 15 seconds to complete an `addPage()`
		operation, Flash Player throws an exception on the next `addPage()`
		call.

		If you pass a value for the `printArea` parameter, the `_x_` and `_y_`
		coordinates of the `printArea` Rectangle map to the upper-left corner
		(0, 0 coordinates) of the printable area on the page. The read-only
		properties `pageHeight` and `pageWidth` describe the printable area
		set by `start()`. Because the printout aligns with the upper-left
		corner of the printable area on the page, when the area defined in
		`printArea` is bigger than the printable area on the page, the
		printout is cropped to the right or bottom (or both) of the area
		defined by `printArea`. In Flash Professional, if you don't pass a
		value for `printArea` and the Stage is larger than the printable area,
		the same type of clipping occurs. In Flex or Flash Builder, if you
		don't pass a value for `printArea` and the screen is larger than the
		printable area, the same type of clipping takes place.

		If you want to scale a Sprite object before you print it, set scale
		properties (see `openfl.display.DisplayObject.scaleX` and
		`openfl.display.DisplayObject.scaleY`) before calling this method, and
		set them back to their original values after printing. The scale of a
		Sprite object has no relation to `printArea`. That is, if you specify
		a print area that is 50 x 50 pixels, 2500 pixels are printed. If you
		scale the Sprite object, the same 2500 pixels are printed, but the
		Sprite object is printed at the scaled size.

		The Flash Player printing feature supports PostScript and
		non-PostScript printers. Non-PostScript printers convert vectors to
		bitmaps.

		@param sprite    The Sprite containing the content to print.
		@param printArea A Rectangle object that specifies the area to print.
						 A rectangle's width and height are pixel values. A
						 printer uses points as print units of measurement.
						 Points are a fixed physical size (1/72 inch), but the
						 size of a pixel, onscreen, depends on the resolution
						 of the particular screen. So, the conversion rate
						 between pixels and points depends on the printer
						 settings and whether the sprite is scaled. An
						 unscaled sprite that is 72 pixels wide prints out one
						 inch wide, with one point equal to one pixel,
						 independent of screen resolution.

						 You can use the following equivalencies to convert
						 inches or centimeters to twips or points (a twip is
						 1/20 of a point):

						 * 1 point = 1/72 inch = 20 twips
						 * 1 inch = 72 points = 1440 twips
						 * 1 cm = 567 twips

						 If you omit the `printArea` parameter, or if it is
						 passed incorrectly, the full area of the `sprite`
						 parameter is printed.

						 If you don't want to specify a value for `printArea`
						 but want to specify a value for `options` or
						 `frameNum`, pass `null` for `printArea`.
		@param options   An optional parameter that specifies whether to print
						 as vector or bitmap. The default value is `null`,
						 which represents a request for vector printing. To
						 print `sprite` as a bitmap, set the `printAsBitmap`
						 property of the PrintJobOptions object to `true`.
						 Remember the following suggestions when determining
						 whether to set `printAsBitmap` to `true`:
						 * If the content you're printing includes a bitmap
						 image, set `printAsBitmap` to `true` to include any
						 alpha transparency and color effects.
						 * If the content does not include bitmap images, omit
						 this parameter to print the content in higher quality
						 vector format.

						 If `options` is omitted or is passed incorrectly,
						 vector printing is used. If you don't want to specify
						 a value for `options` but want to specify a value for
						 `frameNumber`, pass `null` for `options`.
		@param frameNum  An optional number that lets you specify which frame
						 of a MovieClip object to print. Passing a `frameNum`
						 does not invoke ActionScript on that frame. If you
						 omit this parameter and the `sprite` parameter is a
						 MovieClip object, the current frame in `sprite` is
						 printed.
		@throws Error Throws an exception if you haven't called `start()` or
					  the user cancels the print job
	**/
	public function addPage(sprite:Sprite, printArea:Rectangle = null, options:PrintJobOptions = null, frameNum:Int = 0):Void
	{
		if (!__started) return;

		if (printArea == null)
		{
			printArea = sprite.getBounds(sprite);
		}

		var bitmapData = new BitmapData(Math.ceil(printArea.width), Math.ceil(printArea.height), true, 0);
		bitmapData.draw(sprite);

		__bitmapData.push(bitmapData);
	}

	/**
		Sends spooled pages to the printer after successful calls to the
		`start()` or `start2()` and `addPage()` methods.
		This method does not succeed if the call to the `start()` or
		`start2()` method fails, or if a call to the `addPage()` method throws
		an exception. To avoid an error, check that the `start()` or
		`start2()` method returns `true` and catch any `addPage()` exceptions
		before calling this method. The following example demonstrates how to
		properly check for errors before calling this method:

		```haxe
		var myPrintJob = new PrintJob();
		if (myPrintJob.start()) {
			try {
				myPrintJob.addPage([params]);
			} catch(e:Dynamic) {
				// handle error
			}
			myPrintJob.send();
		}
		```
	**/
	public function send():Void
	{
		if (!__started) return;

		#if (js && html5)
		var window = Browser.window.open("", "", "width=500,height=500");

		if (window != null)
		{
			var style:StyleElement = cast window.document.createElement("style");
			style.innerText = "@media all {
					.page-break	{ display: none; }
				}

				@media print {
					.page-break	{ display: block; page-break-before: always; }
				}";

			window.document.head.appendChild(style);

			var div:DivElement;
			var image:Image;
			var bitmapData;

			for (i in 0...__bitmapData.length)
			{
				bitmapData = __bitmapData[i];
				ImageCanvasUtil.sync(bitmapData.image, false);

				if (bitmapData.image.buffer.__srcCanvas != null)
				{
					if (i > 0)
					{
						div = cast window.document.createElement("div");
						div.className = "page-break";
						window.document.body.appendChild(div);
					}

					image = new Image();
					image.src = bitmapData.image.buffer.__srcCanvas.toDataURL("image/png");
					window.document.body.appendChild(image);
				}
			}

			Timer.delay(function()
			{
				window.focus();
				window.print();
			}, 500);
		}
		#end
	}

	/**
		Displays the operating system's Print dialog box and starts spooling.
		The Print dialog box lets the user change print settings. When the
		`PrintJob.start()` method returns successfully (the user clicks OK in
		the Print dialog box), the following properties are populated,
		representing the user's chosen print settings:

		| Property | Type | Units | Notes |
		| --- | --- | --- | --- |
		| `PrintJob.paperHeight` | Number | Points | Overall paper height. |
		| `PrintJob.paperWidth` | Number | Points | Overall paper width. |
		| `PrintJob.pageHeight` | Number | Points | Height of actual printable area on the page; any user-set margins are ignored. |
		| `PrintJob.pageWidth` | Number | Points | Width of actual printable area on the page; any user-set margins are ignored. |
		| `PrintJob.orientation` | String | | `"portrait"` (`openfl.printing.PrintJobOrientation.PORTRAIT`) or `"landscape"` (`openfl.printing.PrintJobOrientation.LANDSCAPE`). |

		**Note:** If the user cancels the Print dialog box, the properties are
		not populated.

		After the user clicks OK in the Print dialog box, the player begins
		spooling a print job to the operating system. Because the operating
		system then begins displaying information to the user about the
		printing progress, you should call the `PrintJob.addPage()` and
		`PrintJob.send()` calls as soon as possible to send pages to the
		spooler. You can use the read-only height, width, and orientation
		properties this method populates to format the printout.

		Test to see if this method returns `true` (when the user clicks OK in
		the operating system's Print dialog box) before any subsequent calls
		to `PrintJob.addPage()` and `PrintJob.send()`:

		```haxe
		var myPrintJob = new PrintJob();
		if(myPrintJob.start()) {
			// addPage() and send() statements here
		}
		```

		For the given print job instance, if any of the following intervals
		last more than 15 seconds the next call to `PrintJob.start()` will
		return `false`:

		* `PrintJob.start()` and the first `PrintJob.addPage()`
		* One `PrintJob.addPage()` and the next `PrintJob.addPage()`
		* The last `PrintJob.addPage()` and `PrintJob.send()`

		@return A value of `true` if the user clicks OK when the Print dialog
				box appears; `false` if the user clicks Cancel or if an error
				occurs.
		@throws IllegalOperationError in AIR 2 or later, if another PrintJob
									  is currently active
	**/
	public function start():Bool
	{
		if (isSupported)
		{
			__started = true;
			__bitmapData = new Array();

			return true;
		}

		return false;
	}
}
#else
typedef PrintJob = flash.printing.PrintJob;
#end
