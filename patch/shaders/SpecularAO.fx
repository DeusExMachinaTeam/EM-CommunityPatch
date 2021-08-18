/**
 *  Custom Diffuse + Specular + AO shader
 *
 *  Meta:
 *    Author: Alexander Fateev
 *    Version: 1.0.1
 *    License: Attribution-NonCommercial-ShareAlike 4.0 International
 *
 * !!DataSpecification:
 *    ShaderName: SpecularAO
 *    VertexType: XYZNT2
 *    UVChannels: 2
 *    Requires:
 *      - "tlib.fx"
 *      - "lightmodel.fx"
 *    Textures:
 *      Diffuse:
 *        Color: RGB
 *        Specular: A
 *      Lightmap:
 *        # Required value "lobbycube.dds"
 *        AO: R
 **/

#define SPECULAR 1

shared const float4 g_Ambient:     LIGHT_AMBIENT  = {0.2f, 0.2f, 0.2f, 1.0f};
shared const float4 g_Diffuse:     LIGHT_DIFFUSE  = {1.0f, 1.0f, 1.0f, 1.0f};
shared const float3 g_Specular:    LIGHT_SPECULAR = {1.0f, 1.0f, 1.0f};
shared const float2 g_FogTerm:     FOG_TERM       = {1.0f, 800.0f};
shared const float  g_Transparent: TRANSPARENCY   = 1.0f;

#include "lib.fx"
#include "tlib.fx"
#include "lightmodel.fx"

texture DiffuseTexture: DIFFUSE_MAP_0;
DECLARE_DIFFUSE_SAMPLER(DiffuseSampler, DiffuseTexture)

texture LightmapTexture: LIGHT_MAP_0;
DECLARE_DIFFUSE_SAMPLER(LightmapSampler, LightmapTexture)

float4 ViewPosition: VIEW_POS<int Space = SPACE_OBJECT;>;
float3 LightDirection: TMP_LIGHT0_DIR<int Space = SPACE_OBJECT;>;
row_major float4x4 FinalMatrix: TOTAL_MATRIX;

struct VS_INPUT {
	float3 Position : POSITION;
	float3 Normal   : NORMAL;
	float2 UVMap0   : TEXCOORD0;
	float2 UVMap1   : TEXCOORD1;
};

struct VS_OUTPUT {
    float4 FinalPosition : POSITION;
    float2 UVMap0        : TEXCOORD0;
    float2 UVMap1        : TEXCOORD1;
    float3 Normal        : TEXCOORD2;
    float3 ViewDirection : TEXCOORD4;
    float  Fog           : FOG;
};

VS_OUTPUT VertexSpecularAO(VS_INPUT input) {
    VS_OUTPUT output = (VS_OUTPUT) 0;

    output.FinalPosition = mul(float4(input.Position, 1.0f), FinalMatrix);;
    output.UVMap0        = input.UVMap0;
    output.UVMap1        = input.UVMap1;
    output.Normal        = input.Normal;
    output.ViewDirection = normalize(ViewPosition - input.Position);
    output.Fog           = CalcFog(output.FinalPosition, g_FogTerm);
    return output;
}

float4 FragmentSpecularAO(VS_OUTPUT input) : COLOR {

    float4 Lightmap = tex2D(LightmapSampler, input.UVMap1);
    float4 Diffuse  = tex2D(DiffuseSampler, input.UVMap0);
    float  Specular = pow(Diffuse.a, 2);

    return DSPMaterial(
        input.ViewDirection,
        LightDirection,
        Diffuse.rgb,
        float3(0, 0, 0),
        input.Normal,
        float3(0, 0, 0),
        Specular,
        1,
        pow(Lightmap.r, 1.25),
        0
    );
};

technique SpecularAO <bool ComputeTangentSpace = true;
                           string VertexFormat = "VERTEX_XYZNT2";
                           bool   Default = true;
                           bool   IsPs20 = true;
                           bool   UseAlpha = false;> {
    pass Default {
        VertexShader = compile vs_2_0 VertexSpecularAO();
        PixelShader  = compile ps_2_0 FragmentSpecularAO();
    }
}