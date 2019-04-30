using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;

namespace Assets.Scripts.ShaderScripts
{
    public class ScreenMovement : VideoToTexture
    {

        [Tooltip("Used to keep track on how fast the scan lines move. A value of 0 is no movement.")]
        /// <summary>
        /// Used to keep track on how fast the scan lines move.
        /// </summary>
        public float timeStep = 0.001f;

        [Tooltip("Used to keep track of the time step for the scan lines.")]
        /// <summary>
        /// Used to keep track of the time step for the scan lines.
        /// </summary>
        public float timeStamp = 0.0f;

        public bool invertDirction;


        public override void Update()
        {
            if (isCamera) return;
            timeStamp += timeStep;
            base.Update();
        }

        public override void shaderPass()
        {
            MaterialPropertyBlock mpb = new MaterialPropertyBlock();
            meshRenderer.GetPropertyBlock(mpb);
            mpb.SetFloat("_TimeStamp", timeStamp);
            if (invertDirction == true)
            {
                mpb.SetInt("_Inverted", 1);
            }
            else
            {
                mpb.SetInt("_Inverted", 0);
            }
            meshRenderer.SetPropertyBlock(mpb);
        }
    }

}
