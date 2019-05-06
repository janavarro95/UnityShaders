Shader "Custom/Unlit/SimpleColorTint"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		[PerRendererData]_TintColor ("TintColor",Color)=(1,1,1,1)
    }
    SubShader
    {
			Tags { "RenderType" = "Opaque" }
			LOD 100

			Pass
			{
				CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 2.0
			#pragma multi_compile_instancing
			#pragma multi_compile _ PIXELSNAP_ON
			#pragma multi_compile _ ETC1_EXTERNAL_ALPHA
			#include "UnitySprites.cginc"

            float4 _MainTex_ST;
			fixed4 _TintColor;

            v2f vert (appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord = TRANSFORM_TEX(v.texcoord , _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.texcoord);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);



				return col * _TintColor;
            }
            ENDCG
        }
    }
}
