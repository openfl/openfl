import ByteArray from "../../../../utils/ByteArray";
import Endian from "../../../../utils/Endian";

export default class Part
{
	public data: ByteArray;
	public name: string;
	public version: number;

	public constructor(name: string = "", version: number = 0)
	{
		this.name = name;
		this.version = version;

		this.data = new ByteArray();
		this.data.endian = Endian.LITTLE_ENDIAN;
	}
}
