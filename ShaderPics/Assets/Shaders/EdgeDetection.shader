Shader "Custom/Unlit/EdgeDetection"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		[PerRendererData]_CutOff("_CutOff",float) = 0.4
		[PerRendererData]_TextureWidth("_TextureWidth",float) = 640
		[PerRendererData]_TextureHeight("_TextureHeight", float) = 480
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

				float _TextureWidth;
				float _TextureHeight;

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


				fixed4 blend(fixed4 col1, fixed4 col2, float weight) {

					fixed4 mix = (col1*weight) + (col2*(1.0 - weight));
					return mix;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					// sample the texture
					fixed4 col = tex2D(_MainTex, i.texcoord);
					// apply fog
					UNITY_APPLY_FOG(i.fogCoord, col);
					float2 unit = float2(1.0 / _TextureWidth, 1.0 / _TextureHeight);
					matrix <int, 3, 3> Gx = {
						-1,-2,-1,
						0,0,0,
						1,2,1,
					};
					matrix <int, 3, 3> Gy = {
						-1,0,1,
						-2,0,2,
						-1,0,1
					};

					float tx0y0 = tex2D(_MainTex, i.texcoord+ unit * float2(-1,-1)).r;
					float tx0y1 = tex2D(_MainTex, i.texcoord + unit * float2(-1, 0)).r;
					float tx0y2 = tex2D(_MainTex, i.texcoord + unit * float2(-1, 1)).r;

					float tx1y0 = tex2D(_MainTex, i.texcoord + unit * float2(0, -1)).r;
					float tx1y1 = tex2D(_MainTex, i.texcoord + unit * float2(0, 0)).r;
					float tx1y2 = tex2D(_MainTex, i.texcoord + unit * float2(0, 1)).r;

					float tx2y0 = tex2D(_MainTex, i.texcoord + unit * float2(1, -1)).r;
					float tx2y1 = tex2D(_MainTex, i.texcoord + unit * float2(1, 0)).r;
					float tx2y2 = tex2D(_MainTex, i.texcoord + unit * float2(1, 1)).r;


					float valueGx = Gx[0][0] * tx0y0 + Gx[1][0] * tx1y0 + Gx[2][0] * tx2y0 +
						Gx[0][1] * tx0y1 + Gx[1][1] * tx1y1 + Gx[2][1] * tx2y1 +
						Gx[0][2] * tx0y2 + Gx[1][2] * tx1y2 + Gx[2][2] * tx2y2;

					float valueGy = Gy[0][0] * tx0y0 + Gy[1][0] * tx1y0 + Gy[2][0] * tx2y0 +
						Gy[0][1] * tx0y1 + Gy[1][1] * tx1y1 + Gy[2][1] * tx2y1 +
						Gy[0][2] * tx0y2 + Gy[1][2] * tx1y2 + Gy[2][2] * tx2y2;

					float G = sqrt((valueGx * valueGx) + (valueGy * valueGy));

					float3 v3 = float3(1.0, 1.0, 1.0) - float3(G, G, G);

					float4 edgePix = float4(v3.r,v3.g,v3.b, 1.0);
					
					fixed4 actualEdgePix = fixed4(edgePix.r, edgePix.g, edgePix.b, edgePix.a);

					return blend(actualEdgePix,col , 0.9);

					//return fixed4(0, 0, 0, 1);
				}


				ENDCG
			}
		}
}
