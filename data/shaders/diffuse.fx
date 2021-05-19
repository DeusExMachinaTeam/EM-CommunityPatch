/** Diffuse Shader for Hardtruck Apocalypce
 * 
 * Author:  Aleksandr Fateev (foggy1989@gmail.com)
 * Version: 2021-05-19
 * License: Attribution-NonCommercial-ShareAlike 4.0 International 
 *
 * https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode
 *
 **/

#include "lib.fx"
#include "tlib.fx"

#ifndef SPECULAR_POWER
#define SPECULAR_POWER 8
#endif

texture DiffuseTexture: DIFFUSE_MAP_0;
DECLARE_DIFFUSE_SAMPLER(DiffuseSampler, DiffuseTexture)

float4 ViewPosition: VIEW_POS<int Space = SPACE_WORLD;>;
float3 LightDirection: TMP_LIGHT0_DIR<int Space = SPACE_OBJECT;>;
row_major float4x4 FinalMatrix: TOTAL_MATRIX;

shared const float4 g_Ambient:     LIGHT_AMBIENT  = {0.2f, 0.2f, 0.2f, 1.0f};
shared const float4 g_Diffuse:     LIGHT_DEFFUSE  = {1.0f, 1.0f, 1.0f, 1.0f};
shared const float3 g_Specular:    LIGHT_SPECULAR = {1.0f, 1.0f, 1.0f};
shared const float2 g_FogTerm:     FOG_TERM       = {1.0f, 800.0f};
shared const float  g_Transparent: TRANSPARENCY   = 1.0f;

struct VS_INPUT {
    float3 Position: POSITION;
    float3 Normal: NORMAL;
    float2 UV0: TEXCOORD0;
};

struct VS_OUTPUT {
    float4 FinalPosition: POSITION;
    float2 UV0:           TEXCOORD0;
    float3 Normal:        TEXCOORD2;
    float3 ViewDirection: TEXCOORD4;
    float  Fog:           FOG;
};


VS_OUTPUT DiffuseVS(VS_INPUT input) {
    VS_OUTPUT output = (VS_OUTPUT) 0;

    float4 FinalPosition = mul(float4(input.Position, 1.0f), FinalMatrix);

    output.FinalPosition = FinalPosition;
    output.UV0           = input.UV0;

    output.Normal        = input.Normal;
    output.ViewDirection = normalize(ViewPosition - input.Position);
    output.Fog           = CalcFog(FinalPosition, g_FogTerm);
    return output;
};

float4 DiffusePS(VS_OUTPUT input,
                  uniform float4 AmbientColor,
                  uniform float4 DiffuseColor,
                  uniform float3 SpecularColor) : COLOR {

    float4 Diffuse = tex2D(DiffuseSampler, input.UV0);
    float3 Normal  = input.Normal;

    float  NdotL      = dot(Normal, -LightDirection);
    float  NdotV      = dot(Normal, -input.ViewDirection);
    float  LdotV      = dot(-LightDirection, input.ViewDirection);
    float3 NrefL      = reflect(-LightDirection, Normal);

    float  LightPower = CalcLight(NdotL);
    float3 Light      = lerp(AmbientColor, AmbientColor + DiffuseColor.rgb, LightPower);

    float3 Color = Diffuse.rgb;
    Color       *= Light;

    return float4(Color, g_Transparent * Diffuse.a);
};

technique Diffuse <bool   ComputeTangentSpace = true;
                             string VertexFormat = "VERTEX_XYZNT1";
                             bool   Default = true;
                             bool   IsPs20 = true;
                             bool   UseAlpha = false;> {
    pass Default {
        VertexShader = compile vs_2_0 DiffuseVS();
        PixelShader  = compile ps_2_0 DiffusePS(g_Ambient, g_Diffuse, g_Specular);
    }
}