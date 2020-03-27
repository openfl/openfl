import MovieClip from "../display/MovieClip";

export default class Lib
{
	public static current: MovieClip;

	protected static __sentWarnings: Map<string, boolean> = new Map();

	public static notImplemented(): void
	{
		var api = arguments.callee.name;

		if (!Lib.__sentWarnings.has(api))
		{
			Lib.__sentWarnings.set(api, true);

			console.warn(api + " is not implemented");
		}
	}
}
