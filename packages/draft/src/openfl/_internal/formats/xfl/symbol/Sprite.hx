package openfl._internal.formats.xfl.symbol;

import openfl._internal.formats.xfl.dom.DOMLayer;
import openfl._internal.formats.xfl.dom.DOMTimeline;
import openfl._internal.formats.xfl.XFLSymbolArguments;
import openfl.display.DisplayObject;
import openfl.display.FrameLabel;

class Sprite extends openfl._internal.formats.xfl.display.Sprite
{
	public var children:Array<DisplayObject>;
	public var xflSymbolArguments(get, never):XFLSymbolArguments;

	private var _xflSymbolArguments:XFLSymbolArguments;

	public function new(xflSymbolArguments:XFLSymbolArguments = null)
	{
		super();
		this._xflSymbolArguments = xflSymbolArguments != null ? xflSymbolArguments : new XFLSymbolArguments(null, null, null, false);
		var labels:Array<FrameLabel> = [];
		var layers:Array<DOMLayer> = [];
		children = [];
		Shared.init(layers, this.xflSymbolArguments.timeline, labels);
		Shared.createFrames(this.xflSymbolArguments.xfl, this, layers, children);
		Shared.enableFrame(this.xflSymbolArguments.xfl, this, layers, 1, null);
	}

	public function get_xflSymbolArguments():XFLSymbolArguments
	{
		return _xflSymbolArguments;
	}

	public function flatten():Void
	{
		Shared.flatten(this);
	}
}
