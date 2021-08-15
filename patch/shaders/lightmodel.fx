#ifndef SPECULAR_POWER
#define SPECULAR_POWER 8
#endif

float4 DSPMaterial(float3 ViewDir,
                   float3 LightDir,
                   float3 BaseColor,
                   float3 Emmisive,
                   float3 Normal,
                   float3 Cubemap,
                   float3 Specular,
                   float  Transparency,
                   float  Ambient,
                   float  Reflection) {
    float  NdotL = dot(-LightDir, Normal);
    float  NdotV = dot(-ViewDir, Normal);
    float  LdotV = dot(LightDir, ViewDir);
    float3 NrefL = reflect(-LightDir, Normal);
    float  RdotV = dot(NrefL, -ViewDir);

    float  luminance = max(0.0, NdotL);
    float3 light     = (luminance * g_Diffuse.rgb + g_Ambient.rgb) * Ambient;
    #ifdef SPECULAR
    float3 specular  = pow(max(0, RdotV) * luminance, SPECULAR_POWER) * g_Specular.rgb * Specular;
    #endif

    float3 color = BaseColor;
    #ifdef REFLECTION
    color        = lerp(color, Cubemap, Reflection);
    #endif
    color       *= light;
    #ifdef SPECULAR
    color       += specular;
    #endif
    #ifdef EMMISION
    color       += Emmisive;
    #endif

    return float4(color, Transparency * g_Transparent);
}