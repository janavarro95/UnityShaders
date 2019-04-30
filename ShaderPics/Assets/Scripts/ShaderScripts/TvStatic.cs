using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;

namespace Assets.Scripts.ShaderScripts
{
    public class TvStatic:VideoToTexture
    {
        public Texture2D noiseTexture;

        public override void shaderPass()
        {
            if (isCamera) return;
            Vector2 random = randomValues();
            MaterialPropertyBlock mpb = new MaterialPropertyBlock();
            meshRenderer.GetPropertyBlock(mpb);
            mpb.SetFloat("_RandomX", random.x);
            mpb.SetFloat("_RandomY", random.y);
            mpb.SetTexture("_NoiseTexture", noiseTexture);
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
