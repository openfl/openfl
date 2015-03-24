//#include "gamma.fxh"
#include "common.fxh"


MATRIX_ORDER float4x4 g_transform : register (c0);
float4 g_color : register (c4);


struct VS_IN {

	float3 pos : POSITION;
	float2 texcoord : TEXCOORD;
	float4 color : COLOR;

};


struct VS_OUT {

	float4 projPos : VS_OUT_POSITION;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;

};


VS_OUT main (VS_IN In) {

	VS_OUT Out;
	Out.projPos = mul( g_transform, float4( In.pos, 1 ) );
	Out.color = In.color * g_color;
	//Out.color.rgb = gammaToLinear(Out.color.rgb);
	Out.texcoord = In.texcoord;
	return Out;

}
