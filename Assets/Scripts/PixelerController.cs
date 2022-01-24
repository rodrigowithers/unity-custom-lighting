using UnityEngine;

[ExecuteAlways]
public class PixelerController : MonoBehaviour
{
    public int DownscaleFactor = 32;

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        RenderTexture scaleBuffer =
            RenderTexture.GetTemporary(src.width / DownscaleFactor, src.height / DownscaleFactor);

        scaleBuffer.filterMode = FilterMode.Point;
        
        Graphics.Blit(src, scaleBuffer);
        Graphics.Blit(scaleBuffer, dest);
        
        RenderTexture.ReleaseTemporary(scaleBuffer);
    }
}