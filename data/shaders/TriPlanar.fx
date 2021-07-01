#include "lib.fx"
#include "tlib.fx"

#ifndef SPECULAR_POWER
#define SPECULAR_POWER 8
#endif

texture DiffuseTexture: DIFFUSE_MAP_0;
DECLARE_DIFFUSE_SAMPLER(DiffuseSampler, DiffuseTexture)

texture NormalTexture:  BUMP_MAP_0;
DECLARE_BUMP_SAMPLER(NormalSampler, NormalTexture)

texture DetailTexture:  DETAIL_MAP_0;
DECLARE_DIFFUSE_SAMPLER(DetailSampler, DetailTexture)

float4 ViewerPosition: VIEW_POS <int Space = SPACE_OBJECT;>;
float3 LightDirection: TMP_LIGHT0_DIR <int Space = SPACE_OBJECT;>;

row_major float4x4 FinalMatrix: TOTAL_MATRIX;

shared const float4 g_Ambient:     LIGHT_AMBIENT  = {0.2f, 0.2f, 0.2f, 1.0f};
shared const float4 g_Diffuse:     LIGHT_DEFFUSE  = {1.0f, 1.0f, 1.0f, 1.0f};
shared const float3 g_Specular:    LIGHT_SPECULAR = {1.0f, 1.0f, 1.0f};
shared const float2 g_FogTerm:     FOG_TERM       = {1.0f, 800.0f};
shared const float  g_Transparent: TRANSPARENCY   = 1.0f;

struct VS_INPUT {
    float3 Position: POSITION;
    float3 Normal:   NORMAL;
    float4 Tangent:  TANGENT;
    float2 UVMap0:   TEXCOORD0;
};

struct VS_OUTPUT {
    float4 Position:      POSITION;
    float2 UVMap0:        TEXCOORD0;
    float3 UVMap1:        TEXCOORD1;
    float4 Tangent:       TEXCOORD2;
    float3 Binormal:      TEXCOORD3;
    float3 Normal:        TEXCOORD4;
    float3 ViewDirection: TEXCOORD5;
    float  Fog:           FOG;
};

VS_OUTPUT VertexTriPlanar(VS_INPUT input) {
    VS_OUTPUT output = (VS_OUTPUT) 0;

    output.Position = mul(float4(input.Position, 1.0), FinalMatrix);
    output.UVMap0   = input.UVMap0;
    output.UVMap1   = input.Position / 16; //mul(float4(input.Position, 1.0), WorldMatrix).xyz;
    output.Tangent  = input.Tangent;
    output.Binormal = cross(input.Normal, input.Tangent) * input.Tangent.w;
    output.Normal   = input.Normal;
    output.Fog      = VertexFog(output.Position, g_FogTerm);

    return output;
};

float4 FragmentTriPlanar(VS_OUTPUT input,
                         uniform float4 AmbientColor,
                         uniform float4 DiffuseColor,
                         uniform float3 SpecularColor) : COLOR {

    float4 XYColor = tex2D(DiffuseSampler, input.UVMap1.xy);
    float4 ZYColor = tex2D(DiffuseSampler, input.UVMap1.zy);
    float4 ZXColor = tex2D(DiffuseSampler, input.UVMap1.zx);

    float4 XYBump = tex2D(NormalSampler, input.UVMap1.xy);
    float4 ZYBump = tex2D(NormalSampler, input.UVMap1.zy);
    float4 ZXBump = tex2D(NormalSampler, input.UVMap1.zx);

    float3 NormalDir = float3(
        abs(dot(input.Normal, float3(1, 0, 0))),
        abs(dot(input.Normal, float3(0, 1, 0))),
        abs(dot(input.Normal, float3(0, 0, 1)))
    );

    float4 Color = ZXColor;
    Color = lerp(Color, XYColor, NormalDir.z);
    Color = lerp(Color, ZYColor, NormalDir.x);
    Color = lerp(Color, ZXColor, NormalDir.y);
    
    float4 Bump = ZXBump;
    Bump = lerp(Bump, XYBump, NormalDir.z);
    Bump = lerp(Bump, ZYBump, NormalDir.x);
    Bump = lerp(Bump, ZXBump, NormalDir.y);
    Bump.xyz = Bump.xyz * 2.0 - 1.0;

    float4 Detail = tex2D(DetailSampler, input.UVMap0);

    float3 Normal = mul(Bump, float3x3(input.Tangent.xyz, input.Binormal, input.Normal));
    float  NdotL  = dot(Normal, -LightDirection);
    float  NrefL  = reflect(Normal, -input.ViewDirection);

    float  LightPower = CalcLight(NdotL);
    float3 Specular   = CalcSpecular(NrefL, -input.ViewDirection, Bump.a, SPECULAR_POWER, SpecularColor) * LightPower;
    float3 Light      = lerp(AmbientColor, AmbientColor + DiffuseColor.rgb, LightPower);

    Color.rgb *= Detail.rgb;
    Color.rgb *= Light;
    Color.rgb += Specular;

    return float4(Color.rgb, Color.a * g_Transparent);
};

technique TriPlanar <bool   ComputeTangentSpace = true;
                     string VertexFormat = "VERTEX_XYZNT1T";
                     bool   Default = true;
                     bool   IsPs20 = true;
                     bool   UseAlpha = true;> {
    pass Default {
        VertexShader = compile vs_2_0 VertexTriPlanar();
        PixelShader  = compile ps_2_0 FragmentTriPlanar(g_Ambient, g_Diffuse, g_Specular);
    }
}