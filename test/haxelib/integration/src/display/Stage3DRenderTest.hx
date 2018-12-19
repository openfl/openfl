package display;


class Stage3DRenderTest {
	
	
	@AsyncTest public function createContext ():Void {
		
		var stage3D = Lib.current.stage.stage3Ds[0];
		
		if (stage3D != null) {
			
			var handler = Async.handler (this, function (event) {
				
				Assert.isNotNull (stage3D.context3D);
				
			});
			
			stage3D.addEventListener ("context3DCreate", handler);
			stage3D.requestContext3D ();
			
		}
		#end
		
	}
	
	
	
}