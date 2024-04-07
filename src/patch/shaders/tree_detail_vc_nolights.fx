//////////////////////////////////////////////////////////////////////////////
//
// Workfile: tree_detail_vc_noLights.fx
// Created by: Plus
//
// simple plant shader (w/ vertex colors & detail texture)
//
// $Id: tree_detail_vc_noLights.fx,v 1.3 2005/06/02 13:16:53 goryh Exp $
//
//////////////////////////////////////////////////////////////////////////////

#include "data/shaders/lib.fx"

// diffuse and detail texture
texture 		DiffMap0	: DIFFUSE_MAP_0;
texture			DetailMap	: DETAIL_MAP_0;


// Diffuse color
shared const float2 g_FogTerm : FOG_TERM = { 1.0f, 800.0f };
shared const float4 g_PlantColor : LIGHT_PLANT = { 1.0f, 1.0f, 1.0f, 1.0f };
shared const float3  g_BendTerm  : TREE_BEND_TERM;


// transformations
row_major float4x4 mFinal	 : TOTAL_MATRIX;


// declare base diffuse sampler
DECLARE_DIFFUSE_SAMPLER( DiffSampler, DiffMap0 )

// declare detail sampler
DECLARE_DETAIL_SAMPLER( DetailSampler, DetailMap )

// Vertex shader input structure
struct VS_INPUT
{
	float3 Pos	     : POSITION;		// position in object space
	//float3 Normal	     : NORMAL;			// normal in object space
	float2 Tex0	     : TEXCOORD0;		// diffuse texcoords
	float2 Tex1	     : TEXCOORD1;		// detail texture texcoords
	float4 VertColor : COLOR0;			// vertex color
};

// Vertex shader output structure (for ps_1_1)
struct VS11_OUTPUT
{
	float4 Pos		     : POSITION;
	float2 Tex0		     : TEXCOORD0;
	float2 Tex1			: TEXCOORD1;
	float4 VertColor	: COLOR0;		// Vertex color
	float  fog		     : FOG;
};


/**
	Simple diffuse vertex shader for ps_1_1
 */
VS11_OUTPUT PS11_PlantVS( VS_INPUT In )
{
	VS11_OUTPUT Out = ( VS11_OUTPUT )0;

	if( In.Pos.y >= 0.0f )
	{
		In.Pos.xz += g_BendTerm.xy * In.Pos.y;
	}


	// Position ( projected )
	Out.Pos         = mul( float4( In.Pos, 1 ) , mFinal );
	// Texture coordinate
	Out.Tex0	    = In.Tex0;
	// Detail texture coordinate
	Out.Tex1	    = In.Tex1;
	// Vertex color
	Out.VertColor   = In.VertColor;       

	// Fog coeff
	Out.fog 	    = VertexFog( Out.Pos.z, g_FogTerm );

	return Out;
}


/**
	Simple diffuse pixel shader for ps_1_1
 */
float4 PS11_PlantPS( VS11_OUTPUT In, uniform float4 plantColor ): COLOR
{
	// base color
	float4 color = tex2D( DiffSampler, In.Tex0 ) * plantColor * In.VertColor;
	
// full color
	return color * tex2D( DetailSampler, In.Tex1 ) * 2;
}


technique TreeTech
<
	string 	Description = "plant shader w/ vertex colors and detail texture (w/o lighting)";
	bool   	ComputeTangentSpace = false;
	string 	VertexFormat = "VERTEX_XYZNT1";
	bool	Default = true;
>
{
	pass P1
	{
		VertexShader = compile vs_1_1 PS11_PlantVS();
		PixelShader = compile ps_1_1 PS11_PlantPS( g_PlantColor );
		
		//FogEnable        = true;
		//CullMode	     = CCW;
		//FillMode	     = Solid;
		//ZWriteEnable     = true;
		//AlphaBlendEnable = false;
		//AlphaTestEnable  = true;
		//AlphaFunc = GreaterEqual;
		//AlphaRef = 100;
	}
}