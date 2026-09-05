param(
    [string]$BinaryPath = ([IO.Path]::Combine($PSScriptRoot, '..\RdpMon\bin\Release\RdpMon.exe'))
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Windows.Forms

function Decode-Text([string]$value) {
    [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($value))
}

$assembly = [Reflection.Assembly]::LoadFrom([IO.Path]::GetFullPath($BinaryPath))
$formType = $assembly.GetType('Cameyo.RdpMon.MainForm', $true)
$form = [Activator]::CreateInstance($formType)

try {
    $expected = @{
        connectionsTab = Decode-Text '6L+e5o6l6K6w5b2V'
        sessionsTab = Decode-Text '5Lya6K+d6K6w5b2V'
        colFailCount = Decode-Text '5aSx6LSl5qyh5pWw'
        colSuccessCount = Decode-Text '5oiQ5Yqf5qyh5pWw'
        colFirstTime = Decode-Text '6aaW5qyh5bCd6K+V'
        colLastTime = Decode-Text '5pyA5ZCO5bCd6K+V'
        sessionsShadowMenuItem = Decode-Text '6L+c56iL5p+l55yL5Lya6K+d'
    }

    foreach ($entry in $expected.GetEnumerator()) {
        $field = $formType.GetField($entry.Key, [Reflection.BindingFlags]'Instance,NonPublic')
        if ($null -eq $field) { throw "Control field not found: $($entry.Key)" }
        $actual = $field.GetValue($form).Text
        if ($actual -ne $entry.Value) {
            throw ('Unexpected text for {0}' -f $entry.Key)
        }
    }

    if ($form.Text -ne (Decode-Text 'UkRQIOiuv+mXruebkeaOpw==')) {
        throw 'Unexpected window title'
    }

    Write-Output 'Simplified Chinese UI check passed.'
}
finally {
    $form.Dispose()
}
