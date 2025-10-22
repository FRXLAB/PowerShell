Function global:FRX_Desktop-Get-RecycleBinSize{
	param()
	(New-Object -ComObject Shell.Application).Namespace(0xA).Items() | ForEach-Object{$TailleCorbeille = 0}{
        if($_.isfolder){$taillecorbeille += [int](dir $_.path -Recurse | measure -sum length).sum}
        else           {$taillecorbeille += [int]$_.size}   
    }
    return $TailleCorbeille
}

Function global:FRX_Desktop-Flush-RecycleBin{
    param()
	(New-Object -ComObject Shell.Application).Namespace(0xA).Items() | ForEach-Object{
        Remove-Item $_.Path -Recurse -Confirm:$false
    }
	return $null
}
