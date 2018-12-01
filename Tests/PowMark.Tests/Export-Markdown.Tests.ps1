$ModuleManifestName = 'PowMark.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\..\Source\PowMark\$ModuleManifestName"

Describe 'Get-MarkdownTheme Tests' {

    Import-Module $ModuleManifestPath -Force


    Context 'Mocked file system' {

        $testMarkdown = "**bold text**"
        $testMarkdownPath = "TestDrive:\Test.md"
        $testHtmlPath = "TestDrive:\test.html"
        Set-Content -Path $testMarkdownPath -Value $testMarkdown


        It 'Should export a markdown object to a HTML file.' {

            $mdObj = ConvertFrom-Markdown -Markdown $testMarkdown
            Export-Markdown -InputObject $mdObj -OutputPath $testHtmlPath -Force
            $expected = "<p><strong>bold text</strong></p>`n"
            $actual = Get-Content -Path $testHtmlPath -Raw

            $actual | Should -Be $expected
        }


        It 'Should export a markdown string to a HTML file.' {

            Export-Markdown -InputObject $testMarkdown -OutputPath $testHtmlPath -Force
            $expected = "<p><strong>bold text</strong></p>`n"
            $actual = Get-Content -Path $testHtmlPath -Raw

            $actual | Should -Be $expected
        }


        It 'Should import a markdown file and export a HTML file.' {

            Export-Markdown -InputObject $testMarkdownPath -OutputPath $testHtmlPath -Force
            $expected = "<p><strong>bold text</strong></p>`n"
            $actual = Get-Content -Path $testHtmlPath -Raw

            $actual | Should -Be $expected
        }

    }
}
