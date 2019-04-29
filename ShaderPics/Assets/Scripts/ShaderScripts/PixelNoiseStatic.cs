using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;

namespace Assets.Scripts.ShaderScripts
{
    public class PixelNoiseStatic:VideoToTexture
    {
        public Texture2D noiseTexture;

        public enum PixelNoiseStaticMode
        {
            UseNoiseTexture,
            UseWebCamTexture
        }

        public PixelNoiseStaticMode currentMode;

        public float noiseWeight = 0.5f;

        public override void shaderPass()
        {
            Vector2 random = randomValues();
            MaterialPropertyBlock mpb = new MaterialPropertyBlock();
            meshRenderer.GetPropertyBlock(mpb);
            if (currentMode == PixelNoiseStaticMode.UseNoiseTexture)
            {
                mpb.SetInt("_Mode", (int)currentMode);
                mpb.SetTexture("_NoiseTexture", noiseTexture);
            }
            else if(currentMode== PixelNoiseStaticMode.UseWebCamTexture)
            {
                mpb.SetInt("_Mode", (int)currentMode);
            }
            mpb.SetFloat("_NoiseWeight", noiseWeight);
            mpb.SetFloat("_RandomX", random.x);
            mpb.SetFloat("_RandomY", random.y);
            meshRenderer.SetPropertyBlock(mpb);
        }

        /// <summary>
        /// Gets some rng values from unity's random generator.
        /// </summary>
        /// <returns></returns>
        private Vector2 randomValues()
        {
            return new Vector2(UnityEngine.Random.value, UnityEngine.Random.value);
        }

    }
}
