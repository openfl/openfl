package openfl.display; #if (!display && !flash)


interface IGraphicsPath {}


#else


#if flash
@:native("flash.display.IGraphicsPath")
#end

extern interface IGraphicsPath {}


#end