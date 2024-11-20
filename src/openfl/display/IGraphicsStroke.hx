package openfl.display;

#if !flash
/**
	This interface is used to define objects that can be used as strok
	parameters in the `openfl.display.Graphics` methods and drawing classes. Use
	the implementor classes of this interface to create and manage stroke
	property data, and to reuse the same data for different instances.

	@see `openfl.display.Graphics.drawGraphicsData()`
**/
interface IGraphicsStroke {}
#else
typedef IGraphicsStroke = flash.display.IGraphicsStroke;
#end
