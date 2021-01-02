package openfl.text._internal;

import openfl.utils._internal.Log;
import openfl.text.TextFormat;
import openfl.Vector;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
class HTMLParser
{
	private static var __regexAlign:EReg = ~/align\s?=\s?("([^"]+)"|'([^']+)')/i;
	private static var __regexBreakTag:EReg = ~/<br\s*\/?>/gi;
	private static var __regexBlockIndent:EReg = ~/blockindent\s?=\s?("([^"]+)"|'([^']+)')/i;
	private static var __regexColor:EReg = ~/color\s?=\s?("#([^"]+)"|'#([^']+)')/i;
	private static var __regexEntities:Array<EReg> = [~/&quot;/g, ~/&apos;/g, ~/&amp;/g, ~/&lt;/g, ~/&gt;/g, ~/&nbsp;/g];
	private static var __regexFace:EReg = ~/face\s?=\s?("([^"]+)"|'([^']+)')/i;
	private static var __regexHTMLTag:EReg = ~/<.*?>/g;
	private static var __regexHref:EReg = ~/href\s?=\s?("([^"]+)"|'([^']+)')/i;
	private static var __regexIndent:EReg = ~/ indent\s?=\s?("([^"]+)"|'([^']+)')/i;
	private static var __regexLeading:EReg = ~/leading\s?=\s?("([^"]+)"|'([^']+)')/i;
	private static var __regexLeftMargin:EReg = ~/leftmargin\s?=\s?("([^"]+)"|'([^']+)')/i;
	private static var __regexRightMargin:EReg = ~/rightmargin\s?=\s?("([^"]+)"|'([^']+)')/i;
	private static var __regexSize:EReg = ~/size\s?=\s?("([^"]+)"|'([^']+)')/i;
	private static var __regexTabStops:EReg = ~/tabstops\s?=\s?("([^"]+)"|'([^']+)')/i;

	public static function parse(value:String, textFormat:TextFormat, textFormatRanges:Vector<TextFormatRange>):String
	{
		value = __regexBreakTag.replace(value, "\n");
		value = __regexEntities[5].replace(value, " ");

		// crude solution

		var segments = value.split("<");

		if (segments.length == 1)
		{
			value = StringTools.htmlUnescape(__regexHTMLTag.replace(value, ""));

			if (textFormatRanges.length > 1)
			{
				textFormatRanges.splice(1, textFormatRanges.length - 1);
			}

			var range = textFormatRanges[0];
			range.format = textFormat;
			range.start = 0;
			range.end = value.length;

			return value;
		}
		else
		{
			textFormatRanges.splice(0, textFormatRanges.length);

			value = "";
			var segment;

			var formatStack = [textFormat.clone()];
			var tagStack = [];
			var sub:String;
			var noLineBreak = false;

			for (segment in segments)
			{
				if (segment == "") continue;

				var isClosingTag = segment.substr(0, 1) == "/";
				var tagEndIndex = segment.indexOf(">");
				var start = tagEndIndex + 1;
				var spaceIndex = segment.indexOf(" ");
				var tagName = segment.substring(isClosingTag ? 1 : 0, spaceIndex > -1
					&& spaceIndex < tagEndIndex ? spaceIndex : tagEndIndex);
				var format:TextFormat;

				if (isClosingTag)
				{
					if (tagStack.length == 0 || tagName.toLowerCase() != tagStack[tagStack.length - 1].toLowerCase())
					{
						Log.info("Invalid HTML, unexpected closing tag ignored: " + tagName);
						continue;
					}

					tagStack.pop();
					formatStack.pop();
					format = formatStack[formatStack.length - 1].clone();

					if (tagName.toLowerCase() == "p" && textFormatRanges.length > 0)
					{
						value += "\n";
						noLineBreak = true;
					}

					if (start < segment.length)
					{
						sub = StringTools.htmlUnescape(segment.substr(start));
						textFormatRanges.push(new TextFormatRange(format, value.length, value.length + sub.length));
						value += sub;
						noLineBreak = false;
					}
				}
				else
				{
					format = formatStack[formatStack.length - 1].clone();

					if (tagEndIndex > -1)
					{
						switch (tagName.toLowerCase())
						{
							case "a":
								if (__regexHref.match(segment))
								{
									format.url = __getAttributeMatch(__regexHref);
								}

							case "p":
								if (textFormatRanges.length > 0 && !noLineBreak)
								{
									value += "\n";
								}

								if (__regexAlign.match(segment))
								{
									var align = __getAttributeMatch(__regexAlign).toLowerCase();
									format.align = align;
								}

							case "font":
								if (__regexFace.match(segment))
								{
									format.font = __getAttributeMatch(__regexFace);
								}

								if (__regexColor.match(segment))
								{
									format.color = Std.parseInt("0x" + __getAttributeMatch(__regexColor));
								}

								if (__regexSize.match(segment))
								{
									var sizeAttr = __getAttributeMatch(__regexSize);
									var firstChar = sizeAttr.charCodeAt(0);

									if (firstChar == "+".code || firstChar == "-".code)
									{
										var parentFormat = (formatStack.length >= 2) ? formatStack[formatStack.length - 2] : textFormat;
										format.size = parentFormat.size + Std.parseInt(sizeAttr);
									}
									else
									{
										format.size = Std.parseInt(sizeAttr);
									}
								}

							case "b":
								format.bold = true;

							case "u":
								format.underline = true;

							case "i", "em":
								format.italic = true;

							case "textformat":
								if (__regexBlockIndent.match(segment))
								{
									format.blockIndent = Std.parseInt(__getAttributeMatch(__regexBlockIndent));
								}

								if (__regexIndent.match(segment))
								{
									format.indent = Std.parseInt(__getAttributeMatch(__regexIndent));
								}

								if (__regexLeading.match(segment))
								{
									format.leading = Std.parseInt(__getAttributeMatch(__regexLeading));
								}

								if (__regexLeftMargin.match(segment))
								{
									format.leftMargin = Std.parseInt(__getAttributeMatch(__regexLeftMargin));
								}

								if (__regexRightMargin.match(segment))
								{
									format.rightMargin = Std.parseInt(__getAttributeMatch(__regexRightMargin));
								}

								if (__regexTabStops.match(segment))
								{
									var values = __getAttributeMatch(__regexTabStops).split(" ");
									var tabStops = [];

									for (stop in values)
									{
										tabStops.push(Std.parseInt(stop));
									}

									format.tabStops = tabStops;
								}
						}

						formatStack.push(format);
						tagStack.push(tagName);

						if (start < segment.length)
						{
							sub = StringTools.htmlUnescape(segment.substring(start));
							textFormatRanges.push(new TextFormatRange(format, value.length, value.length + sub.length));
							value += sub;
							noLineBreak = false;
						}
					}
					else
					{
						sub = StringTools.htmlUnescape(segment);
						textFormatRanges.push(new TextFormatRange(format, value.length, value.length + sub.length));
						value += sub;
						noLineBreak = false;
					}
				}
			}

			if (textFormatRanges.length == 0)
			{
				textFormatRanges.push(new TextFormatRange(formatStack[0], 0, 0));
			}
		}

		return value;
	}

	private static function __getAttributeMatch(regex:EReg):String
	{
		return regex.matched(2) != null ? regex.matched(2) : regex.matched(3);
	}
}
