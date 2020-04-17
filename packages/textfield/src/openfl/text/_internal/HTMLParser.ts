import TextFormatRange from "../../../_internal/text/TextFormatRange";
import TextFormat from "../../../text/TextFormat";
import Vector from "../../../Vector";

export default class HTMLParser
{
	private static __regexAlign: RegExp = /align\s?=\s?("([^"]+)"|'([^']+)')/i;
	private static __regexBreakTag: RegExp = /<br\s*\/?>/gi;
	private static __regexBlockIndent: RegExp = /blockindent\s?=\s?("([^"]+)"|'([^']+)')/i;
	private static __regexColor: RegExp = /color\s?=\s?("#([^"]+)"|'#([^']+)')/i;
	private static __regexEntities: Array<RegExp> = [/&quot;/g, /&apos;/g, /&amp;/g, /&lt;/g, /&gt;/g, /&nbsp;/g];
	private static __regexFace: RegExp = /face\s?=\s?("([^"]+)"|'([^']+)')/i;
	private static __regexHTMLTag: RegExp = /<.*?>/g;
	private static __regexHref: RegExp = /href\s?=\s?("([^"]+)"|'([^']+)')/i;
	private static __regexIndent: RegExp = / indent\s?=\s?("([^"]+)"|'([^']+)')/i;
	private static __regexLeading: RegExp = /leading\s?=\s?("([^"]+)"|'([^']+)')/i;
	private static __regexLeftMargin: RegExp = /leftmargin\s?=\s?("([^"]+)"|'([^']+)')/i;
	private static __regexRightMargin: RegExp = /rightmargin\s?=\s?("([^"]+)"|'([^']+)')/i;
	private static __regexSize: RegExp = /size\s?=\s?("([^"]+)"|'([^']+)')/i;
	private static __regexTabStops: RegExp = /tabstops\s?=\s?("([^"]+)"|'([^']+)')/i;

	public static parse(value: string, textFormat: TextFormat, textFormatRanges: Vector<TextFormatRange>): string
	{
		value = value.replace(this.__regexBreakTag, "\n");
		value = value.replace(this.__regexEntities[0], "\"");
		value = value.replace(this.__regexEntities[1], "'");
		value = value.replace(this.__regexEntities[2], "&");
		value = value.replace(this.__regexEntities[5], " ");

		// crude solution

		var segments = value.split("<");

		if (segments.length == 1)
		{
			value = value.replace(this.__regexHTMLTag, "");

			if (textFormatRanges.length > 1)
			{
				textFormatRanges.splice(1, textFormatRanges.length - 1);
			}

			value = value.replace(this.__regexEntities[3], "<");
			value = value.replace(this.__regexEntities[4], ">");

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

			for (let i = 0; i < segments.length; i++)
			{
				segment = segments[i];
				segment = segment.replace(this.__regexEntities[3], "<");
				segment = segment.replace(this.__regexEntities[4], ">");
				segments[i] = segment;
			}

			var formatStack = [textFormat.clone()];
			var tagStack = [];
			var sub: string;
			var noLineBreak = false;

			for (let segment of segments)
			{
				if (segment == "") continue;

				var isClosingTag = segment.substr(0, 1) == "/";
				var tagEndIndex = segment.indexOf(">");
				var start = tagEndIndex + 1;
				var spaceIndex = segment.indexOf(" ");
				var tagName = segment.substring(isClosingTag ? 1 : 0, spaceIndex > -1
					&& spaceIndex < tagEndIndex ? spaceIndex : tagEndIndex);
				var format: TextFormat;

				if (isClosingTag)
				{
					if (tagStack.length == 0 || tagName.toLowerCase() != tagStack[tagStack.length - 1].toLowerCase())
					{
						console.info("Invalid HTML, unexpected closing tag ignored: " + tagName);
						continue;
					}

					tagStack.pop();
					formatStack.pop();
					format = formatStack[formatStack.length - 1].clone();

					if (tagName.toLowerCase() == "p" && textFormatRanges.length > 0)
					{
						value += "\n";
						noLineBreak = true;
						textFormatRanges[textFormatRanges.length - 1].end++;
					}

					if (start < segment.length)
					{
						sub = segment.substr(start);
						textFormatRanges.push(new TextFormatRange(format, value.length, value.length + sub.length));
						value += sub;
						noLineBreak = false;
					}
				}
				else
				{
					format = formatStack[formatStack.length - 1].clone();
					var result = null;

					if (tagEndIndex > -1)
					{
						switch (tagName.toLowerCase())
						{
							case "a":
								result = this.__getAttributeMatch(this.__regexHref, segment);
								if (result != null)
								{
									format.url = result;
								}
								break;

							case "p":
								if (textFormatRanges.length > 0 && !noLineBreak)
								{
									value += "\n";
								}

								result = this.__getAttributeMatch(this.__regexAlign, segment);
								if (result != null)
								{
									format.align = result.toLowerCase();
								}
								break;

							case "font":
								result = this.__getAttributeMatch(this.__regexFace, segment);
								if (result != null)
								{
									format.font = result;
								}

								result = this.__getAttributeMatch(this.__regexColor, segment);
								if (result != null)
								{
									format.color = Math.round(parseFloat(("0x" + result)));
								}

								result = this.__getAttributeMatch(this.__regexSize, segment);
								if (result != null)
								{
									var firstChar = result.charCodeAt(0);

									if (firstChar == "+".charCodeAt(0) || firstChar == "-".charCodeAt(0))
									{
										var parentFormat = (formatStack.length >= 2) ? formatStack[formatStack.length - 2] : textFormat;
										format.size = parentFormat.size + Math.round(parseFloat((result)));
									}
									else
									{
										format.size = Math.round(parseFloat(result));
									}
								}
								break;

							case "b":
								format.bold = true;
								break;

							case "u":
								format.underline = true;
								break;

							case "i":
							case "em":
								format.italic = true;
								break;

							case "textformat":
								result = this.__getAttributeMatch(this.__regexBlockIndent, segment);
								if (result != null)
								{
									format.blockIndent = Math.round(parseFloat(result));
								}

								result = this.__getAttributeMatch(this.__regexIndent, segment);
								if (result != null)
								{
									format.indent = Math.round(parseFloat(result));
								}

								result = this.__getAttributeMatch(this.__regexLeading, segment);
								if (result != null)
								{
									format.leading = Math.round(parseFloat(result));
								}

								result = this.__getAttributeMatch(this.__regexLeftMargin, segment);
								if (result != null)
								{
									format.leftMargin = Math.round(parseFloat(result));
								}

								result = this.__getAttributeMatch(this.__regexRightMargin, segment);
								if (result != null)
								{
									format.rightMargin = Math.round(parseFloat(result));
								}

								result = this.__getAttributeMatch(this.__regexTabStops, segment);
								if (result != null)
								{
									var values = result.split(" ");
									var tabStops = [];

									for (let stop of values)
									{
										tabStops.push(Math.round(parseFloat(stop)));
									}

									format.tabStops = tabStops;
								}
								break;
						}

						formatStack.push(format);
						tagStack.push(tagName);

						if (start < segment.length)
						{
							sub = segment.substring(start);
							textFormatRanges.push(new TextFormatRange(format, value.length, value.length + sub.length));
							value += sub;
							noLineBreak = false;
						}
					}
					else
					{
						textFormatRanges.push(new TextFormatRange(format, value.length, value.length + segment.length));
						value += segment;
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

	private static __getAttributeMatch(regex: RegExp, segment: string): string
	{
		var result = regex.exec(segment);
		if (result != null)
		{
			return result[2] != null ? result[2] : result[3];
		}
		return null;
	}
}
