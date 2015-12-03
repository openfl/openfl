package openfl.display; #if (!display && !flash)


interface IGraphicsStroke {}


#else


#if flash
@:native("flash.display.IGraphicsStroke")
#end

extern interface IGraphicsStroke {}


#end