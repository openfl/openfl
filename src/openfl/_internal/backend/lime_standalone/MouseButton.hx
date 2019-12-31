package openfl._internal.backend.lime_standalone;

#if openfl_html5
@:enum abstract MouseButton(Int) from Int to Int
{
	var LEFT = 0;
	var MIDDLE = 1;
	var RIGHT = 2;
}
#end
