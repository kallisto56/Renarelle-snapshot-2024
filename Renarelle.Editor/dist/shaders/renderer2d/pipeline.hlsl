Texture2D tex : register(t0);
SamplerState samplerState : register(s0);

struct VSInput
{
    float2 Position : TEXCOORD0;
    float2 TexCoord : TEXCOORD1;
    float4 Color : TEXCOORD2;
};

struct VSOutput
{
    float4 Position : SV_Position;
    float2 TexCoord : TEXCOORD0;
    float4 Color : TEXCOORD1;
};

VSOutput VSMain(VSInput input)
{
    VSOutput output;

    output.Color = input.Color;
    output.TexCoord = input.TexCoord;
    output.Position = float4(input.Position, 0.0f, 1.0f);

    return output;
}

float4 PSMain(VSOutput input) : SV_Target0
{
    float4 texColor = tex.Sample(samplerState, input.TexCoord);
    float4 finalColor;
    finalColor.rgb = texColor.rgb * input.Color.rgb;
    finalColor.a = texColor.a * input.Color.a;
    return finalColor;
    //return float4((texColor.xyz * input.Color.w) + (input.Color.xyz * texColor.w), 1.0f);
}
