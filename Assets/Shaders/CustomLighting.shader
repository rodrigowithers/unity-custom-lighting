Shader "Unlit/CustomLighting"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1, 1, 1, 1)
        _AmbientColor ("Ambient Color", Color) = (1, 1, 1, 1)

        _Specularity ("Specularity", Range(0,1)) = 0.5
        _SpecularStrength ("Specular Strength", Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags
        {
            "Queue" = "Geometry" "RenderType" = "Opaque" "IgnoreProjector" = "True"
        }

        Pass
        {
            Tags
            {
                "LightMode" = "ForwardBase"
            }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile_fwdbase

            #include "deLighting.cginc"
            ENDCG
        }

        Pass
        {
            Tags
            {
                "LightMode" = "ForwardAdd"
            }

            Blend One One

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #define POINT
            #include "deLighting.cginc"
            ENDCG
        }

        // Shadow casting support.
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}