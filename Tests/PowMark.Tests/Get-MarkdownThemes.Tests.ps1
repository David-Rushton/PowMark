$ModuleManifestName = 'PowMark.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\..\Source\PowMark\$ModuleManifestName"

Describe 'Get-MarkdownTheme Tests' {

    Import-Module $ModuleManifestPath -Force


    It 'Should return a list of themes.' {

        $actual = Get-MarkdownTheme

        $actual.Count | Should -BeGreaterOrEqual 2
    }

    It 'Should contain the default themes.' {

        $expected = 'Default'
        $actual = Get-MarkdownTheme -Theme 'Default'

        $actual | Should -Be $expected
    }
}
