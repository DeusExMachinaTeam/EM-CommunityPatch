/**
 *  Custom Specular shader
 *
 *  Meta:
 *    Author: Alexander Fateev
 *    Version: 1.0.1
 *    License: Attribution-NonCommercial-ShareAlike 4.0 International
 *
 * !!DataSpecification:
 *    ShaderName: Diffuse
 *    VertexType: XYZNT1T
 *    UVChannels: 1
 *    Requires:
 *      - "template.fx"
 *    Textures:
 *      Diffuse:
 *        Color: RGB
 *        Specular: A
 **/

#define ENABLE_SPECULAR
#define ENABLE_AMBIENT
#include "template.fx"

DeclareTexture2D(DIFFUSE_MAP_0, DiffuseTexture, DiffuseSampler, Wrap)
DeclareTexture2D(BUMP_MAP_0, BumpTexture, BumpSampler, Wrap)

float3 LightDirection: TMP_LIGHT0_DIR<int Space = SPACE_OBJECT;>;
float4 ViewPosition: VIEW_POS<int Space = SPACE_OBJECT;>;
row_major float4x4 FinalMatrix: TOTAL_MATRIX;

struct VS_INPUT {
    float3 Position: POSITION;
    float3 Normal: NORMAL;
    float2 UVMap0: TEXCOORD0;
	float4 Tangent: TANGENT;
    float4 Color: COLOR0;
};

struct VS_OUTPUT{
    float4 Position: POSITION;
    float2 UVMap0: TEXCOORD0;
    float3 Normal: TEXCOORD1;
    float3 ViewDirection: TEXCOORD4;
    float4 Color: COLOR0;
    float  Fog: FOG;
};

VS_OUTPUT VertexSpecular(VS_INPUT input) {
    VS_OUTPUT output = (VS_OUTPUT)0;

    output.Position      = mul(float4(input.Position, 1.0f), FinalMatrix);;
    output.UVMap0        = input.UVMap0;
    output.Normal        = input.Normal; 
    output.Color         = input.Color;
    output.ViewDirection = normalize(ViewPosition - input.Position);
    output.Fog           = fog(output.Position, g_FogTerm);

    return output;
}

float4 FragmentSpecular(VS_OUTPUT input) : COLOR {
    float4 Diffuse  = tex2D(DiffuseSampler, input.UVMap0);

    return diffuse(
        input.ViewDirection,
        LightDirection,
        Diffuse.rgb,
        float3(0, 0, 0),
        input.Normal,
        float3(0, 0, 0),
        1,
        Diffuse.a,
        pow(input.Color.r, 1.25),
        0
    );
};

technique Specular <bool   ComputeTangentSpace = false;
                   string VertexFormat = "VERTEX_XYZNT1T";
                   bool   Default = true;
                   bool   IsPs20 = true;
                   bool   UseAlpha = true;> {
    pass Default {
        VertexShader = compile vs_2_0 VertexSpecular();
        PixelShader  = compile ps_2_0 FragmentSpecular();
    }
}