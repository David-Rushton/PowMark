$ModuleManifestName = 'PowMark.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\..\Source\PowMark\$ModuleManifestName"

Describe 'ConvertFrom-Markdown Tests' {

    Import-Module $ModuleManifestPath

    It 'Converts markdown strings to HTML.' {

        $expected = "<p>Test text with <strong>bold section</strong>.</p>`n"
        $actual = Convert-pmMarkdownToHTML "Test text with **bold section**."

        $actual | Should Be $expected
    }


    It 'Converts markdown file to HTML' {

        Mock Test-Path { return $true }
        Mock Get-Content { return "Test text with **bold section**." }

        $expected = "<p>Test text with <strong>bold section</strong>.</p>`n"
        $actual = Convert-pmMarkdownToHTML "Mock\Path\For\Testing.md"

        Assert-MockCalled -CommandName 'Test-Path' -Times 1 -Scope It

        $actual | Should Be $expected
    }

}
