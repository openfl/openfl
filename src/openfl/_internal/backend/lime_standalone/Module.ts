namespace openfl._internal.backend.lime_standalone;

#if openfl_html5
class Module implements IModule
{
	/**
		Exit events are dispatched when the application is exiting
	**/
	public onExit = new LimeEvent < Int -> Void > ();

	/**
		Creates a new `Module` instance
	**/
	public constructor() { }

	protected __registerLimeModule(application: Application): void { }

	protected __unregisterLimeModule(application: Application): void { }
}
#end
