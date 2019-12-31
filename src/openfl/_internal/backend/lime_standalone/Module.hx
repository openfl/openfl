package openfl._internal.backend.lime_standalone;

#if openfl_html5
class Module implements IModule
{
	/**
		Exit events are dispatched when the application is exiting
	**/
	public var onExit = new LimeEvent<Int->Void>();

	/**
		Creates a new `Module` instance
	**/
	public function new() {}

	@:noCompletion private function __registerLimeModule(application:Application):Void {}

	@:noCompletion private function __unregisterLimeModule(application:Application):Void {}
}
#end
