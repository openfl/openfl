import * as internal from "../../_internal/utils/InternalAccess";
import Rectangle from "../../geom/Rectangle";
import AntiAliasType from "../../text/AntiAliasType";
import Font from "../../text/Font";
import GridFitType from "../../text/GridFitType";
import TextField from "../../text/TextField";
import TextFieldAutoSize from "../../text/TextFieldAutoSize";
import TextFieldType from "../../text/TextFieldType";
import TextFormat from "../../text/TextFormat";
import TextFormatAlign from "../../text/TextFormatAlign";
import Vector from "../../Vector";
import TextFormatRange from "./TextFormatRange";
import TextLayoutGroup from "./TextLayoutGroup";

export default class TextEngine
{
	private static readonly UTF8_TAB: number = 9;
	private static readonly UTF8_ENDLINE: number = 10;
	private static readonly UTF8_SPACE: number = 32;
	private static readonly UTF8_HYPHEN: number = 0x2D;
	private static readonly GUTTER: number = 2;
	private static __defaultFonts: Map<string, Font> = new Map();
	private static __context: CanvasRenderingContext2D;

	public antiAliasType: AntiAliasType;
	public autoSize: TextFieldAutoSize;
	public background: boolean;
	public backgroundColor: number;
	public border: boolean;
	public borderColor: number;

	public bounds: Rectangle;
	public caretIndex: number;
	public embedFonts: boolean;
	public gridFitType: GridFitType;
	public height: number;
	public layoutGroups: Vector<TextLayoutGroup>;
	public lineAscents: Vector<number>;
	public lineBreaks: Vector<number>;
	public lineDescents: Vector<number>;
	public lineLeadings: Vector<number>;
	public lineHeights: Vector<number>;
	public lineWidths: Vector<number>;
	public maxChars: number;
	public multiline: boolean;
	public scrollH: number;
	public selectable: boolean;
	public sharpness: number;
	public textBounds: Rectangle;
	public textHeight: number;
	public textFormatRanges: Vector<TextFormatRange>;
	public textWidth: number;
	public type: TextFieldType;
	public width: number;
	public wordWrap: boolean;

	private textField: TextField;

	protected __bottomScrollV: number;
	protected __cursorTimerID: number;
	public __hasFocus: boolean;
	protected __isKeyDown: boolean;
	protected __maxScrollH: number;
	protected __maxScrollV: number;
	public __measuredHeight: number;
	public __measuredWidth: number;
	protected __numLines: number;
	protected __restrict: string;
	protected __restrictRegexp: RegExp;
	protected __selectionStart: number;
	protected __scrollV: number;
	protected __showCursor: boolean;
	protected __text: string;
	protected __textFormat: TextFormat;
	protected __texture: WebGLTexture;
	// protected __tileData:Map<Tilesheet, Array<number>>;
	// protected __tileDataLength:Map<Tilesheet, Int>;
	// protected __tilesheets:Map<Tilesheet, Bool>;
	public __useIntAdvances: null | boolean;

	public __cairoFont: any;
	/** @hidden */ public __font: Font;

	public constructor(textField: TextField)
	{
		this.textField = textField;

		this.width = 100;
		this.height = 100;
		this.text = "";

		this.bounds = new Rectangle(0, 0, 0, 0);
		this.textBounds = new Rectangle(0, 0, 0, 0);

		this.type = TextFieldType.DYNAMIC;
		this.autoSize = TextFieldAutoSize.NONE;
		this.embedFonts = false;
		this.selectable = true;
		this.borderColor = 0x000000;
		this.border = false;
		this.backgroundColor = 0xffffff;
		this.background = false;
		this.gridFitType = GridFitType.PIXEL;
		this.maxChars = 0;
		this.multiline = false;
		this.__numLines = 1;
		this.sharpness = 0;
		this.scrollH = 0;
		this.scrollV = 1;
		this.wordWrap = false;

		this.lineAscents = new Vector();
		this.lineBreaks = new Vector();
		this.lineDescents = new Vector();
		this.lineLeadings = new Vector();
		this.lineHeights = new Vector();
		this.lineWidths = new Vector();
		this.layoutGroups = new Vector();
		this.textFormatRanges = new Vector();

		if (TextEngine.__context == null)
		{
			TextEngine.__context = document.createElement("canvas").getContext("2d");
		}
	}

	private createRestrictRegexp(restrict: string): RegExp
	{
		var declinedRange = /\^(.-.|.)/gu;
		var declined = "";

		var result = declinedRange.exec(restrict);
		if (result != null)
		{
			restrict = restrict.replace(declinedRange, "");
			for (let i = 0; i < result.length; i++)
			{
				declined += result[i];
			}
		}

		var testRegexpParts: Array<string> = [];

		if (restrict.length > 0)
		{
			testRegexpParts.push(`[^${restrict}]`);
		}

		if (declined.length > 0)
		{
			testRegexpParts.push(`[${declined}]`);
		}

		return new RegExp(`(${testRegexpParts.join(' | ')})`, "g");
	}

	private static findFont(name: string): Font
	{
		return (<internal.Font><any>Font).__fontByName.get(name);
	}

	private static findFontVariant(format: TextFormat): Font
	{
		var fontName = format.font;
		var bold = format.bold;
		var italic = format.italic;

		if (fontName == null) fontName = "_serif";
		var fontNamePrefix = fontName.replace(" Normal", "").replace(" Regular", "");

		if (bold && italic && (<internal.Font><any>Font).__fontByName.has(fontNamePrefix + " Bold Italic"))
		{
			return this.findFont(fontNamePrefix + " Bold Italic");
		}
		else if (bold && (<internal.Font><any>Font).__fontByName.has(fontNamePrefix + " Bold"))
		{
			return this.findFont(fontNamePrefix + " Bold");
		}
		else if (italic && (<internal.Font><any>Font).__fontByName.has(fontNamePrefix + " Italic"))
		{
			return this.findFont(fontNamePrefix + " Italic");
		}

		return this.findFont(fontName);
	}

	public getBounds(): void
	{
		var padding = this.border ? 1 : 0;

		this.bounds.width = this.width + padding;
		this.bounds.height = this.height + padding;

		var x = this.width, y = this.width;

		for (let group of this.layoutGroups)
		{
			if (group.offsetX < x) x = group.offsetX;
			if (group.offsetY < y) y = group.offsetY;
		}

		if (x >= this.width) x = TextEngine.GUTTER;
		if (y >= this.height) y = TextEngine.GUTTER;

		var textHeight = textHeight * 1.185; // measurement isn't always accurate, add padding

		this.textBounds.setTo(Math.max(x - TextEngine.GUTTER, 0), Math.max(y - TextEngine.GUTTER, 0), Math.min(this.textWidth + TextEngine.GUTTER * 2, this.bounds.width + TextEngine.GUTTER * 2),
			Math.min(textHeight + TextEngine.GUTTER * 2, this.bounds.height + TextEngine.GUTTER * 2));
	}

	public static getFormatHeight(format: TextFormat): number
	{
		var ascent: number, descent: number, leading: number;

		this.__context.font = this.getFont(format);

		var font = this.getFontInstance(format);

		if ((<internal.TextFormat><any>format).__ascent != null)
		{
			ascent = format.size * (<internal.TextFormat><any>format).__ascent;
			descent = format.size * (<internal.TextFormat><any>format).__descent;
		}
		else if (font != null && font.unitsPerEM != 0)
		{
			ascent = (font.ascender / font.unitsPerEM) * format.size;
			descent = Math.abs((font.descender / font.unitsPerEM) * format.size);
		}
		else
		{
			ascent = format.size;
			descent = format.size * 0.185;
		}

		leading = format.leading;

		return ascent + descent + leading;
	}

	public static getFont(format: TextFormat): string
	{
		var fontName = format.font;
		var bold = format.bold;
		var italic = format.italic;

		if (fontName == null) fontName = "_serif";
		var fontNamePrefix = fontName.replace(" Normal", "").replace(" Regular", "");

		if (bold && italic && (<internal.Font><any>Font).__fontByName.has(fontNamePrefix + " Bold Italic"))
		{
			fontName = fontNamePrefix + " Bold Italic";
			bold = false;
			italic = false;
		}
		else if (bold && (<internal.Font><any>Font).__fontByName.has(fontNamePrefix + " Bold"))
		{
			fontName = fontNamePrefix + " Bold";
			bold = false;
		}
		else if (italic && (<internal.Font><any>Font).__fontByName.has(fontNamePrefix + " Italic"))
		{
			fontName = fontNamePrefix + " Italic";
			italic = false;
		}
		else
		{
			// Prevent "extra" bold and italic fonts

			if (bold && (fontName.indexOf(" Bold ") > -1 || fontName.endsWith(" Bold")))
			{
				bold = false;
			}

			if (italic && (fontName.indexOf(" Italic ") > -1 || fontName.endsWith(" Italic")))
			{
				italic = false;
			}
		}

		var font = italic ? "italic " : "normal ";
		font += "normal ";
		font += bold ? "bold " : "normal ";
		font += format.size + "px";
		font += "/" + (format.leading + format.size + 3) + "px ";

		switch (fontName)
		{
			case "_sans":
				font += "sans-serif";
				break;
			case "_serif":
				font += "serif";
				break;
			case "_typewriter":
				font += "monospace";
				break;
			default:
				font += "'" + fontName.replace(/^[\s'"]+(.*)[\s'"]+$/, '$1') + "'";
				break;
		}

		return font;
	}

	public static getFontInstance(format: TextFormat): Font
	{
		return this.findFontVariant(format);
	}

	public getLine(index: number): string
	{
		if (index < 0 || index > this.lineBreaks.length + 1)
		{
			return null;
		}

		if (this.lineBreaks.length == 0)
		{
			return this.text;
		}
		else
		{
			return this.text.substring(index > 0 ? this.lineBreaks[index - 1] : 0, this.lineBreaks[index]);
		}
	}

	public getLineBreakIndex(startIndex: number = 0): number
	{
		var cr = this.text.indexOf("\n", startIndex);
		var lf = this.text.indexOf("\r", startIndex);

		if (cr == -1) return lf;
		if (lf == -1) return cr;
		return cr < lf ? cr : lf;
	}

	private getLineMeasurements(): void
	{
		this.lineAscents.length = 0;
		this.lineDescents.length = 0;
		this.lineLeadings.length = 0;
		this.lineHeights.length = 0;
		this.lineWidths.length = 0;

		var currentLineAscent = 0.0;
		var currentLineDescent = 0.0;
		var currentLineLeading: null | number = null;
		var currentLineHeight = 0.0;
		var currentLineWidth = 0.0;
		var currentTextHeight = 0.0;

		this.textWidth = 0;
		this.textHeight = 0;
		this.__numLines = 1;
		this.__maxScrollH = 0;

		for (let group of this.layoutGroups)
		{
			while (group.lineIndex > this.numLines - 1)
			{
				this.lineAscents.push(currentLineAscent);
				this.lineDescents.push(currentLineDescent);
				this.lineLeadings.push(currentLineLeading != null ? currentLineLeading : 0);
				this.lineHeights.push(currentLineHeight);
				this.lineWidths.push(currentLineWidth);

				currentLineAscent = 0;
				currentLineDescent = 0;
				currentLineLeading = null;
				currentLineHeight = 0;
				currentLineWidth = 0;

				this.__numLines++;
			}

			currentLineAscent = Math.max(currentLineAscent, group.ascent);
			currentLineDescent = Math.max(currentLineDescent, group.descent);

			if (currentLineLeading == null)
			{
				currentLineLeading = group.leading;
			}
			else
			{
				currentLineLeading = Math.max(currentLineLeading, group.leading);
			}

			currentLineHeight = Math.max(currentLineHeight, group.height);
			currentLineWidth = Math.max(currentLineWidth, group.offsetX - TextEngine.GUTTER + group.width);

			// TODO: confirm whether textWidth ignores margins, indents, etc or not
			// currently they are not ignored, and setTextAlignment() happens to work due to this (gut feeling is that it does ignore them)
			if (currentLineWidth > this.textWidth)
			{
				this.textWidth = currentLineWidth;
			}

			currentTextHeight = group.offsetY - TextEngine.GUTTER + group.ascent + group.descent;

			if (currentTextHeight > this.textHeight)
			{
				this.textHeight = currentTextHeight;
			}
		}

		if (this.textHeight == 0 && this.textField != null && this.textField.type == TextFieldType.INPUT)
		{
			var currentFormat = (<internal.TextField><any>this.textField).__textFormat;
			var ascent, descent, leading, heightValue;

			var font = TextEngine.getFontInstance(currentFormat);

			if ((<internal.TextFormat><any>currentFormat).__ascent != null)
			{
				ascent = currentFormat.size * (<internal.TextFormat><any>currentFormat).__ascent;
				descent = currentFormat.size * (<internal.TextFormat><any>currentFormat).__descent;
			}
			else if (font != null && font.unitsPerEM != 0)
			{
				ascent = (font.ascender / font.unitsPerEM) * currentFormat.size;
				descent = Math.abs((font.descender / font.unitsPerEM) * currentFormat.size);
			}
			else
			{
				ascent = currentFormat.size;
				descent = currentFormat.size * 0.185;
			}

			leading = currentFormat.leading;

			heightValue = ascent + descent + leading;

			currentLineAscent = ascent;
			currentLineDescent = descent;
			currentLineLeading = leading;

			// TODO : numbereger line heights/text heights
			currentTextHeight = ascent + descent;
			this.textHeight = currentTextHeight;
		}

		this.lineAscents.push(currentLineAscent);
		this.lineDescents.push(currentLineDescent);
		this.lineLeadings.push(currentLineLeading != null ? currentLineLeading : 0);
		this.lineHeights.push(currentLineHeight);
		this.lineWidths.push(currentLineWidth);

		if (this.numLines == 1)
		{
			if (currentLineLeading > 0)
			{
				this.textHeight += currentLineLeading;
			}
		}

		if (this.layoutGroups.length > 0)
		{
			var group = this.layoutGroups[this.layoutGroups.length - 1];

			if (group != null && group.startIndex == group.endIndex)
			{
				this.textHeight -= currentLineHeight;
			}
		}

		if (this.autoSize != TextFieldAutoSize.NONE)
		{
			switch (this.autoSize)
			{
				case TextFieldAutoSize.LEFT:
				case TextFieldAutoSize.RIGHT:
				case TextFieldAutoSize.CENTER:
					if (!this.wordWrap /*&& (width < textWidth + GUTTER * 2)*/)
					{
						this.width = this.textWidth + TextEngine.GUTTER * 2;
					}

					this.height = this.textHeight + TextEngine.GUTTER * 2;
					// bottomScrollV = numLines;
					break;

				default:
			}
		}

		// TODO: see if margins and stuff affect this
		if (this.textWidth > this.width - TextEngine.GUTTER * 2)
		{
			this.__maxScrollH = Math.floor(this.textWidth - this.width + TextEngine.GUTTER * 2);
		}
		else
		{
			this.__maxScrollH = 0;
		}

		if (this.scrollH > this.maxScrollH) this.scrollH = this.maxScrollH;

		this.updateScrollV();
	}

	private getLayoutGroups(): void
	{
		this.layoutGroups.length = 0;

		if (this.text == null || this.text == "") return;

		let rangeIndex = -1;
		let formatRange: TextFormatRange = null;
		let font = null;

		let currentFormat = (<internal.TextField><any>TextField).__defaultTextFormat.clone();

		// line metrics
		let leading = 0; // TODO: is maxLeading needed, just like with ascent? In case multiple formats in the same line have different leading values
		let ascent = 0.0, maxAscent = 0.0;
		let descent = 0.0;

		// paragraph metrics
		let align = null;
		align = TextFormatAlign.LEFT;
		let blockIndent = 0;
		let bullet = false;
		let indent = 0;
		let leftMargin = 0;
		let rightMargin = 0;
		let firstLineOfParagraph = true;

		let tabStops = null; // TODO: maybe there's a better init value (not sure what this actually is)

		let layoutGroup: TextLayoutGroup = null, positions = null;
		let widthValue = 0.0, heightValue = 0, maxHeightValue = 0;
		let previousSpaceIndex = -2; // -1 equals not found, -2 saves extra comparison in `breakIndex == previousSpaceIndex`
		let previousBreakIndex = -1;
		let spaceIndex = this.text.indexOf(" ");
		let breakIndex = this.getLineBreakIndex();

		let offsetX = 0.0;
		let offsetY = 0.0;
		let textIndex = 0;
		let lineIndex = 0;

		var getPositions = (text: string, startIndex: number, endIndex: number): Array<number> =>
		{
			// TODO: optimize

			var positions = [];
			var letterSpacing = 0.0;

			if (formatRange.format.letterSpacing != null)
			{
				letterSpacing = formatRange.format.letterSpacing;
			}

			if (this.__useIntAdvances == null)
			{
				this.__useIntAdvances = /Trident\/7.0/.test(navigator.userAgent); // IE
			}

			if (this.__useIntAdvances)
			{
				// slower, but more accurate if browser returns Int measurements

				var previousWidth = 0.0;
				var width;

				for (let i = startIndex; i < endIndex; i++)
				{
					width = TextEngine.__context.measureText(text.substring(startIndex, i + 1)).width;
					// if (i > 0) width += letterSpacing;

					positions.push(width - previousWidth);

					previousWidth = width;
				}
			}
			else
			{
				for (let i = startIndex; i < endIndex; i++)
				{
					var advance;

					if (i < this.text.length - 1)
					{
						// Advance can be less for certain letter combinations, e.g. 'Yo' vs. 'Do'
						var nextWidth = TextEngine.__context.measureText(text.charAt(i + 1)).width;
						var twoWidths = TextEngine.__context.measureText(text.substr(i, 2)).width;
						advance = twoWidths - nextWidth;
					}
					else
					{
						advance = TextEngine.__context.measureText(text.charAt(i)).width;
					}

					// if (i > 0) advance += letterSpacing;

					positions.push(advance);
				}
			}

			return positions;
		}

		var getPositionsWidth = (positions: Array<number>): number =>
		{
			var width = 0.0;

			for (let position of positions)
			{
				width += position;
			}

			return width;
		}

		var getTextWidth = (text: string): number =>
		{
			return TextEngine.__context.measureText(text).width;
		}

		var getBaseX = (): number =>
		{
			// TODO: swap margins in RTL
			return TextEngine.GUTTER + leftMargin + blockIndent + (firstLineOfParagraph ? indent : 0);
		}

		var getWrapWidth = (): number =>
		{
			// TODO: swap margins in RTL
			return this.width - TextEngine.GUTTER - rightMargin - getBaseX();
		}

		var nextLayoutGroup = (startIndex, endIndex): void =>
		{
			if (layoutGroup == null || layoutGroup.startIndex != layoutGroup.endIndex)
			{
				layoutGroup = new TextLayoutGroup(formatRange.format, startIndex, endIndex);
				this.layoutGroups.push(layoutGroup);
			}
			else
			{
				layoutGroup.format = formatRange.format;
				layoutGroup.startIndex = startIndex;
				layoutGroup.endIndex = endIndex;
			}
		}

		var setLineMetrics = (): void =>
		{
			if ((<internal.TextFormat><any>currentFormat).__ascent != null)
			{
				ascent = currentFormat.size * (<internal.TextFormat><any>currentFormat).__ascent;
				descent = currentFormat.size * (<internal.TextFormat><any>currentFormat).__descent;
			}
			else if (font != null && font.unitsPerEM != 0)
			{
				ascent = (font.ascender / font.unitsPerEM) * currentFormat.size;
				descent = Math.abs((font.descender / font.unitsPerEM) * currentFormat.size);
			}
			else
			{
				ascent = currentFormat.size;
				descent = currentFormat.size * 0.185;
			}

			leading = currentFormat.leading;

			heightValue = Math.ceil(ascent + descent + leading);

			if (heightValue > maxHeightValue)
			{
				maxHeightValue = heightValue;
			}

			if (ascent > maxAscent)
			{
				maxAscent = ascent;
			}
		}

		var setParagraphMetrics = (): void =>
		{
			firstLineOfParagraph = true;

			align = currentFormat.align != null ? currentFormat.align : TextFormatAlign.LEFT;
			blockIndent = currentFormat.blockIndent != null ? currentFormat.blockIndent : 0;

			if (currentFormat.bullet != null)
			{
				// TODO
			}

			indent = currentFormat.indent != null ? currentFormat.indent : 0;
			leftMargin = currentFormat.leftMargin != null ? currentFormat.leftMargin : 0;
			rightMargin = currentFormat.rightMargin != null ? currentFormat.rightMargin : 0;

			if (currentFormat.tabStops != null)
			{
				// TODO, may not actually belong in paragraph metrics
			}
		}

		var nextFormatRange = (): boolean =>
		{
			if (rangeIndex < this.textFormatRanges.length - 1)
			{
				rangeIndex++;
				formatRange = this.textFormatRanges[rangeIndex];
				(<internal.TextFormat><any>currentFormat).__merge(formatRange.format);

				TextEngine.__context.font = TextEngine.getFont(currentFormat);

				font = TextEngine.getFontInstance(currentFormat);

				return true;
			}

			return false;
		}

		var setFormattedPositions = (startIndex: number, endIndex: number) =>
		{
			// sets the positions of the text from start to end, including format changes if there are any
			if (startIndex >= endIndex)
			{
				positions = [];
				widthValue = 0;
			}
			else if (endIndex <= formatRange.end)
			{
				positions = getPositions(this.text, startIndex, endIndex);
				widthValue = getPositionsWidth(positions);
			}
			else
			{
				var tempIndex = startIndex;
				var tempRangeEnd = formatRange.end;
				var countRanges = 0;

				positions = [];
				widthValue = 0;

				while (true)
				{
					if (tempIndex != tempRangeEnd)
					{
						var tempPositions = getPositions(this.text, tempIndex, tempRangeEnd);
						positions = positions.concat(tempPositions);
					}

					if (tempRangeEnd != endIndex)
					{
						if (!nextFormatRange())
						{
							console.warn("You found a bug in OpenFL's text code! Please save a copy of your project and contact Joshua Granick (@singmajesty) so we can fix this.");
							break;
						}

						tempIndex = tempRangeEnd;
						tempRangeEnd = endIndex < formatRange.end ? endIndex : formatRange.end;

						countRanges++;
					}
					else
					{
						widthValue = getPositionsWidth(positions);
						break;
					}
				}

				rangeIndex -= countRanges + 1;
				nextFormatRange(); // get back to the formatRange and font
			}
		}

		var placeFormattedText = (endIndex: number): void =>
		{
			if (endIndex <= formatRange.end)
			{
				// don't worry about placing multiple formats if a space or break happens first

				positions = getPositions(this.text, textIndex, endIndex);
				widthValue = getPositionsWidth(positions);

				nextLayoutGroup(textIndex, endIndex);

				layoutGroup.positions = positions;
				layoutGroup.offsetX = offsetX + getBaseX();
				layoutGroup.ascent = ascent;
				layoutGroup.descent = descent;
				layoutGroup.leading = leading;
				layoutGroup.lineIndex = lineIndex;
				layoutGroup.offsetY = offsetY + TextEngine.GUTTER;
				layoutGroup.width = widthValue;
				layoutGroup.height = heightValue;

				offsetX += widthValue;

				if (endIndex == formatRange.end)
				{
					layoutGroup = null;
					nextFormatRange();
					setLineMetrics();
				}
			}
			else
			{
				// fill in all text from start to end, including any format changes

				while (true)
				{
					var tempRangeEnd = endIndex < formatRange.end ? endIndex : formatRange.end;

					if (textIndex != tempRangeEnd)
					{
						positions = getPositions(this.text, textIndex, tempRangeEnd);
						widthValue = getPositionsWidth(positions);

						nextLayoutGroup(textIndex, tempRangeEnd);

						layoutGroup.positions = positions;
						layoutGroup.offsetX = offsetX + getBaseX();
						layoutGroup.ascent = ascent;
						layoutGroup.descent = descent;
						layoutGroup.leading = leading;
						layoutGroup.lineIndex = lineIndex;
						layoutGroup.offsetY = offsetY + TextEngine.GUTTER;
						layoutGroup.width = widthValue;
						layoutGroup.height = heightValue;

						offsetX += widthValue;

						textIndex = tempRangeEnd;
					}

					if (tempRangeEnd == formatRange.end) layoutGroup = null;

					if (tempRangeEnd == endIndex) break;

					if (!nextFormatRange())
					{
						console.warn("You found a bug in OpenFL's text code! Please save a copy of your project and contact Joshua Granick (@singmajesty) so we can fix this.");
						break;
					}

					setLineMetrics();
				}
			}

			textIndex = endIndex;
		}

		var alignBaseline = (): void =>
		{
			// aligns the baselines of all characters in a single line

			setLineMetrics();

			var i = this.layoutGroups.length;

			while (--i > -1)
			{
				var lg = this.layoutGroups[i];

				if (lg.lineIndex < lineIndex) break;
				if (lg.lineIndex > lineIndex) continue;

				lg.ascent = maxAscent;
				lg.height = maxHeightValue;
			}

			offsetY += maxHeightValue;

			maxAscent = 0.0;
			maxHeightValue = 0;

			++lineIndex;
			offsetX = 0;

			firstLineOfParagraph = false; // TODO: need to thoroughly test this
		}

		var breakLongWords = (endIndex: number): void =>
		{
			// breaks up words that are too long to fit in a single line

			var remainingPositions = positions;
			var i, bufferCount, placeIndex, positionWidth;
			var currentPosition;

			var tempWidth = getPositionsWidth(remainingPositions);

			while (remainingPositions.length > 0 && offsetX + tempWidth > getWrapWidth())
			{
				i = bufferCount = 0;
				positionWidth = 0.0;

				while (offsetX + positionWidth < getWrapWidth())
				{
					currentPosition = remainingPositions[i];

					if (currentPosition == 0.0)
					{
						// skip Unicode character buffer positions
						i++;
						bufferCount++;
					}
					else
					{
						positionWidth += currentPosition;
						i++;
					}
				}

				// if there's no room to put even a single character, automatically wrap the next character
				if (i == bufferCount)
				{
					i = bufferCount + 1;
				}
				else
				{
					// remove characters until the text fits one line
					// because of combining letters potentially being broken up now, we have to redo the formatted positions each time
					// TODO: this may not work exactly with Unicode buffer characters...
					// TODO: maybe assume no combining letters, then compare result to i+1 and i-1 results?
					while (i > 1 && offsetX + positionWidth > getWrapWidth())
					{
						i--;

						if (i - bufferCount > 0)
						{
							setFormattedPositions(textIndex, textIndex + i - bufferCount);
							positionWidth = widthValue;
						}
						else
						{
							// TODO: does this run anymore?

							i = 1;
							bufferCount = 0;

							setFormattedPositions(textIndex, textIndex + 1);
							positionWidth = 0; // breaks out of the loops
						}
					}
				}

				placeIndex = textIndex + i - bufferCount;
				placeFormattedText(placeIndex);
				alignBaseline();

				setFormattedPositions(placeIndex, endIndex);

				remainingPositions = positions;
				tempWidth = widthValue;
			}

			// positions only contains the final unbroken line at the end
		}

		var placeText = (endIndex: number): void =>
		{
			if (this.width >= TextEngine.GUTTER * 2 && this.wordWrap)
			{
				breakLongWords(endIndex);
			}

			placeFormattedText(endIndex);
		}

		nextFormatRange();
		setParagraphMetrics();
		setLineMetrics();

		var wrap;
		var maxLoops = this.text.length + 1;
		// Do an extra iteration to ensure a LayoutGroup is created in case the last line is empty (trailing line break).

		while (textIndex < maxLoops)
		{
			if ((breakIndex > -1) && (spaceIndex == -1 || breakIndex < spaceIndex))
			{
				// if a line break is the next thing that needs to be dealt with
				// TODO: when is this condition ever false?
				if (textIndex <= breakIndex)
				{
					setFormattedPositions(textIndex, breakIndex);
					placeText(breakIndex);

					layoutGroup = null;
				}
				else if (layoutGroup != null && layoutGroup.startIndex != layoutGroup.endIndex)
				{
					// Trim the last space from the line width, for correct TextFormatAlign.RIGHT alignment
					if (layoutGroup.endIndex == spaceIndex)
					{
						layoutGroup.width -= layoutGroup.getAdvance(layoutGroup.positions.length - 1);
					}

					layoutGroup = null;
				}

				alignBaseline();

				// TODO: is this necessary or already handled by placeText above?
				// TODO: what happens if the \n is formatted differently from the previous and next text?
				if (formatRange.end == breakIndex || formatRange.end == breakIndex + 1)
				{
					nextFormatRange();
					setLineMetrics();
				}

				textIndex = breakIndex + 1;
				previousBreakIndex = breakIndex;
				breakIndex = this.getLineBreakIndex(textIndex);

				setParagraphMetrics();
			}
			else if (spaceIndex > -1)
			{
				// if a space is the next thing that needs to be dealt with

				if (layoutGroup != null && layoutGroup.startIndex != layoutGroup.endIndex)
				{
					layoutGroup = null;
				}

				wrap = false;

				while (true)
				{
					if (textIndex >= this.text.length) break;

					var endIndex = -1;

					if (spaceIndex == -1)
					{
						endIndex = breakIndex;
					}
					else
					{
						endIndex = spaceIndex + 1;

						if (breakIndex > -1 && breakIndex < endIndex)
						{
							endIndex = breakIndex;
						}
					}

					if (endIndex == -1)
					{
						endIndex = this.text.length;
					}

					setFormattedPositions(textIndex, endIndex);

					if (align == TextFormatAlign.JUSTIFY)
					{
						if (positions.length > 0 && textIndex == previousSpaceIndex)
						{
							// Trim left space of this word
							textIndex++;

							var spaceWidth = positions.shift();
							widthValue -= spaceWidth;
							offsetX += spaceWidth;
						}

						if (positions.length > 0 && endIndex == spaceIndex + 1)
						{
							// Trim right space of this word
							endIndex--;

							var spaceWidth = positions.pop();
							widthValue -= spaceWidth;
						}
					}

					if (this.wordWrap)
					{
						if (offsetX + widthValue > getWrapWidth())
						{
							wrap = true;

							if (positions.length > 0 && endIndex == spaceIndex + 1)
							{
								// if last letter is a space, avoid word wrap if possible
								// TODO: Handle multiple spaces

								var lastPosition = positions[positions.length - 1];
								var spaceWidth = lastPosition;

								if (offsetX + widthValue - spaceWidth <= getWrapWidth())
								{
									wrap = false;
								}
							}
						}
					}

					if (wrap)
					{
						if (align != TextFormatAlign.JUSTIFY && (layoutGroup != null || this.layoutGroups.length > 0))
						{
							var previous = layoutGroup;
							if (previous == null)
							{
								previous = this.layoutGroups[this.layoutGroups.length - 1];
							}

							// For correct selection rectangles and alignment, trim the trailing space of the previous line:
							previous.width -= previous.getAdvance(previous.positions.length - 1);
							previous.endIndex--;
						}

						var i = this.layoutGroups.length - 1;
						var offsetCount = 0;

						while (true)
						{
							layoutGroup = this.layoutGroups[i];

							if (i > 0 && layoutGroup.startIndex > previousSpaceIndex)
							{
								offsetCount++;
							}
							else
							{
								break;
							}

							i--;
						}

						if (textIndex == previousSpaceIndex + 1)
						{
							alignBaseline();
						}

						offsetX = 0;

						if (offsetCount > 0)
						{
							var bumpX = this.layoutGroups[this.layoutGroups.length - offsetCount].offsetX;

							for (let i = (this.layoutGroups.length - offsetCount); i < this.layoutGroups.length; i++)
							{
								layoutGroup = this.layoutGroups[i];
								layoutGroup.offsetX -= bumpX;
								layoutGroup.offsetY = offsetY + TextEngine.GUTTER;
								layoutGroup.lineIndex = lineIndex;
								offsetX += layoutGroup.width;
							}
						}

						placeText(endIndex);

						wrap = false;
					}
					else
					{
						if (layoutGroup != null && textIndex == spaceIndex)
						{
							// TODO: does this case ever happen?
							if (align != TextFormatAlign.JUSTIFY)
							{
								layoutGroup.endIndex = spaceIndex;
								layoutGroup.positions = layoutGroup.positions.concat(positions);
								layoutGroup.width += widthValue;
							}

							offsetX += widthValue;

							textIndex = endIndex;
						}
						else if (layoutGroup == null || align == TextFormatAlign.JUSTIFY)
						{
							placeText(endIndex);
						}
						else
						{
							var tempRangeEnd = endIndex < formatRange.end ? endIndex : formatRange.end;

							if (tempRangeEnd < endIndex)
							{
								positions = getPositions(this.text, textIndex, tempRangeEnd);
								widthValue = getPositionsWidth(positions);
							}

							layoutGroup.endIndex = tempRangeEnd;
							layoutGroup.positions = layoutGroup.positions.concat(positions);
							layoutGroup.width += widthValue;

							offsetX += widthValue;

							if (tempRangeEnd == formatRange.end)
							{
								layoutGroup = null;
								nextFormatRange();
								setLineMetrics();

								textIndex = tempRangeEnd;

								if (tempRangeEnd != endIndex)
								{
									placeFormattedText(endIndex);
								}
							}

							// If next char is newline, process it immediately and prevent useless extra layout groups
							// TODO: is this needed?
							if (breakIndex == endIndex) endIndex++;

							textIndex = endIndex;

							if (endIndex == this.text.length) alignBaseline();
						}
					}

					var nextSpaceIndex = this.text.indexOf(" ", textIndex);

					// Check if we can continue wrapping this line until the next line-break or end-of-String.
					// When `previousSpaceIndex == breakIndex`, the loop has finished growing layoutGroup.endIndex until the end of this line.

					if (breakIndex == previousSpaceIndex)
					{
						layoutGroup.endIndex = breakIndex;

						if (breakIndex - layoutGroup.startIndex - layoutGroup.positions.length < 0)
						{
							// Newline has no size
							layoutGroup.positions.push(0.0);
						}

						textIndex = breakIndex + 1;
					}

					previousSpaceIndex = spaceIndex;
					spaceIndex = nextSpaceIndex;

					if ((breakIndex > -1 && breakIndex <= textIndex && (spaceIndex > breakIndex || spaceIndex == -1))
						|| textIndex > this.text.length)
					{
						break;
					}
				}
			}
			else
			{
				if (textIndex < this.text.length)
				{
					// if there are no line breaks or spaces to deal with next, place all remaining text

					setFormattedPositions(textIndex, this.text.length);
					placeText(this.text.length);

					alignBaseline();
				}

				textIndex++;
			}
		}

		// if final char is a line break, create an empty layoutGroup for it
		if (previousBreakIndex == textIndex - 2 && previousBreakIndex > -1)
		{
			nextLayoutGroup(textIndex, textIndex);

			layoutGroup.positions = [];
			layoutGroup.ascent = ascent;
			layoutGroup.descent = descent;
			layoutGroup.leading = leading;
			layoutGroup.lineIndex = lineIndex - 1;
			layoutGroup.offsetX = getBaseX(); // TODO: double check it doesn't default to GUTTER or something
			layoutGroup.offsetY = offsetY + TextEngine.GUTTER;
			layoutGroup.width = 0;
			layoutGroup.height = heightValue;
		}

		// 		#if openfl_trace_text_layout_groups
		// for (lg in layoutGroups)
		// {
		// 	Log.info('LG ${lg.positions.length - (lg.endIndex - lg.startIndex)},line:${lg.lineIndex},w:${lg.width},h:${lg.height},x:${Std.int(lg.offsetX)},y:${Std.int(lg.offsetY)},"${text.substring(lg.startIndex, lg.endIndex)}",${lg.startIndex},${lg.endIndex}');
		// }
		// 		#end
	}

	public restrictText(value: string): string
	{
		if (value == null)
		{
			return value;
		}

		if (this.__restrictRegexp != null)
		{
			value = value.split(this.__restrictRegexp).join("");
		}

		// if (maxChars > 0 && value.length > maxChars) {

		// 	value = value.substr (0, maxChars);

		// }

		return value;
	}

	private setTextAlignment(): void
	{
		var lineIndex = -1;
		var offsetX = 0.0;
		var totalWidth = this.width - TextEngine.GUTTER * 2; // TODO: do margins and stuff affect this at all?
		var group, lineLength;
		var lineMeasurementsDirty = false;

		for (let i = 0; i < this.layoutGroups.length; i++)
		{
			group = this.layoutGroups[i];

			if (group.lineIndex != lineIndex)
			{
				lineIndex = group.lineIndex;
				totalWidth = this.width - TextEngine.GUTTER * 2 - group.format.rightMargin;

				switch (group.format.align)
				{
					case TextFormatAlign.CENTER:
						if (this.lineWidths[lineIndex] < totalWidth)
						{
							offsetX = Math.round((totalWidth - this.lineWidths[lineIndex]) / 2);
						}
						else
						{
							offsetX = 0;
						}

					case TextFormatAlign.RIGHT:
						if (this.lineWidths[lineIndex] < totalWidth)
						{
							offsetX = Math.round(totalWidth - this.lineWidths[lineIndex]);
						}
						else
						{
							offsetX = 0;
						}

					case TextFormatAlign.JUSTIFY:
						if (this.lineWidths[lineIndex] < totalWidth)
						{
							lineLength = 1;

							for (let j = (i + 1); i < this.layoutGroups.length; i++)
							{
								if (this.layoutGroups[j].lineIndex == lineIndex)
								{
									if (j == 0 || this.text.charCodeAt(this.layoutGroups[j].startIndex - 1) == " ".charCodeAt(0))
									{
										lineLength++;
									}
								}
								else
								{
									break;
								}
							}

							if (lineLength > 1)
							{
								group = this.layoutGroups[i + lineLength - 1];

								var endChar = this.text.charCodeAt(group.endIndex);
								if (group.endIndex < this.text.length && endChar != "\n".charCodeAt(0) && endChar != "\r".charCodeAt(0))
								{
									offsetX = (totalWidth - this.lineWidths[lineIndex]) / (lineLength - 1);
									lineMeasurementsDirty = true;

									var j = 1;
									do
									{
										// if (text.charCodeAt (this.layoutGroups[j].startIndex - 1) != " ".code) {

										// 	layoutGroups[i + j].offsetX += (offsetX * (j-1));
										// 	j++;

										// }

										this.layoutGroups[i + j].offsetX += (offsetX * j);
									}
									while (++j < lineLength);
								}
							}
						}

						offsetX = 0;

					default:
						offsetX = 0;
				}
			}

			if (offsetX > 0)
			{
				group.offsetX += offsetX;
			}
		}

		if (lineMeasurementsDirty)
		{
			// TODO: Better way to fix justify textWidth?

			this.getLineMeasurements();
		}
	}

	public trimText(value: string): string
	{
		if (value == null)
		{
			return value;
		}

		if (this.maxChars > 0 && value.length > this.maxChars)
		{
			value = value.substr(0, this.maxChars);
		}

		return value;
	}

	public update(): void
	{
		if (this.text == null /*|| text == ""*/ || this.textFormatRanges.length == 0)
		{
			this.lineAscents.length = 0;
			this.lineBreaks.length = 0;
			this.lineDescents.length = 0;
			this.lineLeadings.length = 0;
			this.lineHeights.length = 0;
			this.lineWidths.length = 0;
			this.layoutGroups.length = 0;

			this.textWidth = 0;
			this.textHeight = 0;
			this.__numLines = 1;
			this.__maxScrollH = 0;
			// maxScrollV = 1;
			// bottomScrollV = 1;
			this.updateScrollV();
		}
		else
		{
			this.getLayoutGroups();
			this.getLineMeasurements();
			this.setTextAlignment();
		}

		this.getBounds();
	}

	private updateScrollV(): void
	{
		if (this.numLines == 1 || this.lineHeights == null)
		{
			this.__maxScrollV = 1;
		}
		else
		{
			var i = this.numLines - 1, tempHeight = 0.0;
			var j = i;

			while (i >= 0)
			{
				if (tempHeight + this.lineHeights[i] <= Math.ceil(this.height - TextEngine.GUTTER * 2))
				{
					tempHeight += this.lineHeights[i];
					i--;
				}
				else
				{
					break;
				}
			}

			if (i == j)
			{
				i = this.numLines; // maxScrollV defaults to numLines if the height - 4 is less than the line's height
				// TODO: check if it's based on the first or last line's height
			}
			else
			{
				i += 2;
			}

			if (i < 1)
			{
				this.__maxScrollV = 1;
			}
			else
			{
				this.__maxScrollV = i;
			}
		}

		if (this.numLines == 1 || this.lineHeights == null)
		{
			this.__bottomScrollV = 1;
		}
		else
		{
			var tempHeight = 0.0;
			var ret = this.__scrollV;

			while (ret <= this.lineHeights.length)
			{
				if (tempHeight + this.lineHeights[ret - 1] <= Math.ceil(this.height - TextEngine.GUTTER))
				{
					tempHeight += this.lineHeights[ret - 1];
				}
				else
				{
					break;
				}

				ret++;
			}

			this.__bottomScrollV = ret - 1;
		}
	}

	// Get & Set Methods

	public get bottomScrollV(): number
	{
		return this.__bottomScrollV;
	}

	public get maxScrollH(): number
	{
		return this.__maxScrollH;
	}

	public get maxScrollV(): number
	{
		return this.__maxScrollV;
	}

	public get numLines(): number
	{
		return this.__numLines;
	}

	public get restrict(): string
	{
		return this.__restrict;
	}

	public set restrict(value: string)
	{
		if (this.__restrict == value)
		{
			return;
		}

		this.__restrict = value;

		if (this.__restrict == null || this.__restrict.length == 0)
		{
			this.__restrictRegexp = null;
		}
		else
		{
			this.__restrictRegexp = this.createRestrictRegexp(value);
		}
	}

	public get scrollV(): number
	{
		if (this.__numLines == 1 || this.lineHeights == null) return 1;

		var max = this.__maxScrollV;
		if (this.__scrollV > max) return max;
		return this.__scrollV;
	}

	public set scrollV(value: number)
	{
		if (value < 1) value = 1;
		this.__scrollV = value;
		// TODO: Cheaper way to update bottomScrollV?
		this.updateScrollV();
	}

	public get text(): string
	{
		return this.__text;
	}

	public set text(value: string)
	{
		this.__text = value;
	}
}
