Shader "Custom/Unlit/Sepia"
{
	//Source for formula: https://www.dyclassroom.com/image-processing-project/how-to-convert-a-color-image-into-sepia-image
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
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

				float clamp(float value) {
					if (value > 1) value = 1;
					return value;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					// sample the texture
					fixed4 col = tex2D(_MainTex, i.texcoord);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
					float red = (col.r*.393) + (col.g*.769) + (col.b*.189);
					float green = (col.r*.349) + (col.g*.686) + (col.b*.168);
					float blue = (col.r*.272) + (col.g*.534) + (col.b*.131);
					red = clamp(red);
					green = clamp(green);
					blue = clamp(blue);
					return fixed4(red, green, blue, col.a);


				}


				ENDCG
			}
		}
}
