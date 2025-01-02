Texture2D tex : register(t0);
SamplerState samplerState : register(s0);

struct VSInput
{
    float3 Position : TEXCOORD0;
    float4 Color : TEXCOORD1;
    float2 TexCoord : TEXCOORD2;
};

struct VSOutput
{
    float4 Color : TEXCOORD0;
    float2 TexCoord : TEXCOORD1;
    float4 Position : SV_Position;
};

VSOutput VSMain(VSInput input)
{
    VSOutput output;
    output.Color = input.Color;
    output.TexCoord = input.TexCoord;
    output.Position = float4(input.Position, 1.0f);
    return output;
}

float4 PSMain(VSOutput input) : SV_Target0
{
    float4 texColor = tex.Sample(samplerState, input.TexCoord);

    return float4(
    	(texColor.xyz * input.Color.w) + (input.Color.xyz * texColor.w),
    	1.0f//texColor.w + input.Color.w
    );

    return float4(lerp(texColor.xyz, input.Color.xyz, input.Color.w), 1.0f);
    //return texColor - input.Color + float4(0,0,0,1);
}
