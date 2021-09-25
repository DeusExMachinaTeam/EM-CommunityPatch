//////////////////////////////////////////////////////////////////////////////
//
// Workfile: waterTest_vs11.vs
// Created by: Plus
//
// simple water vs11 shader w/ reflection/refraction 
// and per-vertex fresnel term
//
// so far, it's just a dummy, with no any perturbation
// (I have failed to archive it using hlsl...)
//
// $Id: waterTest_ps20.vs,v 1.8 2005/10/05 08:18:14 goryh Exp $
//
//////////////////////////////////////////////////////////////////////////////

#include "lib.fx"

// vertex model*view*projection
float4x4 mViewProj: register( c0 ); 
// texture model*view*projection
float4x4 mTexture: register( c4 );

//const float2 g_FogTerm: register( c9 );
float2 g_FogTerm: register( c9 );

// current time
const float timeVal: register( c10 );
const float4 waveSize: register( c11 );

// fresnel constants
const float fresnelBias: register( c12 );
const float fresnelScale: register( c13 );
const float fresnelPower: register( c14 );

const float3 lightDir: register( c15 );
// camera origin (world frame)
const float3 viewPos: register( c16 );

float distBetwVert: register( c17 );
/**
	vertices are packed:

	x - x offset from the begining of a water tile
	y - z offset from the begining of a water tile
	z - water tile index into waterTilesInfo[] array
 */

/**
	water tile info:

	x - starting x position (world frame)
	y - water height (world frame)
	z - starting z position (world frame)
 */
float4 waterTilesInfo[512]: register( c20 );


// vertex shader input structure
struct VS_INPUT
{
	int3 PackedPosInfo : POSITION;	// x, z, tileNum, 
};


// vertex shader output structure
struct VS_OUTPUT
{
	float4 Pos	: POSITION;
	float4 TexRefl	: TEXCOORD0;
	float4 TexRefr	: TEXCOORD1;
	float4 camDir	: TEXCOORD2;
	float4 sunDir   : TEXCOORD3;
	float4 Noise	: TEXCOORD4;
	float  fog	: FOG;
};


/// 
VS_OUTPUT WaterVS( VS_INPUT v )
{
	VS_OUTPUT o = (VS_OUTPUT)0;

	// unpack vertex pos
	int	tileInd = v.PackedPosInfo.z;
	float4	waterTileInfo = waterTilesInfo[tileInd];
	float4	worldPos;
	worldPos.xyz = waterTileInfo.xyz;
	worldPos.xz += distBetwVert * v.PackedPosInfo.xy;
	worldPos.w = 1;

        o.camDir.xyz = normalize( worldPos.xyz - viewPos.xyz );
	o.sunDir.xyz = float4( normalize( lightDir - worldPos.xyz ), 0);
        o.camDir.w = length( o.camDir.xyz ) / 35.f;
        
	o.Noise.x = waveSize.x * ( worldPos.z / 50.0 + sin( timeVal ) * 0.1 );    // small wave
	o.Noise.y = waveSize.x * ( worldPos.x / 50.0 - cos( timeVal ) * 0.1 );

	o.Noise.z = waveSize.y * ( worldPos.z / 50.0 + timeVal * waveSize.z );    // big wave
	o.Noise.w = waveSize.y * ( worldPos.x / 50.0 + timeVal * waveSize.w );
	
	// project position
	o.Pos = mul( worldPos, mViewProj );
	// project texcoords
	float4 texCoords = mul( worldPos, mTexture );
	o.TexRefl = texCoords;
	o.TexRefr = texCoords;
        o.TexRefl.w *= 1.115f;

	// fog terms
	o.fog = VertexFog( o.Pos.z, g_FogTerm );

	return o;
	}