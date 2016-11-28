package format.swf.lite;


import format.swf.lite.symbols.ButtonSymbol;


class SimpleButton extends flash.display.SimpleButton {
	
	
	@:noCompletion private var symbol:ButtonSymbol;
	
	
	public function new (swf:SWFLite, symbol:ButtonSymbol) {
		
		super ();
		
		this.symbol = symbol;
		
		if (symbol.downState != null) {
			
			downState = new MovieClip (swf, symbol.downState);
			
		}
		
		if (symbol.hitState != null) {
			
			hitTestState = new MovieClip (swf, symbol.hitState);
			
		}
		
		if (symbol.overState != null) {
			
			overState = new MovieClip (swf, symbol.overState);
			
		}
		
		if (symbol.upState != null) {
			
			upState = new MovieClip (swf, symbol.upState);
			
		}
		
	}
	
	
}