import DisplayObject from "./DisplayObject";


declare namespace openfl.display {

export class Shape extends DisplayObject {

	constructor();
	graphics:any;
	shader:any;
	get_graphics():any;


}

}

export default openfl.display.Shape;