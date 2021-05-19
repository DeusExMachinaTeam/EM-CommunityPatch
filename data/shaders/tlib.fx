/** Core lib for Hard Truck Apocalypse
 * 
 * Author:  Aleksandr Fateev (foggy1989@gmail.com)
 * Version: 2021-05-10
 * License: Attribution-NonCommercial-ShareAlike 4.0 International 
 *
 * https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode
 *
 **/


#define PI 3.14159265


float3 CalcBinormal(float3 Normal, float4 Tangent) {
    return cross(Normal, Tangent) * Tangent.w;
};


float3 CalcNormal(float4 Bump, float3 Normal, float4 Tangent, float3 Binormal) {
    float3 bump = Bump.xyz * 2.0f - 1.0f;
    return normalize(mul(bump, float3x3(Tangent.xyz, Binormal, Normal)));
};


float3 CalcViewDir(float3 Viewer, float3 Position, float3 Normal, float4 Tangent, float3 Binormal) {
    float3 ViewDir = normalize(Viewer - Position);
    return (dot(ViewDir, Tangent.xyz), dot(ViewDir, Binormal), dot(ViewDir, Normal));
};


float3 CalcTangentDir(float3 dir, float3 Normal, float4 Tangent, float3 Binormal) {
    return normalize(mul(dir, float3x3(Tangent.xyz, Binormal, Normal)));
};


float OrenNayar(float LdotV,
                float NdotL,
                float NdotV,
                float Roughness,
                float Albedo) {

    float s = LdotV - NdotL * NdotV;
    float t = lerp(1.0, max(NdotL, NdotV), step(0.0f, s));

    float sigma = Roughness * Roughness;
    float A = 1.0f + sigma * (Albedo / (sigma + 0.13f) + 0.5f / (sigma + 0.33f));
    float B = 0.5f * sigma / (sigma + 0.1f);

    return Albedo * max(0.0f, NdotL) * (A + B * s / t) / PI;
};


// Simplest Lambert Light
float CalcLight(float  LdotV) {
    return saturate(max(0.0, LdotV));
};


float3 CalcSpecular(float3 NrefL,
                    float3 ViewDir,
                    float  Coeficient,
                    float  Power,
                    float3 Color) {
    float light = max(0.0, dot(NrefL, ViewDir));
    return pow(light, Power) * Coeficient * Color * Power;
};


float3 CalcReflection(samplerCUBE Cubemap,
                      float3 ViewDir,
                      float3 Normal,
                      float4x4 World) {
    float3 coords = mul(reflect(-ViewDir, Normal), World).xzy;
    return texCUBE(Cubemap, coords);
};

float CalcFog( float4 position, const float2 FogTerm ) {
	return saturate( ( FogTerm.x - position.z ) * FogTerm.y );
}