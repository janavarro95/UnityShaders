using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;

namespace Assets.Scripts.ShaderScripts
{
    public class DotMatrix:VideoToTexture
    {
        [Tooltip("A mod factor of .1 means every 10% of the image will start the area of scan line effect.")]
        /// <summary>
        /// A mod factor of .1 means every 10% of the image will start the area of scan line effect
        /// </summary>
        public float modFrequency = .015f;

        [Tooltip("How much of a percent of the image is taken up by a scan line. .05 means 5% of the image will be affected every time a scan line is created. See modFrequency.")]
        /// <summary>
        /// How much of a percent of the image is taken up by a scan line. .05 means 5% of the image will be affected every time a scan line is created. See modFrequency.
        /// </summary>
        public float thickness = .01f;

        [Tooltip("How visible the scanlines are. Smaller number means more visibility.")]
        /// <summary>
        /// How visible the scanlines are. Smaller number means more visibility.
        /// </summary>
        public float scanMultiplier = .75f;

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

        public override void Update()
        {
            timeStamp += timeStep;
            base.Update();
        }

        public override void shaderPass()
        {
            MaterialPropertyBlock mpb = new MaterialPropertyBlock();
            meshRenderer.GetPropertyBlock(mpb);
            mpb.SetFloat("_ModFrequency", modFrequency);
            mpb.SetFloat("_Thickness", thickness);
            mpb.SetFloat("_ScanMultiplier", scanMultiplier);
            mpb.SetFloat("_TimeStamp", timeStamp);
            meshRenderer.SetPropertyBlock(mpb);
        }
    }
}
