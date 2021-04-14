package flash.display;

#if flash
extern interface IGraphicsData {}
#else
typedef IGraphicsData = openfl.display.IGraphicsData;
#end
