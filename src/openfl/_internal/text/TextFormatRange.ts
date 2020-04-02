import TextFormat from "../../text/TextFormat";

export default class TextFormatRange
{
	public end: number;
	public format: TextFormat;
	public start: number;

	public constructor(format: TextFormat, start: number, end: number)
	{
		this.format = format;
		this.start = start;
		this.end = end;
	}
}
