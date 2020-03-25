namespace openfl._internal.backend.lime_standalone;

#if openfl_html5
interface IModule
{
	@: dox(show) protected __registerLimeModule(application: Application): void;
@: dox(show) protected __unregisterLimeModule(application: Application): void;
}
#end
