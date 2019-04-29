using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;

namespace Assets.Scripts.ShaderScripts
{
    public class Greyscale:VideoToTexture
    {
        public enum GreyscaleMode
        {
            StandardColor,
            HDTV,
            HDRTV
        }

        public GreyscaleMode currentMode;

        public override void shaderPass()
        {
            MaterialPropertyBlock mpb = new MaterialPropertyBlock();
            meshRenderer.GetPropertyBlock(mpb);
            mpb.SetInt("_Mode", (int)currentMode);
            meshRenderer.SetPropertyBlock(mpb);
        }
    }
}
