using Assets.Scripts;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class VideoToTexture : MonoBehaviour
{
    // Start is called before the first frame update

    public WebCamTexture webTexture
    {
        get
        {
            return GameManager.WebCamTexture;
        }
    }
    public RawImage rawImage;
    public bool useWebTextureHeight=false;
    public MeshRenderer meshRenderer;
    

    public virtual void Start()
    {
        GameManager.InitializeVideoCamera();
        getRenderSurface();
        GameManager.PlayVideoCamera();
        
    }

    public virtual void getRenderSurface()
    {
        rawImage = this.gameObject.GetComponent<RawImage>();
        rawImage.texture = webTexture;
        rawImage.material.mainTexture = webTexture;
        if (useWebTextureHeight)
        {
            rawImage.rectTransform.sizeDelta = new Vector2(webTexture.width, webTexture.height);
        }
        try
        {
            this.meshRenderer = this.gameObject.GetComponent<MeshRenderer>();
            this.gameObject.GetComponent<MeshRenderer>().material.mainTexture = webTexture;
        }
        catch (Exception err)
        {
            Debug.Log("HMM");
        }
    }

    // Update is called once per frame
    public virtual void Update()
    {
        shaderPass();
    }

    public virtual void shaderPass()
    {

    }
}
