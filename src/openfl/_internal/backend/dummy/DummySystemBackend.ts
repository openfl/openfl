namespace openfl._internal.backend.dummy;

class DummySystemBackend
{
	public static exit(code: number): void { }

	public static gc(): void { }

	public static getTotalMemory(): number
	{
		return 0;
	}
}
