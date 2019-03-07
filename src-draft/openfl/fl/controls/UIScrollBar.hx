package openfl.fl.controls;

import xfl.XFLSymbolArguments;
import xfl.XFLAssets;

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
