Shader "Custom/Unlit/ScanLines"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		[PerRendererData] _TintColor("TintColor",Color) = (1,1,1,1)
		[PerRendererData] _TextureWidth("_TextureWidth",int) = 640
		[PerRendererData] _TextureHeight("_TextureHeight",int) = 480
		[PerRendererData] _ModFrequency("_ModFrequency",float) = .1
		[PerRendererData] _Thickness("_Thickness",float) = .02
		[PerRendererData] _ScanMultiplier("_ScanMultiplier",float) = .9
		[PerRendererData] _TimeStamp("_TimeStamp",float) = 0.0
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
				fixed4 _TintColor;
				float _CutOff;
				float _Mode;

				int _TextureWidth;
				int _TextureHeight;

				float _ModFrequency;
				float _Thickness;
				float _ScanMultiplier;

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

				fixed4 frag(v2f i) : SV_Target
				{
					// sample the texture
					fixed4 col = tex2D(_MainTex, i.texcoord);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);

				if ( (i.texcoord.y+_TimeStamp) % _ModFrequency <= _Thickness) {
					return col * _ScanMultiplier;
				}
				else {
					return col;
				}


					//return fixed4(0, 0, 0, 1);
				}


				ENDCG
			}
        }
    }
