package test;

import haxe.Timer;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.text.AntiAliasType;
import openfl.text.GridFitType;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.utils.Assets;

/**
 * Class: WordWrapTest1
 *
 *
 * This test renders a word wrapped html text and resizes the window to
 * demonstrate how the word wrapping is adjusted.
 *
 */
class WordWrapTest1 extends FunctionalTest
{
	private static var bgData:BitmapData;
	private static var maxWidth:Float;
	private static var textField:TextField;
	private static var textWidth:Int;
	private static var widthInc:Int;

	public function new()
	{
		super();
	}

	public override function start():Void
	{content = new Sprite();

		textWidth = 300;
		widthInc = 5;

		var normalTextFormat = new TextFormat("_sans", 28, 0, true);
		normalTextFormat.align = TextFormatAlign.LEFT;

		var boldTextFormat = new TextFormat("_sans", 28, 0, true);
		boldTextFormat.align = TextFormatAlign.LEFT;
		boldTextFormat.color = 0xFF8D4C;

		textField = new TextField();
		textField.antiAliasType = AntiAliasType.ADVANCED;
		textField.gridFitType = GridFitType.SUBPIXEL;
		textField.defaultTextFormat = normalTextFormat;
		textField.x = 100;
		textField.y = 100;
		textField.width = textWidth;
		textField.height = contentHeight - 2 * textField.y;
		textField.textColor = 0xe8c343;
		textField.multiline = true;
		textField.wordWrap = true;
		textField.border = true;
		textField.borderColor = 0xe8c343;

		// Compose HTML text including some words in Unicode to ensure that
		// word wrapping works properly for them.  Unfortunately, it is
		// difficult to find a font that can display 4 byte Unicode
		// characters, so those will just show up as boxes, but should at
		// least wrap properly.

		// 2 byte UTF-8 chars
		var word1 = (String.fromCharCode(0xC2) + String.fromCharCode(0xC7) + String.fromCharCode(0xD0) + String.fromCharCode(0xD2));

		// 3 byte UTF-8 chars
		var word2 = (String.fromCharCode(0x920) + String.fromCharCode(0x960) + String.fromCharCode(0x9E0) + String.fromCharCode(0x9F0));

		// 4 byte UTF-8 chars
		var word3 = (String.fromCharCode(0x10300) + String.fromCharCode(0x10301) + String.fromCharCode(0x10302) + String.fromCharCode(0x10303));

		// Mixed
		var word4 = (String.fromCharCode(0xC2) + String.fromCharCode(0x10301) + "a" + String.fromCharCode(0x9F0) + String.fromCharCode(0xD2) + "b"
			+ String.fromCharCode(0x10303) + String.fromCharCode(0x960));

		textField.htmlText = "Here is some UTF-8: " /*+ word1 + " " +
			word2 + " " + word3 + " " + word4 */
		+ "angelo <i>Ephesi ecclesiae</i> scribe haec dicit qui tenet septem "
		+ "<b>stellas</b> in dextera sua qui ambulat in medio septem "
		+ "candelabrorum aureorum scio <u>opera tua et laborem</u> et "
		+ "<br>&lt; (less than), &gt; (greater than), &amp; "
		+ "(ampersand), &quot; (double quote), &apos; (apostrophe), "
		+ "&lt;&gt;&amp;&quot;&apos; (all)"
		+ "patientiam <font size=\"+10\">tuam et quia</font> nom potes "
		+ "<font size=\"-6\" color=\"#123456\">sustinere malos</font> et "
		+ "temptasti eos qui se dicunt apostolos et non sunt et "
		+ "invenisti eos mendaces et patientiam habes et sustinuisti "
		+ "propter nomen meum et non defecisti sed habeo adversus te <p><p>"
		+ "quod caritatem tuam primam reliquisti memor esto itaque "
		+ "unde excideris et age paenitentiam et prima opera fac sin "
		+ "autem venio tibi et movebo candelabrum tuum de loco suo nisi "
		+ "paenitentiam egeris sed hoc habes quia odisti facta "
		+ "Nicolaitarum quae et ego odi qui habet aurem audiat quid "
		+ "Spiritus dicat ecclesiis vincenti dabo ei edere de ligno "
		+ "vitae quod est in paradiso Dei mei";

		content.addChild(textField);

		maxWidth = contentWidth - textField.x - textField.x;

		content.addEventListener(Event.ENTER_FRAME, update);
	}

	public override function stop():Void
	{
		content.addEventListener(Event.ENTER_FRAME, update);
		content = null;
	}

	private function update(e:Event):Void
	{
		var timeNow = Timer.stamp();

		textWidth += widthInc;
		if ((textWidth <= 5) || (textWidth >= maxWidth))
		{
			widthInc = -widthInc;
		}
		textField.width = textWidth;
	}
}
