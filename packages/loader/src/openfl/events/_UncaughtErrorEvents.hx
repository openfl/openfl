package openfl.events;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _UncaughtErrorEvents extends _EventDispatcher
{
	private var uncaughtErrorEvents:UncaughtErrorEvents;

	public function new(uncaughtErrorEvents:UncaughtErrorEvents)
	{
		this.uncaughtErrorEvents = uncaughtErrorEvents;

		super(uncaughtErrorEvents);
	}
}
