/**
 *  Skinned material for separate details and main color
 *
 *  Meta:
 *    Author: Alexander Fateev
 *    Version: 1.0.3
 *    License: Attribution-NonCommercial-ShareAlike 4.0 International
 *
 * !!DataSpecification:
 *    ShaderName: Skinned
 *    VertexType: XYZNT1T
 *    UVChannels: 1
 *    Requires:
 *      - "tlib.fx"
 *    Textures:
 *      Diffuse:
 *        Color: RGB
 *        Transparency: A
 *      Detail:
 *        Color: RGB
 *        Blend Coeficient: A
 *      Lightmap:
 *        Specular: R
 *        Reflect: G
 *        Ambient Occlusion: B
 *      Bump:
 *        Normal: RGB
 *      Cubemap:
 *        # Required value "lobbycube.dds"
 *        Color: RGB
 **/

#include "lib.fx"
#include "tlib.fx"

#ifndef SPECULAR_POWER
#define SPECULAR_POWER 8
#endif

texture DiffuseTexture: DIFFUSE_MAP_0;
DECLARE_DIFFUSE_SAMPLER(DiffuseSampler, DiffuseTexture)

texture DetailTexture:  DETAIL_MAP_0;
DECLARE_DIFFUSE_SAMPLER(DetailSampler, DetailTexture)

texture BumpTexture: BUMP_MAP_0;
DECLARE_BUMP_SAMPLER(BumpSampler, BumpTexture)

texture LightTexture: LIGHT_MAP_0;
DECLARE_DIFFUSE_SAMPLER(LightSampler, LightTexture)

texture EnvTexture: CUBE_MAP_0;
DECLARE_CUBEMAP_SAMPLER(EnvSampler, EnvTexture)

float4 ViewerPosition: VIEW_POS <int Space = SPACE_OBJECT;>;
float3 LightDirection: TMP_LIGHT0_DIR <int Space = SPACE_OBJECT;>;

row_major float4x4 FinalMatrix: TOTAL_MATRIX;
row_major float4x4 WorldMatrix: WORLD_MATRIX;

shared const float4 g_Ambient:     LIGHT_AMBIENT  = {0.2f, 0.2f, 0.2f, 1.0f};
shared const float4 g_Diffuse:     LIGHT_DEFFUSE  = {1.0f, 1.0f, 1.0f, 1.0f};
shared const float3 g_Specular:    LIGHT_SPECULAR = {1.0f, 1.0f, 1.0f};
shared const float2 g_FogTerm:     FOG_TERM       = {1.0f, 800.0f};
shared const float  g_Transparent: TRANSPARENCY   = 1.0f;

struct VS_INPUT {
    float3 Position: POSITION;
    float3 Normal: NORMAL;
    float4 Tangent: TANGENT;
    float2 UV0: TEXCOORD0;
};

struct VS_OUTPUT {
    float4 FinalPosition: POSITION;
    float2 UV0:           TEXCOORD0;
    float4 Tangent:       TEXCOORD1;
    float3 Normal:        TEXCOORD2;
    float3 Binormal:      TEXCOORD3;
    float3 ViewDirection: TEXCOORD4;
    float  Fog:           FOG;
};

VS_OUTPUT SkinnedVS(VS_INPUT input) {
    VS_OUTPUT output = (VS_OUTPUT) 0;

    float4 FinalPosition = mul(float4(input.Position, 1.0f), FinalMatrix);

    output.FinalPosition = FinalPosition;
    output.UV0           = input.UV0;

    output.Tangent       = input.Tangent;
    output.Normal        = input.Normal;
    output.Binormal      = cross(input.Normal, input.Tangent) * input.Tangent.w;
    output.ViewDirection = normalize(ViewerPosition - input.Position);
    output.Fog           = VertexFog(FinalPosition, g_FogTerm);
    return output;
}

float4 SkinnedPS(VS_OUTPUT input,
                           uniform float4 AmbientColor,
                           uniform float4 DiffuseColor,
                           uniform float3 SpecularColor) : COLOR {

    float4 Diffuse = tex2D(DiffuseSampler, input.UV0);
    float4 Mask    = tex2D(DetailSampler, input.UV0);
    float4 Params  = tex2D(LightSampler, input.UV0);

    float4 Bump    = tex2D(BumpSampler, input.UV0);
    Bump.xyz       = normalize(Bump.xyz * 2.0f - 1.0f);
    float3 Normal  = mul(Bump, float3x3(input.Tangent.xyz, input.Binormal, input.Normal));

    float Reflection = pow(Params.g, 2);
    float Coeficient = pow(Params.r, 2);

    #ifdef WEATHER
    if (SpecularColor.r > 0.97f) {
        Coeficient = min(1.0f, Coeficient + 0.25f);
        Reflection = min(1.0f, Reflection + 0.25f);
    }
    #endif

    float  NdotL      = dot(Normal, -LightDirection);
    float  NdotV      = dot(Normal, -input.ViewDirection);
    float  LdotV      = dot(-LightDirection, input.ViewDirection);
    float3 NrefL      = reflect(-LightDirection, Normal);

    float3 Cubemap    = CalcReflection(EnvSampler, input.ViewDirection, Normal, WorldMatrix);
    float  LightPower = CalcLight(NdotL);
    LightPower       *= Params.b;
    float3 Specular   = CalcSpecular(NrefL, -input.ViewDirection, Coeficient, SPECULAR_POWER, SpecularColor) * LightPower;
    float3 Light      = lerp(AmbientColor, AmbientColor + DiffuseColor.rgb, LightPower);
    Light            *= Params.b;

    float3 Final = lerp(Mask.rgb, Diffuse.rgb, Mask.a);
    Final        = lerp(Final, Cubemap, Reflection);
    Final       *= Light;
    Final       += Specular;

    return float4(Final, Diffuse.a * g_Transparent);
}

technique Skinned <bool   ComputeTangentSpace = true;
                   string VertexFormat = "VERTEX_XYZNT1T";
                   bool   Default = true;
                   bool   IsPs20 = true;
                   bool   UseAlpha = false;> {
    pass Default {
        VertexShader = compile vs_2_0 SkinnedVS();
        PixelShader  = compile ps_2_0 SkinnedPS(g_Ambient, g_Diffuse, g_Specular);
    }
}