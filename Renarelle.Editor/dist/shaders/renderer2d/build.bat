@echo off
REM Compile the HLSL file to bytecode
"C:\Program Files (x86)\Windows Kits\10\bin\10.0.17134.0\x64\fxc.exe" /T ps_5_0 /E PSMain /Fo pipeline.fragment.cso pipeline.hlsl
"C:\Program Files (x86)\Windows Kits\10\bin\10.0.17134.0\x64\fxc.exe" /T vs_5_0 /E VSMain /Fo pipeline.vertex.cso pipeline.hlsl

REM Check if the compilation was successful
IF %ERRORLEVEL% NEQ 0 (
    echo Compilation failed.
) ELSE (
    echo Compilation successful.
)
pause
