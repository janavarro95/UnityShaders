using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;

namespace Assets.Scripts.ShaderScripts
{
    public class FourCorners:VideoToTexture
    {
        public Color color1=Color.blue;
        public Color color2=Color.yellow;
        public Color color3=Color.red;
        public Color color4=Color.green;

        public override void shaderPass()
        {
            if (isCamera) return;
            MaterialPropertyBlock mpb = new MaterialPropertyBlock();
            meshRenderer.GetPropertyBlock(mpb);
            mpb.SetColor("_TintColor1",color1);
            mpb.SetColor("_TintColor2", color2);
            mpb.SetColor("_TintColor3", color3);
            mpb.SetColor("_TintColor4", color4);
            meshRenderer.SetPropertyBlock(mpb);
        }
    }
}
