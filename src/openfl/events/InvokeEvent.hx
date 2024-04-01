package openfl.events;

#if (!flash && sys && (!flash_doc_gen || air_doc_gen))
import openfl.desktop.InvokeEventReason;
import openfl.filesystem.File;

/**
	The NativeApplication object of an OpenFL application dispatches an `invoke`
	event when the application is invoked.

	The NativeApplication object always dispatches an `invoke` event when an
	application is launched, but the event may be dispatched at other times as
	well. For example, a running application dispatches an additional InvokeEvent
	when a user activates a file associated with the application.

	Only a single instance of a particular application can be launched.
	Subsequent attempts to launch the application will result in a new `invoke`
	event dispatched by the NativeApplication object of the running instance. It
	is an application's responsibility to handle this event and take the
	appropriate action, such as opening a new application window to display the
	data in a file.

	InvokeEvent objects are dispatched by the global NativeApplication object
	(`NativeApplication.nativeApplication`). To receive `invoke` events, call
	the `addEventListener()` method of the NativeApplication object. When an
	event listener registers for an `invoke` event, it will also receive all
	`invoke` events that occurred before the registration. These earlier events
	are dispatched after the call to `addEventListener()` returns, but not
	necessarily before a new `invoke` event that might be might be dispatched
	after registration. Thus, you should not rely on dispatch order.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class InvokeEvent extends Event
{
	/**
		The `InvokeEvent.INVOKE` constant defines the value of the `type`
		property of an InvokeEvent object.
	**/
	public static inline var INVOKE:EventType<InvokeEvent> = "invoke";

	/**
		The array of string arguments passed during this invocation. If this is
		a command line invocation, the array contains the command line arguments
		(excluding the process name).

		On mobile platforms, this property contains the array of options with
		which the application was launched, not the command-line arguments.
		Additionally, on mobile platforms, when `reason` is
		`InvokeEventReason.OPEN_URL`, the contents of the `arguments` array
		vary, as follows:

		- Another application or browser invokes the application with a custom
		URL (iOS and Android):

			| arguments                      | iOS             | Android     |
			| ------------------------------ | --------------- | ----------- |
			| `InvokeEvent.arguments.length` | 3               | 2           |
			| `InvokeEvent.arguments[0]`     | _url_           | _url_       |
			| `InvokeEvent.arguments[1]`     | _source app id_ | _action id_ |
			| `InvokeEvent.arguments[2]`     | `null`          | N/A         |

		- The system invokes the application to open an associated file type
		(iOS and Android):

			| arguments                      | iOS    | Android     |
			| ------------------------------ | ------ | ----------- |
			| `InvokeEvent.arguments.length` | 3      | 2           |
			| `InvokeEvent.arguments[0]`     | _url_  | _url_       |
			| `InvokeEvent.arguments[1]`     | `null` | _action id_ |
			| `InvokeEvent.arguments[2]`     | `null` | N/A         |
		- Another application invokes the application using the document
		interaction controller (iOS only):

			| arguments                      | iOS             |
			| ------------------------------ | --------------- |
			| `InvokeEvent.arguments.length` | 3               |
			| `InvokeEvent.arguments[0]`     | _url_           |
			| `InvokeEvent.arguments[1]`     | _source app id_ |
			| `InvokeEvent.arguments[2]`     | _annotation_    |

		_Note:_ When multiple files are selected and opened on macOS, OpenFL
		dispatches a single `invoke` event containing the names of all the
		selected files in the arguments array. On Windows and Linux, however,
		OpenFL dispatches a separate invoke event for each selected file
		containing only that filename in the `arguments` array.
	**/
	public var arguments(default, null):Array<String>;

	/**
		The directory that should be used to resolve any relative paths in the
		`arguments` array.

		If an application is started from the command line, this property is
		typically set to the current working directory of the command line shell
		from which the application was started. If an application is launched
		from the GUI shell, this is typically the file system root.
	**/
	public var currentDirectory(default, null):File;

	/**
		The reason for this InvokeEvent. This property indicates whether the
		application was launched manually by the user or automatically at login.
		Possible values are enumerated as constants in the `InvokeEventReason`
		class:

		| InvokeEventReason constant | Meaning |
		| -------------------------- | ------- |
		| `LOGIN`                    | Launched automatically at at login. |
		| `NOTIFICATION`             | Launched in reponse to a notification (iOS only). |
		| `OPEN_URL`                 | Launched because the application was invoked by another application. |
		| `STANDARD`                 | Launched for any other reason. |

		**Note:** On mobile platforms, the `reason` property is never set to
		`LOGIN`.
	**/
	public var reason(default, null):InvokeEventReason;

	/**

	**/
	public function new(type:EventType<InvokeEvent>, bubbles:Bool = false, cancelable:Bool = false, ?dir:File, ?argv:Array<Dynamic>,
			reason:InvokeEventReason = STANDARD)
	{
		super(type, bubbles, cancelable);
		this.currentDirectory = dir;
		var stringArgs:Array<String> = [];
		for (arg in argv)
		{
			stringArgs.push(Std.string(arg));
		}
		this.arguments = stringArgs;
		this.reason = reason;
	}

	override public function clone():InvokeEvent
	{
		return new InvokeEvent(type, bubbles, cancelable, currentDirectory, arguments, reason);
	}
}
#else
#if air
typedef InvokeEvent = flash.events.InvokeEvent;
#end
#end
