$ModuleManifestName = 'PowMark.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\..\Source\PowMark\$ModuleManifestName"

Describe 'Import-Markdown Tests' {

    Import-Module $ModuleManifestPath -Force



    It 'Should impact a test file' {

        $path = "TestDrive:\MDTest.md"
        Set-Content -Path $path -Value "**bold text**"

        $expected = "<p><strong>bold text</strong></p>`n"
        $actual = (Import-Markdown -Path $path).HTML

        $actual | Should -Be $expected
    }


    It 'Should import a mock file.' {

        Mock Test-Path { $true } -ModuleName PowMark -Verifiable
        Mock Get-Content { "**bold text**" } -ModuleName PowMark -Verifiable
        Mock Resolve-Path { "C:\MockFile.md" } -ModuleName PowMark -Verifiable

        $actual = Import-Markdown -Path "C:\MockFile.md"

        $actual.Markdown  | Should -Be "**bold text**"
        $actual.HTML      | Should -Be "<p><strong>bold text</strong></p>`n"
        $actual.PlainText | Should -Be 'bold text'

        Assert-VerifiableMock
    }


    It 'Should import multiple mock files.' {

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
