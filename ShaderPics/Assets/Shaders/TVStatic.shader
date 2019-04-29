Shader "Custom/Unlit/TVStatic"
{
    Properties
    {
		[PerRendererData]_NoiseTex("_NoiseTexture",2D) = "white"{}
		[PerRendererData] _RandomX("_RandomX",float) = 0.0
		[PerRendererData] _RandomY("_RandomY",float) = 0.0
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
			#pragma target 2.0
			#pragma multi_compile_instancing
			#pragma multi_compile _ PIXELSNAP_ON
			#pragma multi_compile _ ETC1_EXTERNAL_ALPHA
			#include "UnitySprites.cginc"


				float4 _MainTex_ST;
				sampler2D _NoiseTexture;
				sampler2D _Noise;


				float _RandomX;
				float _RandomY;

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

				//Unused for now.
				float2 clampPosition(float2 pos) {

					if (pos.x > 1)pos.x = pos.x - 1;
					if (pos.y > 1)pos.y = pos.y - 1;
					return pos;
				}

				fixed4 avgColor(fixed4 col) {
					float avg = col.r + col.g + col.b;
					avg = avg / 3.0;

					return fixed4(avg, avg, avg, col.a);
				}

				fixed4 frag(v2f i) : SV_Target
				{
					fixed4 randomCol = tex2D(_NoiseTexture, clampPosition(i.texcoord + float2(_RandomX, _RandomY)));
					return avgColor(randomCol);
				}
				ENDCG
			}
        }
    }
