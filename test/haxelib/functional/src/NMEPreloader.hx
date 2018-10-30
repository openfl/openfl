package;

import openfl.display.Sprite;
import openfl.events.Event;

class NMEPreloader extends Sprite {

	public function new () {

		super();

	}

	public function onLoaded () {

		dispatchEvent (new Event (Event.COMPLETE));

	}

	public function onUpdate (bytesLoaded:Int, bytesTotal:Int):Void {
	}

	public function onInit () {
	}

}
