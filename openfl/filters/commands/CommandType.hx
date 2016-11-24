package openfl.filters.commands;

import openfl.display.BitmapData;
import lime.utils.Float32Array;

import haxe.Serializer;
import haxe.Unserializer;

enum CommandType {

	Blur1D (target:BitmapData, source:BitmapData, blur:Float, horizontal:Bool, strength:Float, distance:Float, angle:Float);
	Offset (target:BitmapData, source:BitmapData, strength:Float, distance:Float, angle:Float);
	Colorize (target:BitmapData, source:BitmapData, color:Int, alpha:Float);
	ColorLookup (target:BitmapData, source:BitmapData, colorLookup:BitmapData);
	ColorTransform (target:BitmapData, source:BitmapData, multipliers:Float32Array, offsets:Float32Array);
	CombineInner (target:BitmapData, source1:BitmapData, source2:BitmapData );
	Combine (target:BitmapData, source1:BitmapData, source2:BitmapData);
	InnerKnockout(target:BitmapData,source1:BitmapData, source2:BitmapData);
	OuterKnockout(target:BitmapData,source1:BitmapData, source2:BitmapData);
	OuterKnockoutTransparency(target:BitmapData,source1:BitmapData, source2:BitmapData, allowTransparency:Bool);
	DestOut(target:BitmapData,source1:BitmapData, source2:BitmapData);
}
