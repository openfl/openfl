package openfl.fl.controls;

import openfl.fl.containers.BaseScrollPane;
import openfl.fl.core.UIComponent;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl._internal.formats.xfl.display.XFLMovieClip;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.fl.events.ScrollEvent;
import openfl.geom.Point;
import openfl._internal.formats.xfl.XFLSymbolArguments;
import openfl._internal.formats.xfl.XFLAssets;
import openfl._internal.formats.xfl.dom.DOMTimeline;

/**
 * Scroll bar
 */
class ScrollBar extends UIComponent
{
	public var scrollPosition(get, set):Float;
	public var minScrollPosition(get, set):Float;
	public var maxScrollPosition(get, set):Float;
	public var lineScrollSize:Float;
	public var pageScrollSize:Float;
	public var visibleScrollRange:Null<Float>;

	private var _scrollBarWidth:Float;
	private var scrollArrowUpHeight:Float;
	private var scrollArrowDownHeight:Float;
	private var scrollTrackHeight:Float;
	private var scrollThumbSkinHeight:Float;
	private var scrollThumbIconHeight:Float;
	private var _scrollPosition:Float;
	private var _minScrollPosition:Float;
	private var _maxScrollPosition:Float;
	private var scrollThumbState:String = "up";
	private var scrollArrowUpState:String = "up";
	private var scrollArrowDownState:String = "up";
	private var scrollThumbMouseMoveYRelative:Float;

	public function new(name:String = null, xflSymbolArguments:XFLSymbolArguments = null)
	{
		super(name, xflSymbolArguments != null ? xflSymbolArguments : XFLAssets.getInstance().createXFLSymbolArguments("fl.controls.ScrollBar"));
		lineScrollSize = 1;
		pageScrollSize = 10;
		visibleScrollRange = null;
		var scrollTrackSkinCount = 0;
		for (i in 0...numChildren)
		{
			if (getChildAt(i).name == "ScrollTrack_skin") scrollTrackSkinCount++;
		}
		for (i in 0...scrollTrackSkinCount - 1)
		{
			removeChild(getXFLMovieClip("ScrollTrack_skin"));
		}

		var tmp:Float = 0.0;
		width = getXFLMovieClip("ScrollTrack_skin").width;
		scrollArrowUpHeight = 0.0;
		scrollArrowUpHeight = (tmp = getXFLMovieClip("ScrollArrowUp_upSkin").height) > scrollArrowUpHeight ? tmp : scrollArrowUpHeight;
		scrollArrowUpHeight = (tmp = getXFLMovieClip("ScrollArrowUp_overSkin").height) > scrollArrowUpHeight ? tmp : scrollArrowUpHeight;
		scrollArrowUpHeight = (tmp = getXFLMovieClip("ScrollArrowUp_downSkin").height) > scrollArrowUpHeight ? tmp : scrollArrowUpHeight;
		scrollArrowUpHeight = (tmp = getXFLMovieClip("ScrollArrowUp_disabledSkin").height) > scrollArrowUpHeight ? tmp : scrollArrowUpHeight;
		scrollArrowDownHeight = 0.0;
		scrollArrowDownHeight = (tmp = getXFLMovieClip("ScrollArrowDown_upSkin").height) > scrollArrowDownHeight ? tmp : scrollArrowDownHeight;
		scrollArrowDownHeight = (tmp = getXFLMovieClip("ScrollArrowDown_overSkin").height) > scrollArrowDownHeight ? tmp : scrollArrowDownHeight;
		scrollArrowDownHeight = (tmp = getXFLMovieClip("ScrollArrowDown_downSkin").height) > scrollArrowDownHeight ? tmp : scrollArrowDownHeight;
		scrollArrowDownHeight = (tmp = getXFLMovieClip("ScrollArrowDown_disabledSkin").height) > scrollArrowDownHeight ? tmp : scrollArrowDownHeight;
		scrollThumbSkinHeight = 0.0;
		scrollThumbSkinHeight = (tmp = getXFLMovieClip("ScrollThumb_upSkin").height) > scrollThumbSkinHeight ? tmp : scrollThumbSkinHeight;
		scrollThumbSkinHeight = (tmp = getXFLMovieClip("ScrollThumb_overSkin").height) > scrollThumbSkinHeight ? tmp : scrollThumbSkinHeight;
		scrollThumbSkinHeight = (tmp = getXFLMovieClip("ScrollThumb_downSkin").height) > scrollThumbSkinHeight ? tmp : scrollThumbSkinHeight;
		scrollThumbIconHeight = getXFLMovieClip("ScrollBar_thumbIcon").height;
		scrollThumbMouseMoveYRelative = 0.0;

		getXFLMovieClip("ScrollTrack_skin").visible = true;
		getXFLMovieClip("ScrollTrack_skin").mouseChildren = false;
		getXFLMovieClip("ScrollThumb_upSkin").visible = false;
		getXFLMovieClip("ScrollThumb_upSkin").mouseChildren = false;
		getXFLMovieClip("ScrollThumb_overSkin").visible = false;
		getXFLMovieClip("ScrollThumb_overSkin").mouseChildren = false;
		getXFLMovieClip("ScrollThumb_downSkin").visible = false;
		getXFLMovieClip("ScrollThumb_downSkin").mouseChildren = false;
		getXFLMovieClip("ScrollArrowUp_upSkin").visible = false;
		getXFLMovieClip("ScrollArrowUp_upSkin").mouseChildren = false;
		getXFLMovieClip("ScrollArrowUp_overSkin").visible = false;
		getXFLMovieClip("ScrollArrowUp_overSkin").mouseChildren = false;
		getXFLMovieClip("ScrollArrowUp_downSkin").visible = false;
		getXFLMovieClip("ScrollArrowUp_downSkin").mouseChildren = false;
		getXFLMovieClip("ScrollArrowUp_disabledSkin").visible = false;
		getXFLMovieClip("ScrollArrowUp_disabledSkin").mouseChildren = false;
		getXFLMovieClip("ScrollArrowDown_upSkin").visible = false;
		getXFLMovieClip("ScrollArrowDown_upSkin").mouseChildren = false;
		getXFLMovieClip("ScrollArrowDown_overSkin").visible = false;
		getXFLMovieClip("ScrollArrowDown_overSkin").mouseChildren = false;
		getXFLMovieClip("ScrollArrowDown_downSkin").visible = false;
		getXFLMovieClip("ScrollArrowDown_downSkin").mouseChildren = false;
		getXFLMovieClip("ScrollArrowDown_disabledSkin").visible = false;
		getXFLMovieClip("ScrollArrowDown_disabledSkin").mouseChildren = false;

		getXFLMovieClip("ScrollBar_thumbIcon").visible = true;
		getXFLMovieClip("ScrollBar_thumbIcon").mouseEnabled = false;

		getXFLMovieClip("ScrollTrack_skin").addEventListener(MouseEvent.MOUSE_DOWN, onScrollTrackMouseDown);

		getXFLMovieClip("ScrollArrowUp_upSkin").addEventListener(MouseEvent.MOUSE_OVER, onScrollArrowMouseEvent);
		getXFLMovieClip("ScrollArrowUp_overSkin").addEventListener(MouseEvent.MOUSE_OVER, onScrollArrowMouseEvent);
		getXFLMovieClip("ScrollArrowUp_downSkin").addEventListener(MouseEvent.MOUSE_OVER, onScrollArrowMouseEvent);

		getXFLMovieClip("ScrollArrowDown_upSkin").addEventListener(MouseEvent.MOUSE_OVER, onScrollArrowMouseEvent);
		getXFLMovieClip("ScrollArrowDown_overSkin").addEventListener(MouseEvent.MOUSE_OVER, onScrollArrowMouseEvent);
		getXFLMovieClip("ScrollArrowDown_downSkin").addEventListener(MouseEvent.MOUSE_OVER, onScrollArrowMouseEvent);

		getXFLMovieClip("ScrollArrowUp_upSkin").addEventListener(MouseEvent.MOUSE_DOWN, onScrollArrowMouseEvent);
		getXFLMovieClip("ScrollArrowUp_overSkin").addEventListener(MouseEvent.MOUSE_DOWN, onScrollArrowMouseEvent);
		getXFLMovieClip("ScrollArrowUp_downSkin").addEventListener(MouseEvent.MOUSE_DOWN, onScrollArrowMouseEvent);

		getXFLMovieClip("ScrollArrowDown_upSkin").addEventListener(MouseEvent.MOUSE_DOWN, onScrollArrowMouseEvent);
		getXFLMovieClip("ScrollArrowDown_overSkin").addEventListener(MouseEvent.MOUSE_DOWN, onScrollArrowMouseEvent);
		getXFLMovieClip("ScrollArrowDown_downSkin").addEventListener(MouseEvent.MOUSE_DOWN, onScrollArrowMouseEvent);

		getXFLMovieClip("ScrollArrowUp_upSkin").addEventListener(MouseEvent.MOUSE_UP, onScrollArrowMouseEvent);
		getXFLMovieClip("ScrollArrowUp_overSkin").addEventListener(MouseEvent.MOUSE_UP, onScrollArrowMouseEvent);
		getXFLMovieClip("ScrollArrowUp_downSkin").addEventListener(MouseEvent.MOUSE_UP, onScrollArrowMouseEvent);

		getXFLMovieClip("ScrollArrowDown_upSkin").addEventListener(MouseEvent.MOUSE_UP, onScrollArrowMouseEvent);
		getXFLMovieClip("ScrollArrowDown_overSkin").addEventListener(MouseEvent.MOUSE_UP, onScrollArrowMouseEvent);
		getXFLMovieClip("ScrollArrowDown_downSkin").addEventListener(MouseEvent.MOUSE_UP, onScrollArrowMouseEvent);

		_scrollPosition = 0.0;
		_minScrollPosition = 0.0;
		_maxScrollPosition = 0.0;

		setScrollArrowUpState(scrollArrowUpState);
		setScrollArrowDownState(scrollArrowDownState);
		setScrollThumbState(scrollThumbState);
		setSize(width, height);
		setScrollThumbPosition();
	}

	public function get_scrollPosition():Float
	{
		return this._scrollPosition;
	}

	public function set_scrollPosition(_scrollPosition:Float):Float
	{
		this._scrollPosition = _scrollPosition;
		setScrollThumbPosition();
		return this._scrollPosition;
	}

	public function get_minScrollPosition():Float
	{
		return this._minScrollPosition;
	}

	public function set_minScrollPosition(_minScrollPosition:Float):Float
	{
		this._minScrollPosition = _minScrollPosition;
		setScrollThumbPosition();
		return this._minScrollPosition;
	}

	public function get_maxScrollPosition():Float
	{
		return this._maxScrollPosition;
	}

	public function set_maxScrollPosition(_maxScrollPosition:Float):Float
	{
		this._maxScrollPosition = _maxScrollPosition;
		setScrollThumbPosition();
		return this._maxScrollPosition;
	}

	private function setScrollArrowUpState(scrollArrowUpState:String)
	{
		getXFLMovieClip("ScrollArrowUp_" + this.scrollArrowUpState + "Skin").visible = false;
		this.scrollArrowUpState = scrollArrowUpState;
		getXFLMovieClip("ScrollArrowUp_" + this.scrollArrowUpState + "Skin").visible = true;
	}

	private function setScrollArrowDownState(scrollArrowDownState:String)
	{
		getXFLMovieClip("ScrollArrowDown_" + this.scrollArrowDownState + "Skin").visible = false;
		this.scrollArrowDownState = scrollArrowDownState;
		getXFLMovieClip("ScrollArrowDown_" + this.scrollArrowDownState + "Skin").visible = true;
	}

	private function setScrollThumbState(scrollThumbState:String)
	{
		if (this.scrollThumbState != scrollThumbState)
		{
			getXFLMovieClip("ScrollThumb_" + this.scrollThumbState + "Skin").visible = false;
			getXFLMovieClip("ScrollThumb_" + this.scrollThumbState + "Skin").removeEventListener(MouseEvent.MOUSE_OVER, onScrollThumbMouseEvent);
			getXFLMovieClip("ScrollThumb_" + this.scrollThumbState + "Skin").removeEventListener(MouseEvent.MOUSE_OUT, onScrollThumbMouseEvent);
			getXFLMovieClip("ScrollThumb_" + this.scrollThumbState + "Skin").removeEventListener(MouseEvent.MOUSE_DOWN, onScrollThumbMouseEvent);
		}
		this.scrollThumbState = scrollThumbState;
		getXFLMovieClip("ScrollThumb_" + this.scrollThumbState + "Skin").visible = true;
		getXFLMovieClip("ScrollThumb_" + this.scrollThumbState + "Skin").addEventListener(MouseEvent.MOUSE_OVER, onScrollThumbMouseEvent);
		getXFLMovieClip("ScrollThumb_" + this.scrollThumbState + "Skin").addEventListener(MouseEvent.MOUSE_OUT, onScrollThumbMouseEvent);
		getXFLMovieClip("ScrollThumb_" + this.scrollThumbState + "Skin").addEventListener(MouseEvent.MOUSE_DOWN, onScrollThumbMouseEvent);
		setScrollThumbPosition();
	}

	private function setScrollThumbPosition()
	{
		if (parent == null) return;
		var thumbYPosition = 0.0;
		scrollThumbSkinHeight = scrollTrackHeight * (visibleScrollRange == null ? height : visibleScrollRange) / ((visibleScrollRange == null ? height : visibleScrollRange)
			+ _maxScrollPosition);
		if (scrollThumbSkinHeight > scrollTrackHeight) scrollThumbSkinHeight = scrollTrackHeight;
		if (scrollThumbSkinHeight < 20.0) scrollThumbSkinHeight = 20.0;
		thumbYPosition = _scrollPosition / (_maxScrollPosition - _minScrollPosition);
		getXFLMovieClip("ScrollThumb_" + this.scrollThumbState + "Skin").height = scrollThumbSkinHeight;
		getXFLMovieClip("ScrollThumb_" + this.scrollThumbState + "Skin").y = scrollArrowUpHeight
			+ (thumbYPosition * (scrollTrackHeight - scrollThumbSkinHeight));
		getXFLMovieClip("ScrollBar_thumbIcon").y = getXFLMovieClip("ScrollThumb_" + this.scrollThumbState + "Skin")
			.y + ((scrollThumbSkinHeight - scrollThumbIconHeight) / 2.0);
	}

	private function layoutChild(child:DisplayObject, alignToVertical:String)
	{
		if (child == null)
		{
			trace("layoutChild(): child not found");
			return;
		}
		child.x = width - child.width;
		switch (alignToVertical)
		{
			case "scrollthumb":
				child.x = (width - child.width) / 2.0;
			case "scrolltrack":
				child.y = scrollArrowUpHeight;
				child.height = scrollTrackHeight;
			case "top":
				child.y = 0.0;
			case "bottom":
				child.y = height - child.height;
		}
	}

	override public function setSize(_width:Float, _height:Float)
	{
		super.setSize(_width, _height);

		scrollTrackHeight = _height - scrollArrowUpHeight - scrollArrowDownHeight;

		layoutChild(getXFLMovieClip("ScrollArrowUp_upSkin"), "top");
		layoutChild(getXFLMovieClip("ScrollArrowUp_overSkin"), "top");
		layoutChild(getXFLMovieClip("ScrollArrowUp_downSkin"), "top");
		layoutChild(getXFLMovieClip("ScrollArrowUp_disabledSkin"), "top");
		layoutChild(getXFLMovieClip("ScrollArrowDown_upSkin"), "bottom");
		layoutChild(getXFLMovieClip("ScrollArrowDown_overSkin"), "bottom");
		layoutChild(getXFLMovieClip("ScrollArrowDown_downSkin"), "bottom");
		layoutChild(getXFLMovieClip("ScrollArrowDown_disabledSkin"), "bottom");
		layoutChild(getXFLMovieClip("ScrollTrack_skin"), "scrolltrack");
		layoutChild(getXFLMovieClip("ScrollBar_thumbIcon"), "scrollthumb");
		layoutChild(getXFLMovieClip("ScrollThumb_upSkin"), "scrollthumb");
		layoutChild(getXFLMovieClip("ScrollThumb_overSkin"), "scrollthumb");
		layoutChild(getXFLMovieClip("ScrollThumb_downSkin"), "scrollthumb");

		setScrollThumbPosition();
	}

	private function onScrollArrowMouseEvent(event:MouseEvent):Void
	{
		if (parent == null)
		{
			openfl.Lib.current.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrameScrollUp);
			openfl.Lib.current.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrameScrollDown);
			return;
		}
		if (disabled == true && (scrollArrowUpState != "disabled" || scrollArrowDownState != "disabled"))
		{
			setScrollArrowUpState("disabled");
			setScrollArrowDownState("disabled");
			return;
		}
		var subComponent:String = cast(event.target, DisplayObject).name.split("_")[0];
		switch (subComponent)
		{
			case "ScrollArrowUp":
				var newState:String = "up";
				switch (event.type)
				{
					case MouseEvent.MOUSE_OVER:
						newState = "over";
					case MouseEvent.MOUSE_UP:
						newState = "up";
						openfl.Lib.current.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrameScrollUp);
					case MouseEvent.MOUSE_DOWN:
						newState = "down";
						openfl.Lib.current.stage.addEventListener(Event.ENTER_FRAME, onEnterFrameScrollUp);
					default:
						trace("onScrollArrowMouseEvent(): unsupported mouse event type '" + event.type + "'");
				}
				setScrollArrowUpState(newState);
			case "ScrollArrowDown":
				var newState:String = "up";
				switch (event.type)
				{
					case MouseEvent.MOUSE_OVER:
						newState = "over";
					case MouseEvent.MOUSE_UP:
						newState = "up";
						openfl.Lib.current.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrameScrollDown);
					case MouseEvent.MOUSE_DOWN:
						newState = "down";
						openfl.Lib.current.stage.addEventListener(Event.ENTER_FRAME, onEnterFrameScrollDown);
					default:
						trace("onScrollArrowMouseEvent(): unsupported mouse event type '" + event.type + "'");
				}
				setScrollArrowDownState(newState);
			default:
				trace("onScrollArrowMouseEvent(): unsupported sub component '" + subComponent + "'");
		}
	}

	public function onEnterFrameScrollUp(event:Event):Void
	{
		if (parent == null)
		{
			openfl.Lib.current.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrameScrollUp);
			return;
		}
		_scrollPosition = _scrollPosition - lineScrollSize;
		if (_scrollPosition < _minScrollPosition) _scrollPosition = _minScrollPosition;
		dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL));
		setScrollThumbPosition();
	}

	public function onEnterFrameScrollDown(event:Event):Void
	{
		if (parent == null)
		{
			openfl.Lib.current.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrameScrollDown);
			return;
		}
		_scrollPosition = _scrollPosition + lineScrollSize;
		if (_scrollPosition > _maxScrollPosition) _scrollPosition = _maxScrollPosition;
		dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL));
		setScrollThumbPosition();
	}

	private function onScrollThumbMouseEvent(event:MouseEvent):Void
	{
		if (parent == null)
		{
			return;
		}
		if (disabled == true)
		{
			return;
		}
		if (scrollThumbState == "down") return;
		switch (event.type)
		{
			case MouseEvent.MOUSE_OUT:
				setScrollThumbState("up");
			case MouseEvent.MOUSE_OVER:
				setScrollThumbState("over");
			case MouseEvent.MOUSE_DOWN:
				setScrollThumbState("down");
				scrollThumbMouseMoveYRelative = getXFLMovieClip("ScrollThumb_" + this.scrollThumbState + "Skin").globalToLocal(new Point(event.stageX,
					event.stageY))
					.y;
				scrollThumbMouseMoveYRelative *= getXFLMovieClip("ScrollThumb_" + this.scrollThumbState + "Skin").scaleY;
				openfl.Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, onScrollThumbMouseMove);
				openfl.Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, onScrollThumbMouseMove);
			default:
				trace("onScrollThumbMouseEvent(): unsupported mouse event type '" + event.type + "'");
		}
	}

	private function onScrollThumbMouseMove(event:MouseEvent):Void
	{
		if (parent == null)
		{
			openfl.Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, onScrollThumbMouseMove);
			openfl.Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, onScrollThumbMouseMove);
			return;
		}
		if (disabled == true)
		{
			openfl.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_UP, onScrollThumbMouseMove);
			openfl.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onScrollThumbMouseMove);
			setScrollThumbState("up");
			return;
		}
		switch (event.type)
		{
			case MouseEvent.MOUSE_UP:
				openfl.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_UP, onScrollThumbMouseMove);
				openfl.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onScrollThumbMouseMove);
				setScrollThumbState("up");
			case MouseEvent.MOUSE_MOVE:
				var thumbableHeight = scrollTrackHeight - scrollThumbSkinHeight;
				var skinMouseY:Float = getXFLMovieClip("ScrollTrack_skin").globalToLocal(new Point(event.stageX, event.stageY)).y;
				skinMouseY *= getXFLMovieClip("ScrollTrack_skin").scaleY;
				skinMouseY -= scrollThumbMouseMoveYRelative;
				_scrollPosition = (skinMouseY / thumbableHeight) * (_maxScrollPosition - _minScrollPosition);
				if (_scrollPosition < _minScrollPosition) _scrollPosition = _minScrollPosition;
				if (_scrollPosition > _maxScrollPosition) _scrollPosition = _maxScrollPosition;
				dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL));
				setScrollThumbPosition();
			default:
				trace("onScrollThumbMouseMove(): unsupported mouse event type '" + event.type + "'");
		}
	}

	private function onScrollTrackMouseDown(event:MouseEvent):Void
	{
		var scrollTrackMouseY = getXFLMovieClip("ScrollTrack_skin").globalToLocal(new Point(event.stageX, event.stageY)).y;
		var thumbableHeight = scrollTrackHeight - scrollThumbSkinHeight;
		scrollTrackMouseY *= scrollTrackHeight / thumbableHeight;
		if (scrollTrackMouseY < getXFLMovieClip("ScrollThumb_" + this.scrollThumbState + "Skin").y)
		{
			_scrollPosition = _scrollPosition - pageScrollSize;
			if (_scrollPosition < _minScrollPosition) _scrollPosition = _minScrollPosition;
			dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL));
			setScrollThumbPosition();
		}
		else
		{
			_scrollPosition = _scrollPosition + pageScrollSize;
			if (_scrollPosition > _maxScrollPosition) _scrollPosition = _maxScrollPosition;
			dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL));
			setScrollThumbPosition();
		}
	}
}
