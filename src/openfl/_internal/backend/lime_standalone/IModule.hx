package openfl._internal.backend.lime_standalone;

#if openfl_html5
interface IModule
{
	@:dox(show) @:noCompletion private function __registerLimeModule(application:Application):Void;
	@:dox(show) @:noCompletion private function __unregisterLimeModule(application:Application):Void;
}
#end
