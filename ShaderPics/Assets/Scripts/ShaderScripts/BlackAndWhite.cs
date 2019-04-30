using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;

namespace Assets.Scripts.ShaderScripts
{
    public class BlackAndWhite : VideoToTexture
    {
        public enum BlackAndWhiteModes
        {
            Average,
            RedCutOff,
            GreenCutOff,
            BlueCutOff
        }

        public BlackAndWhiteModes currentMode;


        public float cutOff;
        public override void shaderPass()
        {
            if (isCamera) return;
            MaterialPropertyBlock mpb = new MaterialPropertyBlock();
            meshRenderer.GetPropertyBlock(mpb);
            mpb.SetFloat("_CutOff", cutOff);
            mpb.SetInt("_Mode", (int)currentMode);
            meshRenderer.SetPropertyBlock(mpb);
        }
    }

}
