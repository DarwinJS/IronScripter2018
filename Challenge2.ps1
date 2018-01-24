

# Works on Windows 7 PSH 2 through Nano RTM without Windows Updates Run (lotsa stuff broken)
$ThisSystemsProperties = New-Object -TypeName PSCustomObject
$(wmic os get * /format:list | where {$_ -ne ''} | %{Add-Member -InputObject $ThisSystemsProperties -MemberType NoteProperty -Name "$($_.split('=')[0])" -Value "$($_.split('=')[1])"})
$(wmic logicaldisk get * /format:list | where {$_ -ne ''} | %{If ("$($_.split('=')[0])" -ieq "Access") {$disknumber++} ; Add-Member -InputObject $ThisSystemsProperties -MemberType NoteProperty -Name "Disk${DiskNumber}$($_.split('=')[0])" -Value "$($_.split('=')[1])"})

ForEach ($number in 1..30)
{
  If ([bool]($ThisSystemsProperties.PSobject.Properties.name -match "Disk${Number}Size"))
  {    
    Add-Member -InputObject $ThisSystemsProperties -MemberType NoteProperty -Name "Disk${number}FreePercent" -Value ($ThisSystemsProperties."Disk${Number}FreeSpace"/$ThisSystemsProperties."Disk${Number}Size").tostring('P').trimend(' %')
  }
  else 
  {
    Break
  }
}

write-host $ThisSystemsProperties