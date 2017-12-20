import Sprite from "./Sprite";

declare namespace openfl.display {

export class DOMSprite extends Sprite {

	constructor(element:any);
	__active:any;
	__element:any;
	__renderDOM(renderSession:any):any;


}

}

export default openfl.display.DOMSprite;