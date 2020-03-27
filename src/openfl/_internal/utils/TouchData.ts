import DisplayObject from "../../display/DisplayObject";
import InteractiveObject from "../../display/InteractiveObject";
import ObjectPool from "../utils/ObjectPool";

export default class TouchData
{
	public static __pool: ObjectPool<TouchData> = new ObjectPool<TouchData>(() => new TouchData(), (data) => data.reset());

	public rollOutStack: Array<DisplayObject>;
	public touchDownTarget: InteractiveObject;
	public touchOverTarget: InteractiveObject;

	public constructor()
	{
		this.rollOutStack = [];
	}

	public reset(): void
	{
		this.touchDownTarget = null;
		this.touchOverTarget = null;

		this.rollOutStack.splice(0, this.rollOutStack.length);
	}
}
