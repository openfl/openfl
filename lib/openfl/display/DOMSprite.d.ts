import Sprite from "./Sprite";


declare namespace openfl.display {
	
	
	export class DOMSprite extends Sprite {
		
		
		public constructor (element:HTMLElement);
		
		
	}
	
	
}


export default openfl.display.DOMSprite;