package openfl.fl.containers;

import openfl.fl.containers.BaseScrollPane;
import xfl.XFLSymbolArguments;
import xfl.XFLAssets;

/**
 * Base scroll pane
 */
class ScrollPane extends BaseScrollPane
{
	/**
	 * Public constructor
	**/
	public function new(name:String = null, xflSymbolArguments:XFLSymbolArguments = null)
	{
		super(name, xflSymbolArguments != null ? xflSymbolArguments : XFLAssets.getInstance().createXFLSymbolArguments("fl.containers.ScrollPane"));
	}
}
