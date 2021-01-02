package flash.display;

#if flash
extern interface IGraphicsFill {}
#else
typedef IGraphicsFill = openfl.display.IGraphicsFill;
#end
