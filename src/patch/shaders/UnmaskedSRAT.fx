/**
 * Non masked modern material with new artists pipeline
 *
 *  !!YAML
 *  Meta:
 *    Author: Alexander Fateev
 *    Version: 1.0.4
 *    License: Attribution-NonCommercial-ShareAlike 4.0 International
 *  DataSpecification:
 *    ShaderName: UnmaskedSRAT
 *    VertexType: XYZNT1T
 *    UVChannels: 1
 *    Requires:
 *      - "tlib.fx"
 *    Textures:
 *      Diffuse:
 *        Color: RGB
 *      Lightmap:
 *        Specular: R
 *        Reflect: G
 *        Ambient Occlusion: B
 *        Transparency: A
 *      Bump:
 *        Normal: RGB
 *      Cubemap:
 *        # Required value "lobbycube.dds"
 *        Color: RGB
 *  !!YAML
 *
 **/

#define ENABLE_REFLECTION
#define ENABLE_SPECULAR
#define ENABLE_AMBIENT

#include "template.fx"

DeclareTexture2D   (DIFFUSE_MAP_0, DiffuseTexture, DiffuseSampler, Wrap)
DeclareTexture2D   (BUMP_MAP_0,    BumpTexture,    BumpSampler,    Wrap)
DeclareTexture2D   (LIGHT_MAP_0,   LightTexture,   LightSampler,   Wrap)
DeclareTextureCube (CUBE_MAP_0,    CubeTexture,    CubeSampler,    Clamp)

float4 ViewerPosition: VIEW_POS <int Space = SPACE_OBJECT;>;
float3 LightDirection: TMP_LIGHT0_DIR <int Space = SPACE_OBJECT;>;

row_major float4x4 FinalMatrix: TOTAL_MATRIX;
row_major float4x4 WorldMatrix: WORLD_MATRIX;


struct VS_INPUT {
    float3 Position: POSITION;
    float3 Normal:   NORMAL;
    float4 Tangent:  TANGENT;
    float2 UVMap0:   TEXCOORD0;
};

struct VS_OUTPUT {
    float4 Position:      POSITION;
    float2 UVMap0:        TEXCOORD0;
    float4 Tangent:       TEXCOORD1;
    float3 Normal:        TEXCOORD2;
    float3 Binormal:      TEXCOORD3;
    float3 ViewDirection: TEXCOORD4;
    float  Fog:           FOG;
};

VS_OUTPUT SkinnedVS(VS_INPUT input) {
    VS_OUTPUT output = (VS_OUTPUT) 0;

    output.Position      = mul(float4(input.Position, 1.0), FinalMatrix);
    output.UVMap0        = input.UVMap0;
    output.Normal        = input.Normal;
    output.Tangent       = input.Tangent;
    output.Binormal      = cross(input.Normal, input.Tangent) * input.Tangent.w;
    output.ViewDirection = normalize(ViewerPosition - input.Position);
    output.Fog           = fog(output.Position, g_FogTerm);

    return output;
}

float4 SkinnedPS(VS_OUTPUT input) : COLOR {
    float4 Diffuse = tex2D(DiffuseSampler, input.UVMap0);
    float4 Bump    = tex2D(BumpSampler, input.UVMap0);
    float4 Params  = tex2D(LightSampler, input.UVMap0);
    float3 Normal  = bump(Bump.rgb, input.Normal, input.Tangent, input.Binormal);
    float3 UVMap1  = reflection(-input.ViewDirection, Normal, WorldMatrix);
    float4 Cubemap = texCUBE(CubeSampler, UVMap1);

    float Reflection = pow(Params.g, 2);
    float Coeficient = pow(Params.r, 2);

    return diffuse(
        input.ViewDirection,
        LightDirection,
        Diffuse.rgb,
        float3(0.0, 0.0, 0.0),
        Normal,
        Cubemap,
        Params.a * g_Transparent,
        Coeficient,
        Params.b,
        Reflection
    );
}

technique Skinned <bool   ComputeTangentSpace = true;
                   string VertexFormat = "VERTEX_XYZNT1T";
                   bool   Default = true;
                   bool   IsPs20 = true;
                   bool   UseAlpha = false;> {
    pass Default {
        VertexShader = compile vs_2_0 SkinnedVS();
        PixelShader  = compile ps_2_0 SkinnedPS();
    }
}