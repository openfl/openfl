package openfl.display;

#if !flash
/**
	This interface is used to define objects that can be used as path parameters
	in the `openfl.display.Graphics` methods and drawing classes. Use the
	implementor classes of this interface to create and manage path property
	data, and to reuse the same data for different instances.

	@see `openfl.display.Graphics.drawGraphicsData()`
	@see `openfl.display.Graphics.drawPath()`
**/
interface IGraphicsPath {}
#else
typedef IGraphicsPath = flash.display.IGraphicsPath;
#end
