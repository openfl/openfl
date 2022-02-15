package test;

import openfl.display.Sprite;
import openfl.text.StyleSheet;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.utils.Object;

class StyleSheetTest1 extends FunctionalTest
{
	public function new()
	{
		super();
	}

	public override function start():Void
	{
		content = new Sprite();

		var text = "<span class='defaultStyle'><h1><b>HTML</b> Text <i>(sample <u>header</u>)</i></h1>Here is some <em>sample</em> <strong>html text</strong> "
			+ "filling a text box <a href='http://www.openfl.org'>this link to openfl.org</a> and example headers"
			+
			"<br><br><br><h1>Header h1</h1><h2>Header h2</h2><br><br><br>Hello world<br><br><br><redText>This text <i>will be red</i></redText><br><br><h1><span class='typewriter'>typewriter</span></h1></span>";

		var style = new Object();
		style.fontFamily = "_sans";

		var stylesheet = new StyleSheet();
		stylesheet.setStyle("body", {fontSize: '15', color: '#000066'});
		stylesheet.setStyle("h1", {fontSize: '32', color: '#000000'});
		stylesheet.setStyle("h2", {fontSize: '19', color: '#000000'});
		stylesheet.setStyle("a:link", {color: '#0000CC', textDecoration: 'none'});
		stylesheet.setStyle("a:hover", {color: '#0000FF', textDecoration: 'underline'});
		stylesheet.setStyle("b", {fontWeight: 'bold'});
		stylesheet.setStyle("em", {fontWeight: 'bold'});
		stylesheet.setStyle(".defaultStyle", style);
		stylesheet.setStyle(".typewriter", {fontFamily: "_typewriter"});
		stylesheet.setStyle("redText", {color: '#FF0000'});

		var textField = new TextField();
		textField.width = 500;
		textField.multiline = true;
		textField.styleSheet = stylesheet;
		textField.htmlText = text;
		textField.autoSize = TextFieldAutoSize.LEFT;
		textField.wordWrap = true;
		textField.border = true;

		content.addChild(textField);
	}

	public override function stop():Void
	{
		content = null;
	}
}
