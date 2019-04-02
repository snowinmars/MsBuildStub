# MsBuildStub

This is a template with some usefull MSBuild stuff. This stub should be used as a template for a new project or as example of a simple MSBuild flow

Points of interest:
* Inject common assembly info into all the projects
* Inject autoincremented build version into all the projects
* Setup .NET and C# varsions for all the projects 
* Fail build on StyleCop warning
* Scaffold enums into projects

btw: you can read about this repository in the <a href="https://habr.com/ru/post/441614/">habr article</a>.

## Getting Started

Idk how to get T4 tool as standalone app so you should install it manually.
Open Visual Studio Installer.
Switch to the Individual components tab.
Mark "Text Transform" tool to be intalled.
Try to find it on your PC, f.e. try path `C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\IDE\TextTransform.exe`. Write the path to exe file to `/MsBuildStub/tools/scaffold.ps1` into `$textTransformExePath` variable.

Build the solution.

You'll see new files that was generated during build:
* Entities/EntitiesEnums.generated.cs
* Entities/EntitiesSql.generated.cs
* Services/ServicesEnums.generated.cs
* Services/ServicesSql.generated.cs

The files may not be included in the project, so check it manually once.

MSBuild struggle if .generated files are missed on disk.
If it happens, run build twice: first one will create files and next one will handle them property.

### Documentation
<img src="https://pp.userapi.com/c850736/v850736663/edfc7/x3ARdQWAPkc.jpg" border="0" width="100%">
<img src="https://pp.userapi.com/c847123/v847123990/1d7c4a/pPB-BHIuZyo.jpg" border="0" width="100%">

The enums are defined in the XML file in the `/t4origin/origins/enums.xml`
* `enum.toAssemblies` attribute determinates the project destination and should match one of the assemblies in the `assemblies.xml` file. An Exception will be thrown otherwise
* `enum.csName` is enum name in C#
* `enum.property.csName` is enum's property name in C#
* `enum.property.value` is enums property's value in C#
* `enum.property.%anything%` will be transformed to wrapper field. The code will try to guess the type. At least it will be string.

The assemblies are defined in the XML file in the `/t4origin/origins/assemblies.xml`
* `id` attribute should match the `toAssemblies` attribute in the `enums.xml` file
* `path` attribute determinates the destination for t4 output. Generated files will be placed here
* `projectName` attribute is not ignored

### Prerequisites

* MSVS
* TextTransform for MSVS (idk how to eject the exe file from the system without pain)

For some reason the propject need the envdte dll in the /t4origin folder. This is dll from `C:\Program Files (x86)\Common Files\microsoft shared\MSEnv\PublicAssemblies\envdte.dll`

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE.md](LICENSE.md) file for details