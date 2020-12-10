package openfl.fl.controls;

import openfl._internal.formats.xfl.XFLSymbolArguments;
import openfl._internal.formats.xfl.XFLAssets;
import openfl._internal.formats.xfl.dom.DOMTimeline;
import openfl.fl.core.UIComponent;
import openfl.fl.data.DataProvider;
import openfl._internal.formats.xfl.display.XFLSprite;

/**
 * Combo box grid
 */
class ComboBox extends UIComponent
{
	public var selectedIndex:Int;
	public var dataProvider:DataProvider;
	public var selectedItem:Dynamic;

	public function new(name:String = null, xflSymbolArguments:XFLSymbolArguments = null)
	{
		super(name, xflSymbolArguments != null ? xflSymbolArguments : XFLAssets.getInstance().createXFLSymbolArguments("fl.controls.ComboBox"));
	}

	public function move(x:Int, y:Int):Void {}
}
