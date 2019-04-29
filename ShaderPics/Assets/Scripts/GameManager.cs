using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;

namespace Assets.Scripts
{
    public class GameManager
    {
        public static WebCamTexture WebCamTexture;


        public static void InitializeVideoCamera()
        {
            if (WebCamTexture == null) WebCamTexture = new WebCamTexture();
        }

        public static void PlayVideoCamera()
        {
            WebCamTexture.Play();
        }
    }
}
