package openfl.fl.controls;

import openfl._internal.formats.xfl.XFLSymbolArguments;
import openfl._internal.formats.xfl.XFLAssets;

/**
 * UI scroll bar
 */
class UIScrollBar extends ScrollBar
{
	public function new(name:String = null, xflSymbolArguments:XFLSymbolArguments = null)
	{
		super(name, xflSymbolArguments != null ? xflSymbolArguments : XFLAssets.getInstance().createXFLSymbolArguments("fl.controls.UIScrollBar"));
	}
}
