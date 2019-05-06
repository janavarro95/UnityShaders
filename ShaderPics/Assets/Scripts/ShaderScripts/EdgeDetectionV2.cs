using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;

namespace Assets.Scripts.ShaderScripts
{
    public class EdgeDetectionV2:VideoToTexture
    {

        public float cutOff=0.5f;
        public Color backgroundColor=Color.white;
        public Color outlineColor=Color.black;

        public override void shaderPass()
        {
            if (isCamera) return;
            MaterialPropertyBlock mpb = new MaterialPropertyBlock();
            meshRenderer.GetPropertyBlock(mpb);
            mpb.SetFloat("_CutOff", cutOff);
            mpb.SetColor("_BackgroundColor", backgroundColor);
            mpb.SetColor("_OutlineColor", outlineColor);
            meshRenderer.SetPropertyBlock(mpb);
        }

    }
}
