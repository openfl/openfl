namespace openfl._internal.backend.dummy;

class DummyExternalInterfaceBackend
{
	public static addCallback(functionName: string, closure: Dynamic): void { }

	public static call(functionName: string, p1: Dynamic = null, p2: Dynamic = null, p3: Dynamic = null, p4: Dynamic = null, p5: Dynamic = null): Dynamic
	{
		return null;
	}

	public static getObjectID(): string
	{
		return null;
	}
}
