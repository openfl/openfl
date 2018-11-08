#include "common.fxh"


MATRIX_ORDER float4x4 g_transform : register(c0);
float4 g_color : register (c4);


struct VS_IN {

	float3 Pos : POSITION;

};


struct VS_OUT {

	float4 ProjPos : VS_OUT_POSITION;
	float4 Color : COLOR;

};


VS_OUT main( VS_IN In ) {

	VS_OUT Out;
	Out.ProjPos = mul( g_transform, float4( In.Pos, 1 ) );
	Out.Color = g_color;
	//Out.Color.rgb = gammaToLinear(Out.Color.rgb);
	return Out;

}
