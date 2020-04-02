export default class Sampler
{
	public mask: number;
	public shift: number;
	public value: number;

	public constructor(shift: number, mask: number, value: number)
	{
		this.shift = shift;
		this.mask = mask;
		this.value = value;
	}
}
