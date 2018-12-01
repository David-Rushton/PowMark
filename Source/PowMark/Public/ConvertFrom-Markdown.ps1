<#
    .SYNOPSIS
    Converts markdown.

    .DESCRIPTION
    Converts markdown into HTML and plain text, using the exellant Markdig
    library.

    .PARAMETER Markdown
    Markdown to be converted.

    .EXAMPLE
    # Converting Markdown.
    PS C:\> Convert-Markdown -Markdown "**bold text.**"
#>
function ConvertFrom-Markdown {
    [CmdletBinding()]
    [OutputType('OldLeaf.PowMark.Markdown')]
    param(

        [Parameter(
            Mandatory,
            Position=0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage='Markdown to convert.'
        )]
        [string[]]
        $Markdown
    )

    begin {

        Set-StrictMode -Version "Latest"

        Write-Verbose "Building markdown pipeline."
        $pipelineBuilder = [Markdig.MarkdownPipelineBuilder]::new()
        $pipeline = [Markdig.MarkdownExtensions]::UseAdvancedExtensions($pipelineBuilder).Build()
    }


    process {
        foreach ($item in $Markdown) {

            Write-Output ([PSCustomObject]@{
                Markdown = $item
                HTML = [Markdig.Markdown]::ToHtml($item, $pipeline)
                PlainText = [Markdig.Markdown]::ToPlainText($item, $pipeline)
            })
        }
    }


    end {

    }
}
