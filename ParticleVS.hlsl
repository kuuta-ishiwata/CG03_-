#include "Particle.hlsli"


struct TransformationMatrix
{
    
    float32_t4x4 WVP;
       
};


TransformationMatrix gTransformationmatrices[10];
StructuredBuffer<TransformationMatrix> gTransformationMatrices : register(t0);
  
  
struct VertexShaderInput
{

    float32_t4 position : POSITION0;
    float32_t2 texcoord : TEXCOORD0;
    float32_t3 nomal : NORMAL0;
    
};


VertexShaderOutput main(VertexShaderInput input, uint32_t instanceId : SV_InstanceID)
{
       
    VertexShaderOutput output;
    output.texcoord = input.texcoord;
    output.position = mul(input.position, gTransformationMatrices[instanceId].WVP);
   // output.nomal = normalize(mul(input.nomal(float32_t3x3)
   // gTransformationmatrices.World));
  
    return output;
    
}