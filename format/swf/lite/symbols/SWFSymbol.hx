package format.swf.lite.symbols;

import openfl.ObjectPool;
import openfl.display.DisplayObject;


@:keepSub class SWFSymbol {
	
	
	public var className:String;
	public var id:Int;

	public var poolable(default, set):Bool = false;

	public var pool:ObjectPool<DisplayObject>;

	public function new () {

	}
	

	public function set_poolable(value:Bool):Bool {

		if (value && pool == null) {
			pool = new ObjectPool<DisplayObject>( function() { throw "Forbidden"; return null; } );
		}

		return poolable = value;
	}

	
}