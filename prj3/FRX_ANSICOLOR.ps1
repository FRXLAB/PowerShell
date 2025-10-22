using namespace System.Management.Automation
$global:FRXCOLOR = [PSCustomobject]@{
    Bleu1  = "75;188;237"
    Bleu2  = "50;143;185"
    Bleu3  = "2;47;64"
    Orange = "241;133;45"
    Rouge  = "233;76;75"
    Green  = "135;190;74"
}
$global:FRXCOLORLIST = $FRXCOLOR.PSObject.Properties.Name
function global:FRX_Get-AnsiColor {
    [CmdletBinding()]param ()
    DynamicParam {
        # La liste utilisée est $FRXCOLORLIST 
        # Définir un dictionnaire pour les paramètres dynamiques
        $ParamColors = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameterDictionary

        # Créer les attributs pour le paramètre BackColor
        $backColorAttributes = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $backColorAttr = [ParameterAttribute]::new()
        $backColorAttr.Mandatory = $true
        $backColorAttributes.Add($backColorAttr)
        $validateBackColor = New-Object System.Management.Automation.ValidateSetAttribute($FRXCOLORLIST)
        $backColorAttributes.Add($validateBackColor)
        $backColorParam = New-Object System.Management.Automation.RuntimeDefinedParameter('BackColor', [string], $backColorAttributes)
        $ParamColors.Add('BackColor', $backColorParam)

        # Créer les attributs pour le paramètre ForeColor
        $foreColorAttributes = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $foreColorAttr = [ParameterAttribute]::new()
        $foreColorAttr.Mandatory = $true
        $foreColorAttributes.Add($foreColorAttr)
        $validateForeColor = New-Object System.Management.Automation.ValidateSetAttribute($FRXCOLORLIST)
        $foreColorAttributes.Add($validateForeColor)
        $foreColorParam = New-Object System.Management.Automation.RuntimeDefinedParameter('ForeColor', [string], $foreColorAttributes)
        $ParamColors.Add('ForeColor', $foreColorParam)
        return $ParamColors
    }

    Process {       
        $begin = "$([char]27)["
        $end   = "m"
        $Forecolor = $frxcolor.($ParamColors["Forecolor"].value)
        $backcolor = $frxcolor.($ParamColors["Backcolor"].value)
        $color = $begin + "38;2;"+ $Forecolor +";"+"48;2;"+ $backcolor +  $end 
        return $color



    }
}
function global:FRX_Get-AnsiColorRGB {
    param ($ForeRGB=(255,0,0),$backRGB=(0,0,0))
    
    $Sequence =  "[38;2;$($ForeRGB[0]);$($ForeRGB[1]);$($ForeRGB[2]);48;2;$($backRGB[0]);$($backRGB[1]);$($backRGB[2])m"
    $color = "$([char]27)$Sequence"

    return $color

}


$global:frx_Bleu1      = FRX_Get-AnsiColor -BackColor Bleu3   -ForeColor Bleu1  #"$([char]27)[38;2;75;188;237m"
$global:frx_Bleu2      = FRX_Get-AnsiColor -BackColor Bleu3   -ForeColor Bleu2  #"$([char]27)[38;2;50;143;185m"
$global:frx_Bleu3      = FRX_Get-AnsiColor -BackColor Bleu3   -ForeColor Bleu3  #"$([char]27)[38;2;2;47;64m"
$global:frx_orang      = FRX_Get-AnsiColor -BackColor Bleu3   -ForeColor Orange #"$([char]27)[38;2;241;133;45m"
$global:frx_rouge      = FRX_Get-AnsiColor -BackColor Rouge   -ForeColor Bleu3  #"$([char]27)[38;2;233;76;75m"
$global:frx_green      = FRX_Get-AnsiColor -BackColor Green   -ForeColor Bleu3  #"$([char]27)[38;2;135;190;74m"
$global:frx_backorange = FRX_Get-AnsiColor -BackColor Orange  -ForeColor Bleu3  #"$([char]27)[38;2;135;190;74m"

$global:frx_Reset     ="$([char]27)[0m"


<# lister tous les colorIndex en type 5 ansicolor
1..16 | foreach-Object {$numligne = 1;$colorindex = 1}{   
    1..16 | foreach-object{$ligne = ""}{
        $color = "$([char]27)[38;5;${colorindex}m"
        $ligne += "${color} $($colorindex.tostring().padleft(3," "))"
        $colorindex++
    }
    write-host $ligne
    $numligne++
}#>