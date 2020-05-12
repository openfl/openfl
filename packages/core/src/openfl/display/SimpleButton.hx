package openfl.display;

#if !flash
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.events.MouseEvent;
import openfl.media.SoundTransform;
import openfl.ui.MouseCursor;
import openfl.Vector;

/**
	The SimpleButton class lets you control all instances of button symbols in
	a SWF file.

	In Flash Professional, you can give a button an instance name in the
	Property inspector. SimpleButton instance names are displayed in the Movie
	Explorer and in the Insert Target Path dialog box in the Actions panel.
	After you create an instance of a button in Flash Professional, you can use
	the methods and properties of the SimpleButton class to manipulate buttons
	with ActionScript.

	In ActionScript 3.0, you use the `new SimpleButton()`
	constructor to create a SimpleButton instance.

	The SimpleButton class inherits from the InteractiveObject class.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.MovieClip)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
class SimpleButton extends InteractiveObject
{
	/**
		Specifies a display object that is used as the visual object for the
		button "Down" state  - the state that the button is in when the user
		selects the `hitTestState` object.
	**/
	public var downState(get, set):DisplayObject;

	/**
		A Boolean value that specifies whether a button is enabled. When a button
		is disabled(the enabled property is set to `false`), the
		button is visible but cannot be clicked. The default value is
		`true`. This property is useful if you want to disable part of
		your navigation; for example, you might want to disable a button in the
		currently displayed page so that it can't be clicked and the page cannot
		be reloaded.

		**Note:** To prevent mouseClicks on a button, set both the
		`enabled` and `mouseEnabled` properties to
		`false`.
	**/
	public var enabled(get, set):Bool;

	/**
		Specifies a display object that is used as the hit testing object for the
		button. For a basic button, set the `hitTestState` property to
		the same display object as the `overState` property. If you do
		not set the `hitTestState` property, the SimpleButton is
		inactive  -  it does not respond to user input events.
	**/
	public var hitTestState(get, set):DisplayObject;

	/**
		Specifies a display object that is used as the visual object for the
		button over state  -  the state that the button is in when the pointer is
		positioned over the button.
	**/
	public var overState(get, set):DisplayObject;

	/**
		The SoundTransform object assigned to this button. A SoundTransform object
		includes properties for setting volume, panning, left speaker assignment,
		and right speaker assignment. This SoundTransform object applies to all
		states of the button. This SoundTransform object affects only embedded
		sounds.
	**/
	public var soundTransform(get, set):SoundTransform;

	/**
		Indicates whether other display objects that are SimpleButton or MovieClip
		objects can receive user input release events. The
		`trackAsMenu` property lets you create menus. You can set the
		`trackAsMenu` property on any SimpleButton or MovieClip object.
		If the `trackAsMenu` property does not exist, the default
		behavior is `false`.

		You can change the `trackAsMenu` property at any time; the
		modified button immediately takes on the new behavior.
	**/
	public var trackAsMenu(get, set):Bool;

	/**
		Specifies a display object that is used as the visual object for the
		button up state  -  the state that the button is in when the pointer is
		not positioned over the button.
	**/
	public var upState(get, set):DisplayObject;

	/**
		A Boolean value that, when set to `true`, indicates whether the
		hand cursor is shown when the pointer rolls over a button. If this
		property is set to `false`, the arrow pointer cursor is
		displayed instead. The default is `true`.

		You can change the `useHandCursor` property at any time; the
		modified button immediately uses the new cursor behavior.
	**/
	public var useHandCursor(get, set):Bool;

	/**
		Creates a new SimpleButton instance. Any or all of the display objects
		that represent the various button states can be set as parameters in the
		constructor.

		@param upState      The initial value for the SimpleButton up state.
		@param overState    The initial value for the SimpleButton over state.
		@param downState    The initial value for the SimpleButton down state.
		@param hitTestState The initial value for the SimpleButton hitTest state.
	**/
	public function new(upState:DisplayObject = null, overState:DisplayObject = null, downState:DisplayObject = null, hitTestState:DisplayObject = null)
	{
		if (_ == null)
		{
			_ = new _SimpleButton(this, upState, overState, downState, hitTestState);
		}

		super();
	}

	// Getters & Setters

	@:noCompletion private function get_downState():DisplayObject
	{
		return (_ : _SimpleButton).downState;
	}

	@:noCompletion private function set_downState(value:DisplayObject):DisplayObject
	{
		return (_ : _SimpleButton).downState = value;
	}

	@:noCompletion private function get_enabled():Bool
	{
		return (_ : _SimpleButton).enabled;
	}

	@:noCompletion private function set_enabled(value:Bool):Bool
	{
		return (_ : _SimpleButton).enabled = value;
	}

	@:noCompletion private function get_hitTestState():DisplayObject
	{
		return (_ : _SimpleButton).hitTestState;
	}

	@:noCompletion private function set_hitTestState(value:DisplayObject):DisplayObject
	{
		return (_ : _SimpleButton).hitTestState = value;
	}

	@:noCompletion private function get_overState():DisplayObject
	{
		return (_ : _SimpleButton).overState;
	}

	@:noCompletion private function set_overState(value:DisplayObject):DisplayObject
	{
		return (_ : _SimpleButton).overState = value;
	}

	@:noCompletion private function get_soundTransform():SoundTransform
	{
		return (_ : _SimpleButton).soundTransform;
	}

	@:noCompletion private function set_soundTransform(value:SoundTransform):SoundTransform
	{
		return (_ : _SimpleButton).soundTransform = value;
	}

	@:noCompletion private function get_upState():DisplayObject
	{
		return (_ : _SimpleButton).upState;
	}

	@:noCompletion private function set_upState(value:DisplayObject):DisplayObject
	{
		return (_ : _SimpleButton).upState = value;
	}

	@:noCompletion private function get_trackAsMenu():Bool
	{
		return (_ : _SimpleButton).trackAsMenu;
	}

	@:noCompletion private function set_trackAsMenu(value:Bool):Bool
	{
		return (_ : _SimpleButton).trackAsMenu = value;
	}

	@:noCompletion private function get_useHandCursor():Bool
	{
		return (_ : _SimpleButton).useHandCursor;
	}

	@:noCompletion private function set_useHandCursor(value:Bool):Bool
	{
		return (_ : _SimpleButton).useHandCursor = value;
	}
}
#else
typedef SimpleButton = flash.display.SimpleButton;
#end
