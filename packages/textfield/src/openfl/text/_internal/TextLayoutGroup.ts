import TextFormat from "../../text/TextFormat";

// TODO: Need to measure all characters (including whitespace) but include a value for non-whitespace characters separately (for sake of alignment and wrapping)
export default class TextLayoutGroup
{
	public ascent: number;
	public descent: number;
	public endIndex: number;
	public format: TextFormat;
	public height: number;
	public leading: number;
	public lineIndex: number;
	public offsetX: number;
	public offsetY: number;
	public positions: Array<number>; // TODO: Make consistent with native?
	public startIndex: number;
	public width: number;

	public constructor(format: TextFormat, startIndex: number, endIndex: number)
	{
		this.format = format;
		this.startIndex = startIndex;
		this.endIndex = endIndex;
	}

	public getAdvance(index: number): number
	{
		return this.positions[index];
	}
}
