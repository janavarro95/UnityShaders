//Source:https://www.alanzucconi.com/2015/07/08/screen-shaders-and-postprocessing-effects-in-unity3d/
using UnityEngine;
using System.Collections;

public class CameraShaderControl : MonoBehaviour
{
    public Material material;

    public Shader shader;
    //public VideoToTexture controlScript;

    // Creates a private material used to the effect
    void Awake()
    {
        if (shader != null)
        {
            material = new Material(shader);
        }
        else
        {
            enabled = false;
        }
    }

    // Postprocess the image
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (material != null)
        {
            //if (controlScript != null) controlScript.Update();
            Graphics.Blit(source, destination, material);
        }
    
    }
}