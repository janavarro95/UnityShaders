Shader "Custom/Unlit/BlackAndWhite"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		[PerRendererData]_CutOff("_CutOff",float) = 0.4
		[PerRendererData]_Mode("_Mode",int) = 0
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
				float _CutOff;
				float _Mode;

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

				fixed4 avgColor(fixed4 col) {
					float avg = col.r + col.g + col.b;
					avg = avg / 3.0;

					if (avg < _CutOff) {
						return fixed4(0.0, 0.0, 0.0, 1.0);
					}
					else {
						return fixed4(1, 1, 1, 1);
					}
				}

				fixed4 redCutOff(fixed4 col) {
					if (col.r < _CutOff) {
						return fixed4(0.0, 0.0, 0.0, 1.0);
					}
					else {
						return fixed4(1, 1, 1, 1);
					}
				}

				fixed4 greenCutOff(fixed4 col) {
					if (col.g < _CutOff) {
						return fixed4(0.0, 0.0, 0.0, 1.0);
					}
					else {
						return fixed4(1, 1, 1, 1);
					}
				}

				fixed4 blueCutOff(fixed4 col) {
					if (col.b < _CutOff) {
						return fixed4(0.0, 0.0, 0.0, 1.0);
					}
					else {
						return fixed4(1, 1, 1, 1);
					}
				}

				fixed4 frag(v2f i) : SV_Target
				{
					// sample the texture
					fixed4 col = tex2D(_MainTex, i.texcoord);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);

				if (_Mode == 0)	return avgColor(col);
				if (_Mode == 1) return redCutOff(col);
				if (_Mode == 2) return greenCutOff(col);
				if (_Mode == 3) return blueCutOff(col);
					return fixed4(0, 0, 0, 1);
				}


				ENDCG
			}
		}
}
