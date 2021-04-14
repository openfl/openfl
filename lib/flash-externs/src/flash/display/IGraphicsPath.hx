package flash.display;

#if flash
extern interface IGraphicsPath {}
#else
typedef IGraphicsPath = openfl.display.IGraphicsPath;
#end
