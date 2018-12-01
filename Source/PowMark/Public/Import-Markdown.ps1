<#
    .SYNOPSIS
    Imports a Markdown file.

    .DESCRIPTION
    Imports Markdown files and returns a markdown object containing HTML, plain
    text and the orginal markdown.

    .PARAMETER Path
    Path to the markdown file.
    Supports wildcards.

    .EXAMPLE
    # Import a markdown file.
    PS C:\> Import-Markdown -Path "C:\Path\MyFile.md"

    .EXAMPLE
    # Import all files in the current directory.
    PS C:\> Import-Markdown -Path ".\*.md"

    .EXAMPLE
    # Import two named files.
    PS C:\> Import-Markdown -Path @("C:\FileOne.md", "C:\FileTwo.md")
#>
function Import-Markdown {
    [CmdletBinding()]
    [OutputType('OldLead.PowMark.Markdown')]
    param(

        [parameter(
            Mandatory,
            Position=0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage='Path to markdown text file.'
        )]
        [ValidateScript( { Test-Path $_ } )]
        [string[]]$Path
    )

    begin {

        Set-StrictMode -Version "Latest"
    }


    process {
        foreach ($item in $Path) {

            $subItems = Resolve-Path -Path "$item"
            foreach ($subItem in $subItems) {

                try {

                    $markdown = (Get-Content -Path $subItem)
                    Write-Output (ConvertFrom-Markdown -Markdown $markdown)
                }
                catch {

                    Write-Error "Could not read file: $subItem."
                }
            }
        }
    }


    end {

    }
}
