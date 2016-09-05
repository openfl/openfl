package openfl.filters.commands;

import openfl.display.BitmapData;

enum CommandType {

	Blur1D (target:BitmapData, source:BitmapData, blur:Float, horizontal:Bool, distance:Float, angle:Float, strength:Float);
	Colorize (target:BitmapData, source:BitmapData, color:Int, alpha:Float);
	ColorLookup (target:BitmapData, source:BitmapData, colorLookup:BitmapData);
	ColorTransform (target:BitmapData, source:BitmapData, colorMatrix:Array<Float>);
	CombineInner (target:BitmapData, source1:BitmapData, source2:BitmapData );
	Combine (target:BitmapData, source1:BitmapData, source2:BitmapData);
	Knockout(target:BitmapData,source:BitmapData, source2:BitmapData, outer:Bool);

}
