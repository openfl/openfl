package openfl._internal.aglsl;


class Mapping {
	
	
	public static var agal2glsllut (get, never):Array<OpLUT>;
	
	private static var _agal2glsllut:Array<OpLUT>;
	
	
	private static function get_agal2glsllut ():Array<OpLUT> {
		
		if (Mapping._agal2glsllut == null) {
			
			Mapping._agal2glsllut = [
				//         s 												flags   dest    a     b 	    mw 	  mh    ndwm  scale dm	  lod
				new OpLUT ("%dest = %cast(%a);\n", 0, true, true, false, null, null, null, null, null, null), //mov
				new OpLUT ("%dest = %cast(%a + %b);\n", 0, true, true, true, null, null, null, null, null, null), //add
				new OpLUT ("%dest = %cast(%a - %b);\n", 0, true, true, true, null, null, null, null, null, null), //sub
				new OpLUT ("%dest = %cast(%a * %b);\n", 0, true, true, true, null, null, null, null, null, null), //mul
				new OpLUT ("%dest = %cast(%a / %b);\n", 0, true, true, true, null, null, null, null, null, null), //div
				new OpLUT ("%dest = %cast(1.0) / %a;\n", 0, true, true, false, null, null, null, null, null, null), //rcp
				new OpLUT ("%dest = %cast(min(%a,%b));\n", 0, true, true, true, null, null, null, null, null, null), //min
				new OpLUT ("%dest = %cast(max(%a,%b));\n", 0, true, true, true, null, null, null, null, null, null), //max
				new OpLUT ("%dest = %cast(fract(%a));\n", 0, true, true, false, null, null, null, null, null, null), //frc
				new OpLUT ("%dest = %cast(sqrt(abs(%a)));\n", 0, true, true, false, null, null, null, null, null, null), //sqt
				new OpLUT ("%dest = %cast(inversesqrt(abs(%a)));\n", 0, true, true, false, null, null, null, null, null, null), //rsq
				new OpLUT ("%dest = %cast(pow(abs(%a),%b));\n", 0, true, true, true, null, null, null, null, null, null), //pow
				new OpLUT ("%dest = %cast(log2(abs(%a)));\n", 0, true, true, false, null, null, null, null, null, null), //log
				new OpLUT ("%dest = %cast(exp2(%a));\n", 0, true, true, false, null, null, null, null, null, null), //exp
				
				//         s 												flags  	dest    a     b 	    mw 	  mh    ndwm  scale dm	  lod
				new OpLUT ("%dest = %cast(normalize(vec3( %a ) ));\n", 0, true, true, false, null, null, true, null, null, null), //nrm
				new OpLUT ("%dest = %cast(sin(%a));\n", 0, true, true, false, null, null, null, null, null, null), //sin
				new OpLUT ("%dest = %cast(cos(%a));\n", 0, true, true, false, null, null, null, null, null, null), //cos
				new OpLUT ("%dest = %cast(cross(vec3(%a),vec3(%b)));\n", 0, true, true, true, null, null, true, null, null, null), //crs
				new OpLUT ("%dest = %cast(dot(vec3(%a),vec3(%b)));\n", 0, true, true, true, null, null, true, null, null, null), //dp3
				new OpLUT ("%dest = %cast(dot(vec4(%a),vec4(%b)));\n", 0, true, true, true, null, null, true, null, null, null), //dp4
				new OpLUT ("%dest = %cast(abs(%a));\n", 0, true, true, false, null, null, null, null, null, null), //abs
				new OpLUT ("%dest = %cast(%a * -1.0);\n", 0, true, true, false, null, null, null, null, null, null), //neg
				new OpLUT ("%dest = %cast(clamp(%a,0.0,1.0));\n", 0, true, true, false, null, null, null, null, null, null), //sat
				new OpLUT ("%dest = %cast(dot(vec3(%a),vec3(%b)));\n", null, true, true, true, 3, 3, true, null, null, null), //m33
				new OpLUT ("%dest = %cast(dot(vec4(%a),vec4(%b)));\n", null, true, true, true, 4, 4, true, null, null, null), //m44
				new OpLUT ("%dest = %cast(dot(vec4(%a),vec4(%b)));\n", null, true, true, true, 4, 3, true, null, null, null), //m43
				new OpLUT ("%dest = %cast(dFdx(%a));\n", 0, true, true, false, null, null, null, null, null, null), //dFdx
				new OpLUT ("%dest = %cast(dFdx(%a));\n", 0, true, true, false, null, null, null, null, null, null), //dFdx
				new OpLUT ("if (float(%a)==float(%b)) {;\n", 0, false, true, true, null, null, null, true, null, null),
				new OpLUT ("if (float(%a)!=float(%b)) {;\n", 0, false, true, true, null, null, null, true, null, null),
				new OpLUT ("if (float(%a)>=float(%b)) {;\n", 0, false, true, true, null, null, null, true, null, null),
				new OpLUT ("if (float(%a)<float(%b)) {;\n", 0, false, true, true, null, null, null, true, null, null),
				new OpLUT ("} else {;\n", 0, false, false, false, null, null, null, null, null, null),
				new OpLUT ("};\n", 0, false, false, false, null, null, null, null, null, null),
				new OpLUT (null, null, null, null, false, null, null, null, null, null, null),
				new OpLUT (null, null, null, null, false, null, null, null, null, null, null),
				new OpLUT (null, null, null, null, false, null, null, null, null, null, null),
				new OpLUT (null, null, null, null, false, null, null, null, null, null, null),
				
				//         s 															flags  	dest    a     b 	    mw 	  mh    ndwm  scale dm	  lod 
				new OpLUT ("%dest = %cast(texture%texdimLod(%b,%texsize(%a)).%dm);\n", null, true, true, true, null, null, null, null, true, null),
				new OpLUT ("if ( float(%a)<0.0 ) discard;\n", null, false, true, false, null, null, null, true, null, null),
				new OpLUT ("%dest = %cast(texture%texdim(%b,%texsize(%a)%lod).%dm);\n", null, true, true, true, null, null, true, null, true, true),
				new OpLUT ("%dest = %cast(greaterThanEqual(%a,%b).%dm);\n", 0, true, true, true, null, null, true, null, true, null),
				new OpLUT ("%dest = %cast(lessThan(%a,%b).%dm);\n", 0, true, true, true, null, null, true, null, true, null),
				new OpLUT ("%dest = %cast(sign(%a));\n", 0, true, true, false, null, null, null, null, null, null),
				new OpLUT ("%dest = %cast(equal(%a,%b).%dm);\n", 0, true, true, true, null, null, true, null, true, null),
				new OpLUT ("%dest = %cast(notEqual(%a,%b).%dm);\n", 0, true, true, true, null, null, true, null, true, null)
				
			];
			
		}
		
		return Mapping._agal2glsllut;
		
	}
	
	
}