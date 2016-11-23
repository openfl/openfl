package format.swf.data;

import format.swf.SWFData;

class SWFClipEventFlags
{
	public var keyUpEvent:Bool;
	public var keyDownEvent:Bool;
	public var mouseUpEvent:Bool;
	public var mouseDownEvent:Bool;
	public var mouseMoveEvent:Bool;
	public var unloadEvent:Bool;
	public var enterFrameEvent:Bool;
	public var loadEvent:Bool;
	public var dragOverEvent:Bool; // SWF6
	public var rollOutEvent:Bool; // SWF6
	public var rollOverEvent:Bool; // SWF6
	public var releaseOutsideEvent:Bool; // SWF6
	public var releaseEvent:Bool; // SWF6
	public var pressEvent:Bool; // SWF6
	public var initializeEvent:Bool; // SWF6
	public var dataEvent:Bool;
	public var constructEvent:Bool; // SWF7
	public var keyPressEvent:Bool; // SWF6
	public var dragOutEvent:Bool; // SWF6
	
	public function new(data:SWFData = null, version:Int = 0) {
		if (data != null) {
			parse(data, version);
		}
	}
	
	public function parse(data:SWFData, version:Int):Void {
		var flags1:Int = data.readUI8();
		keyUpEvent = ((flags1 & 0x80) != 0);
		keyDownEvent = ((flags1 & 0x40) != 0);
		mouseUpEvent = ((flags1 & 0x20) != 0);
		mouseDownEvent = ((flags1 & 0x10) != 0);
		mouseMoveEvent = ((flags1 & 0x08) != 0);
		unloadEvent = ((flags1 & 0x04) != 0);
		enterFrameEvent = ((flags1 & 0x02) != 0);
		loadEvent = ((flags1 & 0x01) != 0);
		var flags2:Int = data.readUI8();
		dragOverEvent = ((flags2 & 0x80) != 0);
		rollOutEvent = ((flags2 & 0x40) != 0);
		rollOverEvent = ((flags2 & 0x20) != 0);
		releaseOutsideEvent = ((flags2 & 0x10) != 0);
		releaseEvent = ((flags2 & 0x08) != 0);
		pressEvent = ((flags2 & 0x04) != 0);
		initializeEvent = ((flags2 & 0x02) != 0);
		dataEvent = ((flags2 & 0x01) != 0);
		if (version >= 6) {
			var flags3:Int = data.readUI8();
			constructEvent = ((flags3 & 0x04) != 0);
			keyPressEvent = ((flags3 & 0x02) != 0);
			dragOutEvent = ((flags3 & 0x01) != 0);
			data.readUI8(); // reserved, always 0
		}
	}
	
	public function publish(data:SWFData, version:Int):Void {
		var flags1:Int = 0;
		if(keyUpEvent) { flags1 |= 0x80; }
		if(keyDownEvent) { flags1 |= 0x40; }
		if(mouseUpEvent) { flags1 |= 0x20; }
		if(mouseDownEvent) { flags1 |= 0x10; }
		if(mouseMoveEvent) { flags1 |= 0x08; }
		if(unloadEvent) { flags1 |= 0x04; }
		if(enterFrameEvent) { flags1 |= 0x02; }
		if(loadEvent) { flags1 |= 0x01; }
		data.writeUI8(flags1);
		var flags2:Int = 0;
		if(dragOverEvent) { flags2 |= 0x80; }
		if(rollOutEvent) { flags2 |= 0x40; }
		if(rollOverEvent) { flags2 |= 0x20; }
		if(releaseOutsideEvent) { flags2 |= 0x10; }
		if(releaseEvent) { flags2 |= 0x08; }
		if(pressEvent) { flags2 |= 0x04; }
		if(initializeEvent) { flags2 |= 0x02; }
		if(dataEvent) { flags2 |= 0x01; }
		data.writeUI8(flags2);
		if (version >= 6) {
			var flags3:Int = 0;
			if(constructEvent) { flags3 |= 0x04; }
			if(keyPressEvent) { flags3 |= 0x02; }
			if(dragOutEvent) { flags3 |= 0x01; }
			data.writeUI8(flags3);
			data.writeUI8(0); // reserved, always 0
		}
	}
	
	public function toString():String {
		var a:Array<String> = [];
		if (keyUpEvent) { a.push("keyup"); }
		if (keyDownEvent) { a.push("keydown"); }
		if (mouseUpEvent) { a.push("mouseup"); }
		if (mouseDownEvent) { a.push("mousedown"); }
		if (mouseMoveEvent) { a.push("mousemove"); }
		if (unloadEvent) { a.push("unload"); }
		if (enterFrameEvent) { a.push("enterframe"); }
		if (loadEvent) { a.push("load"); }
		if (dragOverEvent) { a.push("dragover"); }
		if (rollOutEvent) { a.push("rollout"); }
		if (rollOverEvent) { a.push("rollover"); }
		if (releaseOutsideEvent) { a.push("releaseoutside"); }
		if (releaseEvent) { a.push("release"); }
		if (pressEvent) { a.push("press"); }
		if (initializeEvent) { a.push("initialize"); }
		if (dataEvent) { a.push("data"); }
		if (constructEvent) { a.push("construct"); }
		if (keyPressEvent) { a.push("keypress"); }
		if (dragOutEvent) { a.push("dragout"); }
		return a.join(",");
	}
}