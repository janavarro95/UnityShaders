Shader "Custom/Unlit/FunHouseMirror"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
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
					if (val < 0) return ((val*-1) % 1);
					return val;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					// sample the texture
					float y;
					float x;

					if (i.texcoord.y > .5) y = i.texcoord.y;
					else y = 1.0 - i.texcoord.y;
					if (i.texcoord.x < .5) x = i.texcoord.x;
					else x = 1.0 - i.texcoord.x;
					fixed4 col = tex2D(_MainTex, float2(x,y));
					// apply fog
					UNITY_APPLY_FOG(i.fogCoord, col);
					return col;
				}


				ENDCG
			}
		}
}
