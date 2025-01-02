namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;


extension GraphicsDevice
{
	public enum Backend
	{
		case Direct3D;
		case Direct3D11;
		case Direct3D12;
		case Direct3d;
		case Vulkan;
		case Metal;
		case OpenGL;
		case OpenGLES;
		case Software;


		public StringView GetSDLName ()
		{
			switch (this)
			{
			case Direct3D: return "direct3d";
			case Direct3D11: return "direct3d11";
			case Direct3D12: return "direct3d12";
			case Vulkan: return "vulkan";
			case Metal: return "metal";
			case OpenGL: return "opengl";
			case OpenGLES: return "opengles2";
			case Software: return "software";
			default:
				Runtime.FatalError();
			}
		}


		public SDL3.Raw.SDL_GPUShaderFormat GetShaderFormat ()
		{
			switch (this)
			{
			case Direct3D: return .SDL_GPU_SHADERFORMAT_DXBC;
			case Direct3D11: return .SDL_GPU_SHADERFORMAT_DXBC;
			case Direct3D12: return .SDL_GPU_SHADERFORMAT_DXIL;
			case Vulkan: return .SDL_GPU_SHADERFORMAT_SPIRV;
			case Metal: return .SDL_GPU_SHADERFORMAT_MSL | .SDL_GPU_SHADERFORMAT_METALLIB;
			case OpenGL: return .SDL_GPU_SHADERFORMAT_INVALID;
			case OpenGLES: return .SDL_GPU_SHADERFORMAT_INVALID;
			case Software: return .SDL_GPU_SHADERFORMAT_INVALID;
			default:
				Runtime.FatalError();
			}
		}


		public this (StringView name)
		{
			switch (name)
			{
			case "direct3d": this = .Direct3D;
			case "direct3d11": this = .Direct3D11;
			case "direct3d12": this = .Direct3D12;
			case "vulkan": this = .Vulkan;
			case "metal": this = .Metal;
			case "opengl": this = .OpenGL;
			case "opengles2": this = .OpenGLES;
			case "software": this = .Software;
			default:
				Runtime.FatalError();
			}
		}
	}
}