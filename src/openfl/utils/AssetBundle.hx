package openfl.utils;

#if (!lime && openfl_html5)
typedef AssetBundle = openfl._internal.backend.lime_standalone.AssetBundle;
#elseif lime
typedef AssetBundle = lime.utils.AssetBundle;
#else
class AssetBundle
{
	public function new() {}
}
#end
