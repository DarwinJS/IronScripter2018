
# Works on PSH 6
Function Get-ComputerAndDiskInfo {
  [OutputType("ComputerAndDiskInfo")]
  param(
      [string]$ComputerName = "$env:COMPUTERNAME"
  )
  $ThisSystemsProperties = Get-CIMInstance Win32_OperatingSystem -ComputerName $Computer
  $Volumes = Get-CIMInstance Win32_LogicalDisk -ComputerName $Computer
  Add-Member -InputObject $ThisSystemsProperties -MemberType NoteProperty -Name "Volumes" -Value $Volumes

  ForEach ($Vol in $ThisSystemsProperties.Volumes)
  {
    Add-Member -InputObject $Vol -MemberType NoteProperty -Name "UsedPercent" -Value ((($($Vol.Size))-$($Vol.FreeSpace))/$($Vol.Size)).tostring('P').trimend(' %')
  }

  $ThisSystemsProperties.psobject.TypeNames.Insert(0, "ComputerAndDiskInfo")

  $ThisSystemsProperties 

}
#| select caption, version, servicepackmajor, servicepackminor, manufacturer, windowsdirectory, locale, freephysicalmemory, totalvirtualmemorysize, freevirtualmemory, disk*deviceid, disk*description, disk*size, disk*freespace, disk*compressed, disk*FreePercent | sort-object | fl *