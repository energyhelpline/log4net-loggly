#load ".build\parameters.cake"
#load ".build\tasks.cake"

//////////////////////////////////////////////////////////////////////
// PARAMETERS
//////////////////////////////////////////////////////////////////////

const string solution = @"Source\log4net-loggly.sln";
const string octoProject = "";
const string octoPublishProject = "";
const string loggyLog4NetBuildNo = "7.3.1";

buildNumber = loggyLog4NetBuildNo;

//////////////////////////////////////////////////////////////////////
// CUSTOM TASKS
// Add tasks as required, optional
//////////////////////////////////////////////////////////////////////

Task("Publish-loggly-log4net-to-NuGet")
    .WithCriteria(() => isCi)
    .IsDependentOn("Install-Nuget-Command-Line")
    .Does(() =>
    {
        StartPowershellFile(@"./.build/publish-packages-to-nuget.ps1", args =>
        {
            args.Append("nugetSource", nugetEhlUrl)
            .Append("nugetApiKey", nugetEhlApiKey)
            .Append("version", loggyLog4NetBuildNo)
            .Append("buildConfiguration", configuration);
        });
    });

//////////////////////////////////////////////////////////////////////
// TASK TARGETS
// Change the default as required
// Optionally add more
//////////////////////////////////////////////////////////////////////

Task("Default")
    .IsDependentOn("Info")
    .IsDependentOn("Upgrade-Chocolatey")
    .IsDependentOn("Build")
    .IsDependentOn("Publish-loggly-log4net-to-NuGet");

//////////////////////////////////////////////////////////////////////
// EXECUTION
//////////////////////////////////////////////////////////////////////

RunTarget(target);
