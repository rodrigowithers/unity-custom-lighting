#if !defined(__LIGHTING__)
#define __LIGHTING__

#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "AutoLight.cginc"

struct appdata
{
    float4 vertex : POSITION;
    float2 uv : TEXCOORD0;
    float3 normal : NORMAL;
};

struct v2f
{
    float4 pos : SV_POSITION;
    float4 worldPos : TEXCOORD3;
    float3 worldNormal : NORMAL;
    float2 uv : TEXCOORD0;
    float3 viewDir : TEXCOORD1;

    SHADOW_COORDS(2)
};

sampler2D _MainTex;
float4 _MainTex_ST;

float4 _Color;
float4 _AmbientColor;

float _Specularity;
float _SpecularStrength;

v2f vert(appdata v)
{
    v2f o;

    o.worldPos = mul(unity_ObjectToWorld, v.vertex);
    o.pos = UnityObjectToClipPos(v.vertex);
    o.worldNormal = UnityObjectToWorldNormal(v.normal);
    o.viewDir = normalize(WorldSpaceViewDir(v.vertex));
    o.uv = TRANSFORM_TEX(v.uv, _MainTex);

    TRANSFER_SHADOW(o);
    return o;
}

UnityLight createLight(v2f i)
{
    UnityLight light;

    #if defined(POINT)
        light.dir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos);

        unityShadowCoord3 lightCoord = mul(unity_WorldToLight, unityShadowCoord4(i.worldPos)).xyz;
        fixed atten = tex2D(_LightTexture0, dot(lightCoord, lightCoord).rr).r;

        atten = smoothstep(0, 0.25, atten); 

        light.color = _LightColor0.rgb * atten;
    #else
        light.dir = _WorldSpaceLightPos0;
        light.color = _LightColor0.rgb;
    #endif

    light.ndotl = DotClamped(i.worldNormal, light.dir);
    return light;
}

fixed4 frag(v2f i) : SV_Target
{
    float shadow = SHADOW_ATTENUATION(i);
    float lightIntensity = smoothstep(0, 0.01, createLight(i).ndotl * shadow);
    float4 light = lightIntensity * half4(createLight(i).color, 1);

    half3 h = (i.viewDir + _WorldSpaceLightPos0.rgb) / 2;
    half OneMinusSpec = 1 - _Specularity;
    half4 spec = smoothstep(OneMinusSpec, OneMinusSpec + 0.01, dot(i.worldNormal, h)) * _SpecularStrength;

    #if defined(POINT)
    _AmbientColor = 0;
    #endif
    
    fixed4 col = tex2D(_MainTex, i.uv) * _Color;
    return (light + _AmbientColor + spec) * col;
}

#endif