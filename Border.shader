Shader "Custom/2D/SquareBorder"
{
    Properties
    {
        [Toggle] _Active ("Active", float) = 1
        _MainTex ("Texture", 2D) = "white" {}
        _BorderColour("Border Colour", Color) = (1,1,1,1)
        _Thickness ("Thickness", Range(0.0, 0.5)) = 0.1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Thickness;
            fixed4 _BorderColour;
            float _Active;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);

                if (_Active == 0)
                {
                    return col;
                }

                if (i.uv.y < _Thickness || (1 - i.uv.y) < _Thickness)
                {
                    col.rgba = _BorderColour;
                }

                if (i.uv.x < _Thickness || (1 - i.uv.x) < _Thickness)
                {
                    col.rgba = _BorderColour;
                }

                return col;
            }
            ENDCG
        }
    }
}
