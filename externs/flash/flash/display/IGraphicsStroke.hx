package flash.display;

#if flash
extern interface IGraphicsStroke {}
#else
typedef IGraphicsStroke = openfl.display.IGraphicsStroke;
#end
