$ModuleManifestName = 'PowMark.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\..\Source\PowMark\$ModuleManifestName"

Describe 'ConvertFrom-Markdown Tests' {

    Import-Module $ModuleManifestPath -Force


    It 'Should convert a markdown string.' {

        $actual = ConvertFrom-Markdown -Markdown "**bold text**"

        $actual.Markdown  | Should -Be "**bold text**"
        $actual.HTML      | Should -Be "<p><strong>bold text</strong></p>`n"
        $actual.PlainText | Should -Be 'bold text'
    }

    It 'Should convert multiple markdown strings.' {

        $actual = ConvertFrom-Markdown -Markdown @("**bold text**", "*italic text*")

        $actual[0].HTML | Should -Be "<p><strong>bold text</strong></p>`n"
        $actual[1].HTML | Should -Be "<p><em>italic text</em></p>`n"
    }
}
