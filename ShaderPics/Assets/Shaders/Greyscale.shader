Shader "Custom/Unlit/Greyscale"
{
	//Source for formula: https://en.wikipedia.org/wiki/Grayscale
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		[PerRenderData]_Mode("_Mode",int) = 0
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
					
				if (_Mode == 0) {
					float grey = (col.r*.299) + (col.g*.587) + (col.b*.114);
					return fixed4(grey, grey, grey, col.a);
				}
				if (_Mode == 1) {
					float grey = (col.r*.2126) + (col.g*.7152) + (col.b*.0722);
					return fixed4(grey, grey, grey, col.a);
				}
				if (_Mode == 2) {
					float grey = (col.r*.2627) + (col.g*.6780) + (col.b*.0593);
					return fixed4(grey, grey, grey, col.a);
				}

				return fixed4(0, 0, 0, 1);

				}


				ENDCG
			}
		}
}
