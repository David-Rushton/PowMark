<#
  .SYNOPSIS
  Exports markdown to the file system.

  .DESCRIPTION
  Converts markdown to HTML and saves to the file system.

  .PARAMETER InputObject
  Markdown to convert and save.
  Markdown can be passed as:
   - Text
   - Markdown object
   - File path

  .PARAMETER OutputPath
  Path to save to.

  .PARAMETER Force
  Overwrite existing files, when selected.

  .PARAMETER Theme
  Add a named theme to exported HTML file.

  .EXAMPLE
  # Export markdown to the file system.
  PS C:\> Export-Markdown -Markdown "text" -OutputPath "C:\ExportedFile.html"

  .EXAMPLE
  # Export markdown to the file system, and overwrite existing file.
  PS C:\> Export-Markdown -Markdown "text" -OutputPath "C:\FileThatAlreadyExists.html" -Force

  .EXAMPLE
  # Export markdown to the file system, using a named theme.
  # See Get-MarkdownTheme for supported options.
  PS C:\> Export-Markdown -Markdown "text" -OutputPath "C:\File.html" -Theme "ThemeName"
#>
function Export-Markdown {
    [CmdletBinding()]
    [OutputType([System.IO.FileInfo])]
    param(

        [parameter(
            Mandatory,
            Position=0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage='Markdown text, object or path to markdown file.'
        )]
        [psobject]$InputObject,

        [parameter(
            Mandatory,
            Position=1,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage='Path to export markdown to.'
        )]
        [string]$OutputPath,

        [parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage='Turn this on if you want to overwrite an existing file.'
        )]
        [switch]$Force,

        [parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage='Name of css theme to apply.  Call Get-MarkdownTheme -Theme * for a list of all installed.'
        )]
        [ValidateScript( { (Get-MarkdownTheme) -contains $_ } )]
        [string]$Theme
    )

    Set-StrictMode -Version "Latest"

    $typeName = ($InputObject.GetType()).Name


    # Text.
    if ($typeName -eq 'string') {

        # File mode.
        if (Test-Path -Path $InputObject -PathType "Leaf") {

            Write-Verbose "Importing mardown."
            $markdownObject = Import-Markdown -Path $InputObject
        }
        else { # Markdown text.

            Write-Verbose "Converting mardown."
            $markdownObject = ConvertFrom-Markdown -Markdown $InputObject
        }
    }


    # Markdown object.
    # TODO: Find method to extract PSCustomObject name.
    if ($typeName -eq 'PSCustomObject') {

        $item = (
            Get-Member -InputObject $InputObject |
            Where-Object Name -In @('Markdown', 'HTML', 'PlainText') |
            Measure-Object
        )
        if ($item.Count -eq 3) {

            # OldLeaf.PowMark.Markdown.
            # DUCK DUCK DUCK.
            Write-Verbose "Copying markdown object."
            $markdownObject = $InputObject
        }
    }


    # If above sections created a markdown object then the InputObect type is supported.
    if ($markdownObject) {

        $params = @{
            Path = $OutputPath
            Value = $markdownObject.HTML
            Force = $Force
        }
        Set-Content @params
    }
    else {

        Write-Error "InputObject must be a string, path or 'OldLeaf.PowMark.Markdown' object."
    }
}
