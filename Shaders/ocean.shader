Shader "Ocean/OpenSea" 
{
    Properties
    {
        [Header(Wave Parameters)]
        _Amp("Amplitude (A)", Range(0, 2)) = 1
        _AngularFreq("Angular Frequency (w)", Range(0, 10)) = 5
        _WaveCount("Number Of Waves", Range(1, 100)) = 50

        [Header(Visial Parameters)]
        _Color("Color", Color) = (0.1550819,0.2287288,0.3867925,1)
        _HighlightColor("Highlights", Color) = (0.1023496,0.6761878,0.9433962,1)
        _HighlightStrength("Strength", Range(0,1)) = 0.5
        _FoamColor("Foam Color", Color) = (1,1,1,1)
        _FoamScale("Foam Scale", Range(0, 10)) = 1
    }
    SubShader
    {
        Pass{
            CGPROGRAM
            #pragma multi_compile _ MID CLOSE
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 4.0

            struct appdata{
                float4 vertex: POSITION;
                float2 uv: TEXCOORD0;
            };

            struct v2f {
                float4 position: SV_POSITION;
                float2 uv: TEXCOORD0;
            };

            fixed4 _Color, _HighlightColor, _FoamColor;
            fixed _Amp, _AngularFreq,_WaveCount, _HighlightStrength, _FoamScale;

            v2f vert(appdata IN)
            {
                v2f OUT;
                IN.vertex.y += _Amp * sin(IN.vertex.x + IN.vertex.z + _AngularFreq * _Time.y);
                OUT.position = UnityObjectToClipPos(IN.vertex);
                OUT.uv = IN.uv;
                return OUT;
            }

            fixed4 frag(v2f IN) : SV_Target
            {
                fixed4 pixelCol = _Color;
                return pixelCol;
            }

            ENDCG
        }
    }
}