package openfl.events;

#if !flash
import openfl.permissions.PermissionStatus;

/**
	This event is dispatched when permission status changes for certain
	operations.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class PermissionEvent extends Event
{
	public static inline var PERMISSION_STATUS:EventType<PermissionEvent> = "permissionStatus";

	/**
		Check whether the permission has been granted or denied.

		@see `openfl.permissions.PermissionStatus.GRANTED`
		@see `openfl.permissions.PermissionStatus.DENIED`
	**/
	public var status:PermissionStatus;

	/**
		Creates an PermissionEvent object that contains information about the name of the permission and its status.

		@param type       The type of the event. Event listeners can access this
						  information through the inherited `type`
						  property. There is only one type of Permission event:
						  `PermissionEvent.PERMISSION_STATUS`.
		@param bubbles    Determines whether the Event object participates in the
						  bubbling stage of the event flow. Event listeners can
						  access this information through the inherited
						  `bubbles` property.
		@param cancelable Determines whether the Event object can be canceled.
						  Event listeners can access this information through the
						  inherited `cancelable` property.
		@param status     Permission status. Event listeners can access this
						  information through the `status` property.
	**/
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, status:PermissionStatus = DENIED):Void
	{
		this.status = status;

		super(type, bubbles, cancelable);
	}

	public override function clone():PermissionEvent
	{
		var event = new PermissionEvent(type, bubbles, cancelable, status);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("PermissionEvent", ["type", "bubbles", "cancelable", "status"]);
	}

	@:noCompletion private override function __init():Void
	{
		super.__init();
		status = DENIED;
	}
}
#else
typedef PermissionEvent = flash.events.PermissionEvent;
#end
