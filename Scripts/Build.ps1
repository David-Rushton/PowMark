#
# Build Scripts
# Run test, build and deploy
#

[CmdletBinding()]
param(

    [parameter(
        ValueFromPipeline,
        ValueFromPipelineByPropertyName,
        HelpMessage='Name of PowerShell repository to publish module to.'
    )]
    [string]$Repository,

    [parameter(
        ValueFromPipeline,
        ValueFromPipelineByPropertyName,
        HelpMessage='Name of file system folder to publish module to.'
    )]
    [string]$Path
)


Set-StrictMode -Version "Latest"


# Run Tests
Write-Verbose "Running Pester tests."
[int]$failedTests = Invoke-Pester -Script "$PSScriptRoot\..\Tests\PowMark.Tests\" -EnableExit


# Publish.
if ($failedTests -eq 0) {

    # Publish to file system.
    if ($Path) {
        try {

            Write-Verbose "Publishing to: $Path."
            Copy-Item -Path "$PSScriptRoot\..\Source\PowMark" -Destination $Path -Force -Recurse
        }
        catch {

            throw "Cannot publish module to '$Path': $_."
        }
    }


    # Publish to repo.
    if ($Repository) {

        try {

            Write-Verbose "Publishing to: $Repository."
            Publish-Module -Path "$PSScriptRoot\..\Source\PowMark" -Repository $Repository -Force
        }
        catch {

            throw "Cannot publish module to '$Repository': $_"
        }
    }
}
