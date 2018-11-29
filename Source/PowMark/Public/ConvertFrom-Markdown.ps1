<#
    .SYNOPSIS
    Converts markdown to HTML.

    .DESCRIPTION
    Using the Markdig library; converts markdown to HTML.

    .PARAMETER InputObject
    Can be a path to a text file or a literal string.
#>
function Convert-MarkdownToHTML {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(
            Mandatory,
            Position=1,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [string[]]$InputObject
    )

    begin {

        Write-Verbose "Building markdown pipeline."
        $pipelineBuilder = [Markdig.MarkdownPipelineBuilder]::new()
        $pipeline = [Markdig.MarkdownExtensions]::UseAdvancedExtensions($pipelineBuilder).Build()
    }


    process {

        foreach ($object in $InputObject) {
            if (Test-Path $object -PathType 'Leaf') {

                Write-Verbose "Converting file to HTML: $object."
                [string]$markdown = Get-Content -Path $object -Raw
            }

            else {

                Write-Verbose "Converting string to markdown: $object."
                [string]$markdown = $object
            }

            Write-Output ([Markdig.Markdown]::ToHtml($markdown, $pipeline))
        }
    }


    end {

    }
}
