package openfl._v2.display; #if lime_legacy


import openfl.geom.Rectangle;


class Sprite extends DisplayObjectContainer {
	
	
	public var buttonMode:Bool;
	public var useHandCursor:Bool;
	
	
	public function new () {
		
		super (DisplayObjectContainer.lime_create_display_object_container (), __getType ());
		
		useHandCursor = true;
		buttonMode = false;
		
	}
	
	
	public function startDrag (lockCenter:Bool = false, bounds:Rectangle = null):Void {
		
		if (stage != null) {
			
			stage.__startDrag (this, lockCenter, bounds);
			
		}
		
	}
	
	
	public function stopDrag ():Void {
		
		if (stage != null) {
			
			stage.__stopDrag (this);
			
		}
		
	}
	
	
	private function __getType ():String {
		
		var type = Type.getClassName (Type.getClass (this));
		var position = type.lastIndexOf (".");
		return position >= 0 ? type.substr (position + 1) : type;
		
	}
	
	
}


#end