$ModuleManifestName = 'PowMark.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\..\Source\PowMark\$ModuleManifestName"

Describe 'Import-Markdown Tests' {

    Import-Module $ModuleManifestPath -Force


    It 'Should import a file.' {

        Mock Test-Path { $true } -ModuleName PowMark -Verifiable
        Mock Get-Content { "**bold text**" } -ModuleName PowMark -Verifiable
        Mock Resolve-Path { "C:\MockFile.md" } -ModuleName PowMark -Verifiable

        $actual = Import-Markdown -Path "C:\MockFile.md"

        $actual.Markdown  | Should -Be "**bold text**"
        $actual.HTML      | Should -Be "<p><strong>bold text</strong></p>`n"
        $actual.PlainText | Should -Be 'bold text'

        Assert-VerifiableMock
    }


    It 'Should import multiple files.' {

        Mock Test-Path { $true } -ModuleName PowMark -Verifiable
        Mock Get-Content { "**bold text**" } -ModuleName PowMark -Verifiable
        Mock Resolve-Path { "C:\MockFile.md" } -ModuleName PowMark -Verifiable

        $actual = Import-Markdown -Path @("C:\MockFile1.md", "C:\MockFile2.md")

        $actual              | Should -HaveCount 2
        $actual[0].HTML      | Should -Be "<p><strong>bold text</strong></p>`n"
        $actual[1].PlainText | Should -Be 'bold text'

        Assert-VerifiableMock
    }
}
