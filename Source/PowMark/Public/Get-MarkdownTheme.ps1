<#
    .SYNOPSIS
    Returns Markdown themes.

    .DESCRIPTION
    Returns a list of all Markdown themes installed with this module.

    .PARAMETER Theme
    Filter theme by name.  Supports wildcards.

    .EXAMPLE
    # Returns every theme.
    PS C:\> Get-MarkdownTheme

    .EXAMPLE
    # Returns every theme starting with d.
    PS C:\> Get-MarkdownTheme "d*"
#>
function Get-MarkdownTheme {
    [CmdletBinding()]
    [OutputType([string])]
    param(

        [parameter(
            Position=0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage='Wild card theme filter.'
        )]
        [string]$Theme
    )

    Set-StrictMode -Version "Latest"

    if (($Theme -eq $null) -or ($Theme -eq "")) {

        $theme = "*"
    }


    (Get-ChildItem "$PSScriptRoot\..\Resources\Themes\*.css").BaseName.foreach({
        if ($_ -like $Theme) {

            Write-Output $_
        }
    })
}
