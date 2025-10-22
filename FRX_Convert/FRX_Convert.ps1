Function Convert-NombreToRomains {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, 3999)]
        [int]$Nombre
    )
    $map = @{
        1000 = "M"
        900  = "CM"
        500  = "D"
        400  = "CD"
        100  = "C"
        90   = "XC"
        50   = "L"
        40   = "XL"
        10   = "X"
        9    = "IX"
        5    = "V"
        4    = "IV"
        1    = "I"
    }

    $resultat = ""
    $reste = $Nombre 
    foreach ($val in ($map.Keys | Sort-Object -Descending)) {
        while ($reste -ge $val) {
            $resultat += $map[$val]
            $reste -= $val
        }
    }

    return $resultat
}

Function Convert-Seconds {
    param([uint64]$seconds)
    $string = $null
    switch($seconds){
        {$_ -ge 31557600 } {
            $an   = [math]::truncate($_/31557600)
            $_   = $_%31557600
            if($an -ge 1){$string += "$an ans "}}
        {$_ -ge 2635200 } {
            $mois   = [math]::truncate($_/2635200)
            $_   = $_%2635200
            if($mois -ge 1){$string += "$mois mois "}}
        {$_ -ge 604800 } {
            $semaine   = [math]::truncate($_/604800)
            $_   = $_%604800
            if($semaine -ge 1){$string += "$semaine semaines "}} 
        {$_ -ge 86400 } {
            $jours   = [math]::truncate($_/86400)
            $_   = $_%86400
            if($jours -ge 1){$string += "$jours jours "}}
        {$_ -ge 3600 -and $_ -lt 86400} { 
            $heures  = [math]::truncate($_/3600)
            $_   = $_%3600
            if($heures -ge 1){$string += "$heures heures "}}
        {$_ -ge 60 -and $_ -lt 3600} { 
            $minutes = [math]::truncate($_/60) 
            $_ = $_%60
            if($minutes -ge 1){$string += "$minutes minutes "}}
        {$_ -ge  0 -and $_ -lt   60} {
            if($_ -ge 1){$string += "$_ secondes "}}
        Default {}
    }
    return $string
}

function Convert-Octets {
    param([double]$x,$short=$true) 
    $liste  = "Bytes","Kilobytes","Megabytes","Gigabytes","Terabytes","Petabytes","Exabytes","Zettabytes","Yottabytes","Brontobytes","Geopbytes","Saganbytes","Pijabytes","Alphabytes","Kryatbytes","Amosbytes","Pectrolbytes","Bolgerbytes","Sambobytes","Quesabytes","Kinsabytes","RutherBytes","Dubnibytes","Seaborgbytes","Bohrbytes","Hassiubytes","Meitnerbytes","Darmstadbytes","Roentbytes","Coperbytes"
    $liste2 = "Bytes","KB","MB","GB","TB","PB","EB","ZB","YB","Brontobytes","Geopbytes","Saganbytes","Pijabytes","Alphabytes","Kryatbytes","Amosbytes","Pectrolbytes","Bolgerbytes","Sambobytes","Quesabytes","Kinsabytes","RutherBytes","Dubnibytes","Seaborgbytes","Bohrbytes","Hassiubytes","Meitnerbytes","Darmstadbytes","Roentbytes","Coperbytes"
    if($short){$liste = $liste2}
    $i = 0
    while($x -ge 1024 ){
        if($x -ge 1024){$x /= 1024;$i++}
    }#-or $i -eq ($liste.count-1))
    $calcul = "$([system.math]::round($x,2)) $($liste[$i])"
    if($x -le 1 -and !$short){$calcul = $calcul.substring(0,$calcul.length-1)}
    Return $calcul
}

function Convert-SubnetMaskToCIDR{
    param([string]$maskDec)
    $regexSubnetmask = '^(((255\.){3}(255|254|252|248|240|224|192|128|0+))|((255\.){2}(255|254|252|248|240|224|192|128|0+)\.0)|((255\.)(255|254|252|248|240|224|192|128|0+)(\.0+){2})|((255|254|252|248|240|224|192|128|0+)(\.0+){3}))$'
	if($maskDec -match $regexSubnetmask ){
        $maskDec.split(".") | %{$bin += [system.convert]::Tostring($_,2)}
        if($bin -match "01"){return "ERROR"}
        else{$cidr = $bin.replace("0","").length;return $cidr}
    }
    else{
        return "Convert-MaskDecToCIDR --> Mask is malformed"
    }

}
Function Convert-Extension{
    param($extension)
    switch ($extension) {
                    {".ps1",".vbs",".js",".hta",".bat",".sh",".vbe",".ps1xml",".~vbs",".py"            -contains $extension} {$extension = "SCRIPTS"}
                    {".dll"                         -contains $extension} {$extension = "LIBRAIRIES"}
                    {".html",".htm",".url",".java",".jar",".xml",".json"          -contains $extension} {$extension = "WEBFILES"}
                    {".jpg",".bmp",".jpeg",".png",".gif",".ico" -contains $extension} {$extension = "IMAGES"}
                    {".avi",".mkv",".mpg",".mpeg",".mov",".flv",".trec",".mp4",".tscproj"   -contains $extension} {$extension = "VIDEOS"}
                    {".wav",".mp3",".ogg",".m4a",".wma"           -contains $extension} {$extension = "AUDIO"}
                    {".zip",".rar",".tar",".7z",".msu",".iso"           -contains $extension} {$extension = "ArchivesRARZIP"}
                    {".ppt",".xls",".xlsm",".doc",".pdf",".docx",".xlsx",".pptx",".mpp",".ods",".dot" -contains $extension} {$extension = "BUREAUTIQUE"}
                    {".lnk" -contains $extension}{$extension = "RACCOURCIS"}
                    {".msi",".exe" -contains $extension} {$extension = "EXECUTABLES"}
                    {".pcap",".pkt" -contains $extension} {$extension = "NETWORK"}
                    {".log",".csv",".txt",".cfg",".ini",".rtf",".inf" -contains $extension}{$extension = "TEXTFILE"}
                    {".vmdk",".vhdx",".vhd",".vmem",".nvram",".vmss" -contains $extension}{$extension = "VM"}
                   
                    Default {$extension = "DIVERS"}
                }
    return $extension

}
function Convert-SubnetMaskToCIDR{
    param([string]$maskDec)
    $regexSubnetmask = '^(((255\.){3}(255|254|252|248|240|224|192|128|0+))|((255\.){2}(255|254|252|248|240|224|192|128|0+)\.0)|((255\.)(255|254|252|248|240|224|192|128|0+)(\.0+){2})|((255|254|252|248|240|224|192|128|0+)(\.0+){3}))$'
	if($maskDec -match $regexSubnetmask ){
        $maskDec.split(".") | %{$bin += [system.convert]::Tostring($_,2)}
        if($bin -match "01"){return "ERROR"}
        else{$cidr = $bin.replace("0","").length;return $cidr}
    }
    else{
        return "Convert-MaskDecToCIDR --> Mask is malformed"
    }


}
Function Get-SystemUptime{
    param($datestring)
    $date = [Management.ManagementDateTimeConverter]::ToDateTime($datestring)
    return $date
}

function Convert-Euros{
    param([uint64]$x)
    switch ($x)
    {
        {$x -ge     0   -and $x -lt [math]::pow(10,3)      } {$calcul = "$x €"}
        {$x -ge [math]::pow(10, 3) -and $x -lt [math]::pow(10, 6)  } {$calcul = "$([math]::round($x/[math]::pow(10,3),2)) K€"}
        {$x -ge [math]::pow(10, 6) -and $x -lt [math]::pow(10, 9)  } {$calcul = "$([math]::round($x/[math]::pow(10,6),2)) M€"}
        {$x -ge [math]::pow(10, 9) -and $x -lt [math]::pow(10,12)  } {$calcul = "$([math]::round($x/[math]::pow(10,9),2)) B€"}
        {$x -ge [math]::pow(10,12) -and $x -lt [math]::pow(10,15)  } {$calcul = "$([math]::round($x/[math]::pow(10,12),2)) T€"}
        {$x -ge [math]::pow(10,15) } {$calcul = "$([math]::round($x/[math]::pow(2,15))) P€"}

        Default {$calcul = $x}
    }
    Return $calcul
}


<# MAIN SCRIPT 

Convert-SubnetMaskToCIDR "256.255.192.0"

Convert-Seconds 30   #(30 secondes)
Convert-Seconds 61   #(1 minutes et 1 secondes)
Convert-Seconds 2520 #(42 minutes)
Convert-Seconds 2532 #(42 minutes et 12 secondes)
Convert-Seconds 3610 #(1 heure 10 secondes)
Convert-Seconds 6132 #(1 heure 42minutes 12 secondes)
Convert-Seconds 87000
Convert-Seconds 1587352

$TailleMEF = convertOctet 1000     ; write-host $taillemef
$TailleMEF = convertOctet 1025     ; write-host $taillemef
$TailleMEF = convertOctet 16000000 ; write-host $taillemef
cd c:\windows\system32
get-childitem *.exe -recurse `
| ?{$_.length -gt 5MB} `
| Sort-Object length -Descending `
| select-object -first 5 | select-object fullname,length `
| %{write-host "$($_.fullname) --> $(ConvertOctet $_.length)"} 


Get-SystemUptime (gwmi win32_operatingsystem).lastbootuptime
get-adcomputer -filter * -properties lastlogontimestamp | ForEach-Object {
    $_.dnshostname
    [datetime]::FromFileTime($_.lastlogontimestamp)
} 
#>

