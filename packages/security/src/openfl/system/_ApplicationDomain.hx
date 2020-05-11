package openfl.system;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _ApplicationDomain
{
	public static var currentDomain = new ApplicationDomain(null);

	public var parentDomain:ApplicationDomain;

	public function new(parentDomain:ApplicationDomain = null)
	{
		if (parentDomain != null)
		{
			this.parentDomain = parentDomain;
		}
		else
		{
			this.parentDomain = currentDomain;
		}
	}

	public function getDefinition(name:String):Class<Dynamic>
	{
		return Type.resolveClass(name);
	}

	public function hasDefinition(name:String):Bool
	{
		return (Type.resolveClass(name) != null);
	}
}
