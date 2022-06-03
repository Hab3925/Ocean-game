Shader "Ocean/OceanDepthColor"
{
    Properties
    {
        [Header(Colors)]

        _ShallowCol("Shallow Color", Color) = (0.1529412, 0.8862746, 0.9921569, 0.7803922)
        _MediumCol("Medium Depth color", Color) = (0.0788092, 0.3756849, 0.7264151, 1)
        _DeepCol("Deep Color", Color) = (0.1133856, 0.2117804, 0.490566, 1)
        _OceanCol("Ocen Color", Color) = (0.03529412, 0.1215686, 0.2, 1) 

        [Header(Depths)]
        _ShallowDepth("Shallow Depth", Range(0, 50)) = 15
        _MediumDepth("Medium Depth", Range(15, 75)) = 30
        _DeepDepth("Deep Depth", Range(50, 150)) = 60

        _TransitionStrength("Transition Strength", Range(0, 2)) = 1
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "UnityStandardCore.cginc"

            
            UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);


            struct appdata{
                float4 vertex: POSITION;
                float2 uv: TEXCOORD0;
            };

            struct v2f {
                float4 position: SV_POSITION;
                float2 uv: TEXCOORD0;
                float4 screenPos : TEXCOORD1;
            };

            fixed4 _ShallowCol, _MediumCol, _DeepCol, _OceanCol;
            float _ShallowDepth, _MediumDepth, _DeepDepth, _TransitionStrength;



            v2f vert(appdata IN)
            {
                v2f OUT;
                OUT.position = UnityObjectToClipPos(IN.vertex);
                OUT.uv = IN.uv;
                OUT.screenPos = ComputeScreenPos(OUT.position);
                return OUT;
            }

            fixed4 frag(v2f IN)
            {
                float Cam_FarPlane = _ProjectionParams.z;
                float camDepth = Linear01Depth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, IN.uv));
                float screenpos = IN.screenPos.w;
                float waterDepth = Cam_FarPlane * camDepth;

                float shallowTime = saturate((waterDepth - screenpos + _ShallowDepth) * _TransitionStrength);
                float mediumTime = saturate((waterDepth - screenpos + _ShallowDepth) * _TransitionStrength);
                float DeepTime = saturate((waterDepth - screenpos + _ShallowDepth) * _TransitionStrength);

                fixed4 color = lerp(lerp(lerp(_ShallowCol, _MediumCol, shallowTime), _DeepCol, mediumTime), _OceanCol, DeepTime);

                return color;
            }
            
            ENDCG
        }
    }
}