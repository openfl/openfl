import Error from "openfl/errors/Error";

export default class TypeError extends Error
{
	public constructor(message: string = "")
	{
		super(message, 0);

		this.name = "TypeError";
	}
}
