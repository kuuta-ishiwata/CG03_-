﻿#include "Object3d.hlsli"

struct Material
{
    float32_t4 color;
    int32_t enableLighting;
    //float32_t4x4 uvTransform;
    float32_t shininess;

};

struct DirectionalLight
{
    float32_t4 color; //ライトの色
    float32_t3 direction; //ライトの向き
    float intensity;

};

struct Camera
{
    float32_t3 worldPosition;
};

ConstantBuffer<Material> gMaterial : register(b0);
Texture2D<float32_t4> gTexture : register(t0);
SamplerState gSampler : register(s0);
ConstantBuffer<DirectionalLight> gDirectionalLight : register(b1);

ConstantBuffer<Camera> gCamera : register(b2);


struct PixelShaderOutput
{


    float32_t4 color : SV_TARGET0;
	
};




PixelShaderOutput main(VertexShaderOutput input)
{

    PixelShaderOutput output;
   
    float32_t4 textureColor = gTexture.Sample(gSampler, input.texcoord);

    //output.color = gMaterial.color * textureColor;
    
    
        
    if (gMaterial.enableLighting != 0)
    {
        //float cos = saturate(dot(normalize(input.nomal), -gDirectionalLight.direction));
        //output.color = gMaterial.color * textureColor * gDirectionalLight.color * cos * gDirectionalLight.intensity;
        
       // float32_t halfVector = normalize(-gDirectionalLight.direction + toEye);
       // float NDotH = dot(normalize(input.nomal), halfVector);
       // float specularpow = pow(saturate(NDotH), gMaterial.shininess);
        
        float32_t3 reflectLight = reflect(gDirectionalLight.direction, normalize(input.nomal));
    
        float32_t3 toEye = normalize(gCamera.worldPosition - input.worldPosition);
    
        float NdotL = dot(normalize(input.nomal), normalize(-gDirectionalLight.direction));
        float cos = pow(NdotL * 0.5f + 0.5f, 2.0f);
   
        float RdotE = dot(reflectLight, toEye);
        float specularPow = pow(saturate(RdotE), gMaterial.shininess); //反射強度
    
    //拡散反射
        float32_t3 diffuse = gMaterial.color.rgb * textureColor.rgb * gDirectionalLight.color.rgb * cos * gDirectionalLight.intensity;
    
    //鏡面反射
        float32_t3 specular = gDirectionalLight.color.rgb * gDirectionalLight.intensity * specularPow * float32_t3(1.0f, 1.0f, 1.0f);
    
    //拡散反射+鏡面反射
        output.color.rgb = diffuse + specular;
        
    //アルファは今まで通り
        output.color.a = gMaterial.color.a * textureColor.a;
        //output.color.rgb = gMaterial.color.rgb * textureColor.rgb;
        
        
        
    }
    else
    {
        
        output.color = gMaterial.color * textureColor;
        //output.color = gMaterial.color * textureColor;
        
        
    }
    
    //output.color.a = 1.0f;
	
    return output;

}




	