Shader "Custom/Unlit/FourCorners"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		[PerRendererData]_TintColor1("_TintColor1",Color) = (1,1,1,1)
		[PerRendererData]_TintColor2("_TintColor2",Color) = (1,1,1,1)
		[PerRendererData]_TintColor3("_TintColor3",Color) = (1,1,1,1)
		[PerRendererData]_TintColor4("_TintColor4",Color) = (1,1,1,1)
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
				fixed4 _TintColor1;
				fixed4 _TintColor2;
				fixed4 _TintColor3;
				fixed4 _TintColor4;

				v2f vert(appdata_t IN)
				{
					v2f OUT;
					OUT.vertex = UnityObjectToClipPos(IN.vertex);
					OUT.texcoord = IN.texcoord;
					OUT.color = IN.color;
					#ifdef PIXELSNAP_ON
					OUT.vertex = UnityPixelSnap(OUT.vertex);
					#endif

					return OUT;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					// sample the texture
					fixed4 col = tex2D(_MainTex, i.texcoord);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);

				if (i.texcoord.x < 0.5 && i.texcoord.y < 0.5) {
					return col * _TintColor1;
				}
				if (i.texcoord.x > 0.5 && i.texcoord.y < 0.5) {
					return col * _TintColor2;
				}
				if (i.texcoord.x < 0.5 && i.texcoord.y > 0.5) {
					return col * _TintColor3;
				}
				if (i.texcoord.x > 0.5 && i.texcoord.y > 0.5) {
					return col * _TintColor4;
				}
				return fixed4(0,0,0,1);
			}
			ENDCG
		}
		}
}
