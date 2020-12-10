package openfl.fl.core;

import openfl.display.DisplayObject;
import openfl._internal.formats.xfl.display.XFLSprite;
import openfl._internal.formats.xfl.XFLSymbolArguments;
import openfl._internal.formats.xfl.dom.DOMTimeline;

/**
 * UI component
 */
class UIComponent extends XFLSprite
{
	public var disabled(get, set):Bool;
	public var enabled(get, set):Bool;

	private var _disabled:Bool;
	private var _originalWidth:Float;
	private var _originalHeight:Float;
	private var _width:Float;
	private var _height:Float;
	private var _scrolling:Bool;
	private var _scrollY:Float;
	private var styles:Map<String, Dynamic>;

	public function new(name:String, xlfSymbolArguments:XFLSymbolArguments = null)
	{
		super(xlfSymbolArguments);

		// defaults
		_disabled = false;
		styles = new Map<String, Dynamic>();

		// determine from component avarar if we have any
		if (getXFLDisplayObject("Component_avatar") == null)
		{
			_originalWidth = 0.0;
			_originalHeight = 0.0;
			_width = 0.0;
			_height = 0.0;
		}
		else
		{
			_originalWidth = getXFLDisplayObject("Component_avatar").width;
			_originalHeight = getXFLDisplayObject("Component_avatar").height;
			_width = _originalWidth;
			_height = _originalHeight;
			// remove component avatar
			removeChild(getXFLDisplayObject("Component_avatar"));
		}

		// determine focus rect skin, its not supported yet
		if (getXFLDisplayObject("focusRectSkin") != null) removeChild(getXFLDisplayObject("focusRectSkin"));
	}

	public function get_disabled():Bool
	{
		return _disabled;
	}

	public function set_disabled(_disabled:Bool):Bool
	{
		return this._disabled = _disabled;
	}

	public function get_enabled():Bool
	{
		return _disabled == false;
	}

	public function set_enabled(_enabled:Bool):Bool
	{
		this.disabled = _enabled == false;
		return enabled;
	}

	#if flash
	@:getter(scaleX) public function get_scaleX():Float
	{
		return 1.0;
	}

	@:setter(scaleX) public function set_scaleX(_scaleX:Float):Void
	{
		setSize(_originalWidth * _scaleX, _height);
	}

	@:getter(scaleY) public function get_scaleY():Float
	{
		return 1.0;
	}

	@:setter(scaleY) function set_scaleY(_scaleY:Float):Void
	{
		setSize(_width, _originalHeight * _scaleY);
	}

	@:getter(width) public function get_width():Float
	{
		return _width;
	}

	@:setter(width) public function set_width(_width:Float)
	{
		setSize(_width, _height);
	}

	@:getter(height) public function get_height():Float
	{
		return _height;
	}

	@:setter(height) public function set_height(_height:Float)
	{
		setSize(_width, _height);
	}
	#else
	public override function get_scaleX():Float
	{
		return 1.0;
	}

	public override function set_scaleX(_scaleX:Float):Float
	{
		setSize(_originalWidth * _scaleX, _height);
		return 1.0;
	}

	public override function get_scaleY():Float
	{
		return 1.0;
	}

	public override function set_scaleY(_scaleY:Float):Float
	{
		setSize(_width, _originalHeight * _scaleY);
		return 1.0;
	}

	public override function get_width():Float
	{
		return _width;
	}

	public override function set_width(_width:Float):Float
	{
		setSize(_width, _height);
		return _width;
	}

	public override function get_height():Float
	{
		return _height;
	}

	public override function set_height(_height:Float):Float
	{
		setSize(_width, _height);
		return _height;
	}
	#end

	private function draw():Void {}

	public function drawFocus(draw:Bool):Void {}

	public function getStyle(style:String):Dynamic
	{
		return styles.get(style);
	}

	public function setStyle(style:String, value:Dynamic):Void
	{
		if ((value is DisplayObject) == true && cast(value, DisplayObject).parent != null)
		{
			cast(value, DisplayObject).parent.removeChild(value);
		}
		styles.set(style, value);
		draw();
	}

	public function setSize(_width:Float, _height:Float):Void
	{
		this._width = _width;
		this._height = _height;
	}

	public function validateNow():Void
	{
		setSize(_width, _height);
	}
}
