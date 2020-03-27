namespace openfl._internal.backend.dummy;

import openfl.display.Stage;
import MouseCursor from "../ui/MouseCursor";

class DummyMouseBackend
{
	public static getCursor(): MouseCursor
	{
		return null;
	}

	public static hide(): void { }

	public static setCursor(value: MouseCursor): void { }

	public static setStageCursor(stage: Stage, cursor: MouseCursor): void { }

	public static show(): void { }
}
