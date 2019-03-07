package xfl;

import openfl._internal.formats.xfl.dom.DOMTimeline;

class XFLSymbolArguments
{
	public var xfl(get, never):XFL;
	public var name(get, never):String;
	public var timeline(get, never):DOMTimeline;
	public var parametersAreLocked(get, never):Bool;

	private var _xfl:XFL;
	private var _name:String;
	private var _timeline:DOMTimeline;
	private var _parametersAreLocked:Bool;

	public function new(xfl:XFL, name:String, timeline:DOMTimeline, parametersAreLocked:Bool)
	{
		this._xfl = xfl;
		this._name = name;
		this._timeline = timeline;
		this._parametersAreLocked = parametersAreLocked;
	}

	public function get_xfl():XFL
	{
		return _xfl;
	}

	public function get_name():String
	{
		return _name;
	}

	public function get_timeline():DOMTimeline
	{
		return _timeline;
	}

	public function get_parametersAreLocked():Bool
	{
		return _parametersAreLocked;
	}
}
