package;

import lime.app.Application;
import lime.ui.Window;
import openfl.display.Stage;

class DummyWindow extends Window {

	public function new () {

		super ({ width: 800, height: 600 });

	}

	public override function create (application:Application):Void {

		super.create (application);

		stage = new Stage (this, 0xFFFFFF);
		application.addModule (stage);

	}

}
