#define ENABLE_REFLECTION
#include "template.fx"


DeclareTexture2D   (DIFFUSE_MAP_0, DiffuseTexture, DiffuseSampler, Wrap)
DeclareTexture2D   (BUMP_MAP_0,    BumpTexture,    BumpSampler,    Wrap)
DeclareTextureCube (CUBE_MAP_0,    CubeTexture,    CubeSampler,    Clamp)


float3 LightDirection: TMP_LIGHT0_DIR<int Space = SPACE_OBJECT;>;
float4 ViewPosition: VIEW_POS<int Space = SPACE_OBJECT;>;
row_major float4x4 FinalMatrix:   TOTAL_MATRIX;
row_major float4x4 WorldMatrix:   WORLD_MATRIX;
row_major float4x4 InverseMatrix: INV_WORLD_MATRIX;


struct VS_INPUT {
    float3  Position: POSITION;
    float3  Normal:   NORMAL;
    float4  Tangent:  TANGENT;
    float2  UVMap0:   TEXCOORD0;
};


struct VS_OUTPUT {
    float4 Position:      POSITION;
    float2 UVMap0:        TEXCOORD0;
    float3 Normal:        TEXCOORD1;
    float4 Tangent:       TEXCOORD2;
    float3 Binormal:      TEXCOORD3;
    float3 ViewDirection: TEXCOORD4;
    float  Fog:           FOG;
};


VS_OUTPUT VertexBumpEnv(VS_INPUT input) {
    VS_OUTPUT output = (VS_OUTPUT) 0;

    output.Position      = mul(float4(input.Position, 1.0), FinalMatrix);
    output.UVMap0        = input.UVMap0;
    output.Normal        = input.Normal;
    output.Tangent       = input.Tangent;
    output.Binormal      = binormal(input.Normal, input.Tangent);
    output.ViewDirection = normalize(ViewPosition - input.Position);
    output.Fog           = fog(output.Position, g_FogTerm);

    return output;
};


float4 FragmentBumpEnv(VS_OUTPUT input) : COLOR {
    float4 Diffuse = tex2D(DiffuseSampler, input.UVMap0);
    float4 Bump    = tex2D(BumpSampler, input.UVMap0);
    float3 Normal  = bump(Bump.rgb, input.Normal, input.Tangent, input.Binormal);
    float3 UVMap1  = reflection(input.ViewDirection, Normal, WorldMatrix);
    float4 Cubemap = texCUBE(CubeSampler, UVMap1);

    return diffuse(
        input.ViewDirection,
        LightDirection,
        Diffuse.rgb,
        float3(0, 0, 0),
        Normal,
        Cubemap,
        Diffuse.a,
        0,
        1,
        Bump.a
    );
};


technique BumpEnv <bool   ComputeTangentSpace = true;
                   string VertexFormat = "VERTEX_XYZNT1T";
                   bool   Default = true;
                   bool   IsPs20 = true;
                   bool   UseAlpha = false;> {
    pass Default {
        VertexShader = compile vs_2_0 VertexBumpEnv();
        PixelShader = compile ps_2_0 FragmentBumpEnv();
    }
}
