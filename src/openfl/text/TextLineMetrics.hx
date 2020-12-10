package openfl.text;

#if !flash
/**
	The TextLineMetrics class contains information about the text position and
	measurements of a _line of text_ within a text field. All measurements are
	in pixels. Objects of this class are returned by the
	`openfl.text.TextField.getLineMetrics()` method.
	For measurements related to the text field containing the line of text
	(for example, the "Text Field height" measurement in the diagram), see
	openfl.text.TextField.

	The following diagram indicates the points and measurements of a text
	field and the line of text the field contains:

	![An image illustrating text metrics](/images/text-metrics.jpg)
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class TextLineMetrics
{
	/**
		The ascent value of the text is the length from the baseline to the
		top of the line height in pixels. See the "Ascent" measurement in the
		overview diagram for this class.
	**/
	public var ascent:Float;

	/**
		The descent value of the text is the length from the baseline to the
		bottom depth of the line in pixels. See the "Descent" measurement in
		the overview diagram for this class.
	**/
	public var descent:Float;

	/**
		The height value of the text of the selected lines (not necessarily
		the complete text) in pixels. The height of the text line does not
		include the gutter height. See the "Line height" measurement in the
		overview diagram for this class.
	**/
	public var height:Float;

	/**
		The leading value is the measurement of the vertical distance between
		the lines of text. See the "Leading" measurement in the overview
		diagram for this class.
	**/
	public var leading:Float;

	/**
		The width value is the width of the text of the selected lines (not
		necessarily the complete text) in pixels. The width of the text line
		is not the same as the width of the text field. The width of the text
		line is relative to the text field width, minus the gutter width of 4
		pixels (2 pixels on each side). See the "Text Line width" measurement
		in the overview diagram for this class.
	**/
	public var width:Float;

	/**
		The x value is the left position of the first character in pixels.
		This value includes the margin, indent (if any), and gutter widths.
		See the "Text Line x-position" in the overview diagram for this class.
	**/
	public var x:Float;

	/**
		Creates a TextLineMetrics object. The TextLineMetrics object contains
		information about the text metrics of a line of text in a text field.
		Objects of this class are returned by the
		openfl.text.TextField.getLineMetrics() method.

		@param x           The left position of the first character in pixels.
		@param width       The width of the text of the selected lines (not
						   necessarily the complete text) in pixels.
		@param height      The height of the text of the selected lines (not
						   necessarily the complete text) in pixels.
		@param ascent      The length from the baseline to the top of the line
						   height in pixels.
		@param descent     The length from the baseline to the bottom depth of
						   the line in pixels.
		@param leading     The measurement of the vertical distance between the
						   lines of text.
	**/
	public function new(x:Float, width:Float, height:Float, ascent:Float, descent:Float, leading:Float)
	{
		this.x = x;
		this.width = width;
		this.height = height;
		this.ascent = ascent;
		this.descent = descent;
		this.leading = leading;
	}
}
#else
typedef TextLineMetrics = flash.text.TextLineMetrics;
#end
