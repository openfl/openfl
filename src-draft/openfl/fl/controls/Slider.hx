package openfl.fl.controls;

import openfl.fl.core.UIComponent;
import openfl._internal.formats.xfl.display.XFLMovieClip;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl._internal.formats.xfl.XFLSymbolArguments;
import openfl._internal.formats.xfl.XFLAssets;
import openfl._internal.formats.xfl.dom.DOMTimeline;

/**
 * Slider
 */
class Slider extends UIComponent
{
	public var direction:String;
	public var maximum(default, set):Float = 100.0;
	public var minimum(default, set):Float = 0.0;
	public var value(get, set):Float;
	public var snapInterval(default, set):Float = 1.0;
	public var liveDragging:Bool = false;
	public var tickInterval:Float = 0.0;

	private var state:String = "up";
	private var _value:Float = 0.0;

	public function new(name:String = null, xflSymbolArguments:XFLSymbolArguments = null)
	{
		super(name, xflSymbolArguments != null ? xflSymbolArguments : XFLAssets.getInstance().createXFLSymbolArguments("fl.controls.Slider"));
		if (disabled == false)
		{
			addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
		}
		getXFLMovieClip("SliderTrack_skin").mouseChildren = false;
		getXFLMovieClip("SliderTrack_skin").x = 0.0;
		getXFLMovieClip("SliderTrack_skin").y = 0.0;
		getXFLMovieClip("SliderTrack_skin").width = width;
		getXFLMovieClip("SliderTrack_skin").visible = true;
		getXFLMovieClip("SliderTrack_disabledSkin").mouseChildren = false;
		getXFLMovieClip("SliderTrack_disabledSkin").x = 0.0;
		getXFLMovieClip("SliderTrack_disabledSkin").y = 0.0;
		getXFLMovieClip("SliderTrack_disabledSkin").width = width;
		getXFLMovieClip("SliderTrack_disabledSkin").visible = false;
		getXFLMovieClip("SliderTick_skin").mouseChildren = false;
		getXFLMovieClip("SliderTick_skin").x = 0.0;
		getXFLMovieClip("SliderTick_skin").y = 0.0;
		getXFLMovieClip("SliderThumb_upSkin").mouseChildren = false;
		getXFLMovieClip("SliderThumb_upSkin").x = 0.0;
		getXFLMovieClip("SliderThumb_upSkin").y = 0.0;
		getXFLMovieClip("SliderThumb_overSkin").mouseChildren = false;
		getXFLMovieClip("SliderThumb_overSkin").x = 0.0;
		getXFLMovieClip("SliderThumb_overSkin").y = 0.0;
		getXFLMovieClip("SliderThumb_downSkin").mouseChildren = false;
		getXFLMovieClip("SliderThumb_downSkin").x = 0.0;
		getXFLMovieClip("SliderThumb_downSkin").y = 0.0;
		getXFLMovieClip("SliderThumb_disabledSkin").mouseChildren = false;
		getXFLMovieClip("SliderThumb_disabledSkin").x = 0.0;
		getXFLMovieClip("SliderThumb_disabledSkin").y = 0.0;
		setState(disabled == true ? "disabled" : "up");
	}

	override public function set_disabled(_disabled:Bool):Bool
	{
		if (disabled == false)
		{
			removeEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
			openfl.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseEventMove);
			openfl.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseEventMove);
		}
		super.disabled = _disabled;
		if (_disabled == false)
		{
			addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
			setState("up");
		}
		else
		{
			setState("disabled");
		}
		return super.disabled;
	}

	override public function setSize(_width:Float, _height:Float)
	{
		super.setSize(_width, _height);
		getXFLMovieClip("SliderTrack_skin").width = width;
		getXFLMovieClip("SliderTrack_disabledSkin").width = width;
	}

	private function setState(state:String)
	{
		getXFLMovieClip("SliderTrack_skin").visible = disabled == false;
		getXFLMovieClip("SliderTrack_disabledSkin").visible = disabled == true;
		getXFLMovieClip("SliderThumb_" + this.state + "Skin").visible = false;
		this.state = state;
		var sliderRange:Float = maximum - minimum;
		getXFLMovieClip("SliderThumb_" + this.state + "Skin").x = getXFLMovieClip("SliderTrack_skin")
			.x + (sliderRange < 0.00001 ? 0.0 : ((value - minimum) / sliderRange) * getXFLMovieClip("SliderTrack_skin").width);
		getXFLMovieClip("SliderThumb_" + this.state + "Skin").visible = true;
		getXFLMovieClip("SliderTick_skin").x = getXFLMovieClip("SliderTrack_skin")
			.x + (((value - minimum) / (maximum - minimum)) * getXFLMovieClip("SliderTrack_skin").width);
	}

	private function onMouseEvent(event:MouseEvent):Void
	{
		if (parent == null) return;
		var newState:String = "up";
		switch (event.type)
		{
			case MouseEvent.MOUSE_OVER:
				newState = "over";
			case MouseEvent.MOUSE_DOWN:
				openfl.Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseEventMove);
				openfl.Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseEventMove);
				newState = "down";
			case MouseEvent.MOUSE_OUT:
				newState = "up";
			default:
				trace("onMouseEvent(): unsupported mouse event type '" + event.type + "'");
		}
		setState(newState);
	}

	private function onMouseEventMove(event:MouseEvent):Void
	{
		if (parent == null)
		{
			openfl.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseEventMove);
			openfl.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseEventMove);
			return;
		}
		switch (event.type)
		{
			case MouseEvent.MOUSE_UP:
				openfl.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseEventMove);
				openfl.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseEventMove);
				setState("up");
			case MouseEvent.MOUSE_MOVE:
				var mouseLocalX:Float = getXFLMovieClip("SliderTrack_skin").globalToLocal(new Point(event.stageX, event.stageY))
					.x * getXFLMovieClip("SliderTrack_skin")
					.scaleX;
				setValueInternal(minimum + ((mouseLocalX / getXFLMovieClip("SliderTrack_skin").width) * (maximum - minimum)), true);
			default:
				trace("onMouseEventMove(): unsupported mouse event type '" + event.type + "'");
		}
	}

	private function set_minimum(newValue:Float):Float
	{
		minimum = newValue;
		if (minimum > maximum)
		{
			minimum = maximum;
		}
		if (value < minimum)
		{
			setValueInternal(minimum, true);
		}
		return minimum;
	}

	private function set_maximum(newValue:Float):Float
	{
		maximum = newValue;
		if (maximum < minimum)
		{
			maximum = minimum;
		}
		if (value > maximum)
		{
			setValueInternal(maximum, true);
		}
		return maximum;
	}

	private function setValueInternal(newValue:Float, dispatchChangeEvent:Bool):Void
	{
		_value = Std.int(newValue + (snapInterval / 2.0) * (1.0 / snapInterval)) / snapInterval;
		if (_value < minimum)
		{
			_value = minimum;
		}
		if (_value > maximum)
		{
			_value = maximum;
		}
		if (Math.abs(newValue - value) > 0.01 && dispatchChangeEvent == true)
		{
			dispatchEvent(new Event(Event.CHANGE));
		}
		setState(state);
	}

	private function get_value():Float
	{
		return _value;
	}

	private function set_value(newValue:Float):Float
	{
		setValueInternal(newValue, true);
		return value;
	}

	private function set_snapInterval(newValue:Float):Float
	{
		if (newValue < 0.001)
		{
			trace("set_snapInterval(): invalid value: " + newValue);
		}
		else
		{
			snapInterval = newValue;
			setState(state);
		}
		return snapInterval;
	}
}
