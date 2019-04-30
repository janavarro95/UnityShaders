Shader "Custom/Unlit/VerticalMove"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		[PerRendererData] _Inverted("_Inverted",int) = 0
		[PerRendererData] _TimeStamp("_TimeStamp",float) = 0.0
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

					int _Inverted;

					float _TimeStamp;

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

					float clamp(float val) {
						if (val > 1) return val % 1;
						if (val < 0) return  1- ((val*-1) % 1);
						return val;
					}

					fixed4 frag(v2f i) : SV_Target
					{
						if (_Inverted == 0) {
							// sample the texture
							fixed4 col = tex2D(_MainTex, float2(i.texcoord.x,clamp(i.texcoord.y + _TimeStamp)));
							// apply fog
							UNITY_APPLY_FOG(i.fogCoord, col);
							return col;

						}
						else {
							// sample the texture
							fixed4 col = tex2D(_MainTex, float2(i.texcoord.x,clamp(i.texcoord.y - _TimeStamp)));
							// apply fog
							UNITY_APPLY_FOG(i.fogCoord, col);
							return col;
						}
				}


				ENDCG
			}
		}
}
