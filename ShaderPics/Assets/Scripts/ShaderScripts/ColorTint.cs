using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.UI;

namespace Assets.Scripts
{
    public class ColorTint : VideoToTexture
    {
        public Color color;

        public override void Update()
        {
            shaderPass();
        }

        public override void shaderPass()
        {
            MaterialPropertyBlock mpb = new MaterialPropertyBlock();
            meshRenderer.GetPropertyBlock(mpb);
            mpb.SetColor("_TintColor", color);
            meshRenderer.SetPropertyBlock(mpb);
        }

    }
}
