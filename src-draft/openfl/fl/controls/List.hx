package openfl.fl.controls;

import xfl.XFLSymbolArguments;
import xfl.XFLAssets;
import openfl.fl.core.UIComponent;
import openfl.fl.controls.SelectableList;

/**
 * List
 */
class List extends SelectableList
{
	public function new(name:String = null, xflSymbolArguments:XFLSymbolArguments = null)
	{
		super(name, xflSymbolArguments != null ? xflSymbolArguments : XFLAssets.getInstance().createXFLSymbolArguments("fl.controls.List"));
	}
}
