/**
 *  Base library for all shaders
 *
 *  Meta:
 *    Author: Alexander Fateev
 *    Version: 1.1.1
 *    License: Attribution-NonCommercial-ShareAlike 4.0 International
 *
 **/

#ifndef MIN_MAG_FILTER
#define MIN_MAG_FILTER Linear
#endif


#ifndef MIP_FILTER
#define MIP_FILTER Point
#endif


#ifndef SPECULAR_POWER
#define SPECULAR_POWER 4
#endif

#ifndef SPECULAR_MULTIPLY
#define SPECULAR_MULTIPLY 4
#endif


#define SPACE_OBJECT 1
#define SPACE_WORLD  2
#define SPACE_VIEW   3


#define DeclareTexture2D(slot, texture_name, sampler_name, mapping) \
texture texture_name: slot;          \
sampler sampler_name = sampler_state \
{                                    \
    Texture = <texture_name>;        \
    AddressU  = mapping;             \
    AddressV  = mapping;             \
    MinFilter = MIN_MAG_FILTER;      \
    MagFilter = MIN_MAG_FILTER;      \
};


#define DeclareTextureCube(slot, texture_name, sampler_name, mapping) \
texture texture_name: slot;             \
samplerCUBE sampler_name = sampler_state\
{						                \
	Texture = <texture_name>;           \
	AddressU = mapping;                 \
	AddressV = mapping;                 \
	AddressW = mapping;                 \
	MinFilter = Linear;                 \
	MagFilter = Linear;                 \
	MipFilter = Linear;                 \
};



static const float PI = 3.141592;
static const float Epsilon = 0.00001;
static const float3 Fdielectric = 0.04;

shared const float4 g_Ambient:     LIGHT_AMBIENT  = {0.2f, 0.2f, 0.2f, 1.0f};
shared const float4 g_Diffuse:     LIGHT_DIFFUSE  = {1.0f, 1.0f, 1.0f, 1.0f};
shared const float3 g_Specular:    LIGHT_SPECULAR = {1.0f, 1.0f, 1.0f};
shared const float2 g_FogTerm:     FOG_TERM       = {1.0f, 800.0f};
shared const float  g_Transparent: TRANSPARENCY   = 1.0f;


float3 binormal(float3 normal, float4 tangent) {
    return cross(normal, tangent.xyz) * tangent.w;
};


float3 reflection(float3 View, float3 Normal, float4x4 World) {
    return normalize(mul(reflect(View, Normal), World));
};


float3 bump(float3 color, float3 normal, float3 tangent, float3 binormal) {
    float3 bump = color * 2.0f - 1.0f;
    return normalize(mul(bump, float3x3(tangent.xyz, binormal.xyz, normal.xyz)));
};


float fog(float3 position, float2 config) {
    return saturate((config.x - position.z) * config.y);
};


float4 diffuse(float3 dir_view,
               float3 dir_light,
               float3 Color,
               float3 Emmisive,
               float3 Normal,
               float3 Cubemap,
               float  Opacity,
               float  Specular,
               float  Ambient,
               float  Reflection) {
    dir_light = normalize(dir_light);

    float3 NrefL = reflect(-dir_light, Normal);
    float  NdotL = dot    (-dir_light, Normal);
    float  NdotV = dot    (-dir_view,  Normal);
    float  LdotV = dot    ( dir_light, dir_view);
    float  RdotV = dot    ( NrefL,    -dir_view);

    float  luminance = max(0.0, NdotL);
    float3 light = g_Ambient.rgb + g_Diffuse.rgb * luminance;

    float3 color = Color;

    #ifdef ENABLE_REFLECTION
    color = lerp(color, Cubemap, Reflection);
    #endif

    color *= light;

    #ifdef ENABLE_SPECULAR
    float3 specular = pow(max(0, RdotV) * luminance * Specular, SPECULAR_POWER) * g_Specular.rgb * SPECULAR_MULTIPLY;
    color += specular;
    #endif

    #ifdef ENABLE_AMBIENT
    color *= Ambient;
    #endif

    #ifdef ENABLE_EMMISION
    color += Emmisive;
    #endif

    #ifdef GLOBAL_OPACITY
    Opacity *= g_Transparent;
    #endif

    return float4(color, Opacity);
};

/**
 * Expiremental PBR material
 **/
float pbr_particial_geometry(float cosN, float a) {
    float sqr = saturate(cosN * cosN);
    return 2 / (1 + sqrt(1 + a * a * ((1 - sqr) / sqr)));
};

float pbr_distribution(float cosN, float a) {
    float sqrn = saturate(cosN * cosN);
    float sqra = a * a;
    float den  = sqrn * sqra + (1.0 - sqrn);
    return sqra / (PI * den * den);
};

float3 pbr_fresnel(float3 v, float theta) {
    return v + (1.0 - v) * pow(1.0 - saturate(theta), 5.0);
};


float4 Metalness(float3 dir_view,
                 float3 dir_light,
                 float3 Normal,
                 float3 Albedo,
                 float  Roughness,
                 float  Opacity) {

    float3 Half  = normalize(dir_view + dir_light);

    float3 NrefL = reflect(-dir_light, Normal);
    float  NdotL = dot    (-dir_light, Normal);
    float  NdotH = dot    ( Half,      Normal);
    float  NdotV = dot    (-dir_view,  Normal);
    float  LdotV = dot    ( dir_light, dir_view);
    float  RdotV = dot    ( NrefL,    -dir_view);

    float  roughness = Roughness * Roughness;
    float  G = pbr_particial_geometry(max(0.0, NdotV), roughness);
    float  D = pbr_distribution(max(0.0, NdotH), roughness);
    float3 F = pbr_fresnel(g_Specular.rgb, NdotH);

    float3 spec = G * D * F * 0.25 / (NdotV + Epsilon);
    float3 diff = saturate(1.0 - F);

    float3 color = max(0.0, Albedo * diff * NdotL / PI + spec);
    return float4(color, Opacity * g_Transparent);
};