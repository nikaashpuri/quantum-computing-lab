# Build Instructions (Mac/Linux)

For reference please check instructions on - https://www.microsoft.com/en-us/quantum/development-kit

Please follow these instructions carefully. 

1. The Quantum Development Kit can be used either with the Visual Studio 2017 integrated development environment, 
or a development editor such as Visual Studio Code. 
Alternatively, the Quantum Development Kit can be used with the command line directly.

2. The Quantum Development Kit uses the .NET Core SDK (2.0 or later) to make it easy to create, build, 
and run Q# projects from the command line. 
We recommend using the Quantum Development Kit together with Visual Studio Code (version 1.26.0 or later).

3. Download and install the .NET Core SDK 2.0 or later from https://dotnet.microsoft.com/download. 

4. Open a new terminal window to activate dotnet. 
Once the .NET Core SDK is installed, run the following command in your favorite command line (e.g.: PowerShell or Bash) 
to download the latest templates for creating new Q# applications and libraries:
```
dotnet new -i "Microsoft.Quantum.ProjectTemplates::0.3.1811.2802-preview"
```

5. Go to the Visual Studio Code website (https://code.visualstudio.com). 

6. Once Visual Studio Code is installed, go to the Microsoft Quantum Development Kit for Visual Studio Code 
extension on the Visual Studio Marketplace and press Install.

7. You are now ready to run Q# code. 

# Build Instructions (Windows)

1. Please follow the instructions for the Windows platform on - https://www.microsoft.com/en-us/quantum/development-kit

# How to run the code 

1. Open the console window in Visual Studio Code (opens from the bottom of the screen)

2. Navigate to the Terminal tab. To run the project, use the command:
```
dotnet run
```