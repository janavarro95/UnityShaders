Shader "Custom/Unlit/PixelNoiseStaic"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		[PerRendererData]_NoiseTex("_NoiseTexture",2D) = "white"{}
		[PerRendererData] _TextureWidth("_TextureWidth",int) = 640
		[PerRendererData] _TextureHeight("_TextureHeight",int) = 4809
		[PerRendererData] _RandomX("_RandomX",float) = 0.0
		[PerRendererData] _RandomY("_RandomY",float) = 0.0
		[PerRendererData] _Mode("_Mode",int) = 0
		[PerRendererData] _NoiseWeight("_NoiseWeight",float)=0.5
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
				float _NoiseWeight;

				int _TextureWidth;
				int _TextureHeight;

				float _RandomX;
				float _RandomY;
				
				int _Mode;

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

				fixed4 blend(fixed4 col1, fixed4 col2, float weight) {

					fixed4 mix = (col1*weight) + (col2*(1.0 - weight));
					return mix;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					if (_Mode == 1) {
						_Noise = _MainTex;   // Keep this for the big funny
											// sample the texture
						fixed4 col = tex2D(_MainTex, i.texcoord);
						fixed4 randomCol = tex2D(_Noise, clampPosition(i.texcoord + float2(_RandomX, _RandomY)));

						//return col;
						return blend(col, randomCol, _NoiseWeight);
					}
					else {
						// sample the texture
						_Noise = _NoiseTexture;
						fixed4 col = tex2D(_MainTex,i.texcoord);
						fixed4 randomCol = tex2D(_Noise, clampPosition(i.texcoord + float2(_RandomX, _RandomY)));

						//return col;
						return blend(randomCol, col, _NoiseWeight);
					}
					
					return fixed4(0,0,0,1);

				}


				ENDCG
			}
        }
    }
