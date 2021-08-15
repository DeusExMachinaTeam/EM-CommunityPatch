/**
 *  Custom Diffuse + Detail shader
 *
 *  Meta:
 *    Author: Alexander Fateev
 *    Version: 1.0.1
 *    License: Attribution-NonCommercial-ShareAlike 4.0 International
 *
 * !!DataSpecification:
 *    ShaderName: Diffuse
 *    VertexType: XYZNCT2
 *    UVChannels: 2
 *    Requires:
 *      - "template.fx"
 *    Textures:
 *      Diffuse:
 *        Color: RGB
 *        Transparency: A
 *      Detail:
 *        Color: RGB
 **/
#define ENABLE_AMBIENT
#include "template.fx"

DeclareTexture2D(DIFFUSE_MAP_0, DiffuseTexture, DiffuseSampler, Wrap)
DeclareTexture2D(DETAIL_MAP_0, DetailsTexture, DetailsSampler, Wrap)

float3 LightDirection: TMP_LIGHT0_DIR<int Space = SPACE_OBJECT;>;
float4 ViewPosition: VIEW_POS<int Space = SPACE_OBJECT;>;
row_major float4x4 FinalMatrix: TOTAL_MATRIX;

struct VS_INPUT {
    float3 Position: POSITION;
    float3 Normal: NORMAL;
    float2 UVMap0: TEXCOORD0;
    float2 UVMap1: TEXCOORD1;
    float4 Color: COLOR0;
};

struct VS_OUTPUT{
    float4 Position: POSITION;
    float2 UVMap0: TEXCOORD0;
    float2 UVMap1: TEXCOORD1;
    float3 Normal: TEXCOORD2;
    float3 ViewDirection: TEXCOORD3;
    float4 Color: COLOR0;
    float  Fog: FOG;
};

VS_OUTPUT VertexDiffuseDetail(VS_INPUT input) {
    VS_OUTPUT output = (VS_OUTPUT)0;

    output.Position      = mul(float4(input.Position, 1.0f), FinalMatrix);;
    output.UVMap0        = input.UVMap0;
    output.UVMap1        = input.UVMap1;
    output.Normal        = input.Normal;
    output.Color         = input.Color;
    output.ViewDirection = normalize(ViewPosition - input.Position);
    output.Fog           = fog(output.Position, g_FogTerm);

    return output;
}

float4 FragmentDiffuseDetail(VS_OUTPUT input) : COLOR {
    float4 Diffuse = tex2D(DiffuseSampler, input.UVMap0);
    float4 Details = tex2D(DetailsSampler, input.UVMap1);

    return diffuse(
        input.ViewDirection,
        LightDirection,
        Diffuse.rgb * Details.rgb * 2.0,
        float3(0, 0, 0),
        input.Normal,
        float3(0, 0, 0),
        Diffuse.a,
        0,
        pow(input.Color.r, 1.25),
        0
    );
};

technique DiffuseDetail <bool   ComputeTangentSpace = false;
                   string VertexFormat = "VERTEX_XYZNT2";
                   bool   Default = true;
                   bool   IsPs20 = true;
                   bool   UseAlpha = true;> {
    pass Default {
        VertexShader = compile vs_2_0 VertexDiffuseDetail();
        PixelShader  = compile ps_2_0 FragmentDiffuseDetail();
    }
}