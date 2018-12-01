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

  .PARAMETER Theme
  Add a named theme to exported HTML file.

  .PARAMETER OutputPath
  Path to save to.

  .PARAMETER Force
  Overwrite existing files, when selected.

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
        [psobject]$InputObject
    )

    Set-StrictMode -Version "Latest"


    $typeName = ($InputObject.GetType()).Name
    If ($typeName -eq 'string') {

    }


    if ($typeName -eq 'PSCustomObject') {
        $item = ($InputObject | Get-Member | Where-Object Name Name -In @('Markdown', 'HTML', 'PlainText') | Measure-Object)
        if ($item.Count -eq 3) {

            # OldLead.PowMark.Markdown DUCK DUCK DUCK.
        }
    }


    # This block will only execute if all earlier blocks have faild to process
    # the input object.  In which case, we do not support the format.
    Write-Error "InputObject must be a string, path or OldLead.PowMark.Markdown object."
}
