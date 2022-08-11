write-output 'System Hardware Information'

$hardware = get-wmiObject Win32_ComputerSystem

foreach ($hardinfo in $hardware) {
	$properties = @{'domain' = $hardinfo.domain;
					'manufacturer' = $hardinfo.manufacturer;
					'model' = $hardinfo.model;
					'owner' = $hardinfo.primaryownername;
					'ram' = [int]$hardinfo.totalphysicalmemory/1gb;
					}
}
foreach($property in $properties) {
	if ($property -eq "") {
		$property = "Not Avaliable"
	}
}

$hardwareobj = new-object -TypeName PSObject -Property $properties
write-output $hardwareobj


write-output 'Operating System Information'

$software = get-wmiObject Win32_OperatingSystem

foreach ($softinfo in $software) {
	$properties = @{'sysfolder' = $softinfo.systemdirectory;
					'organization' = $softinfo.organization;
					'build' = $softinfo.buildnumber;
					'username' = $softinfo.registereduser;
					'serialnumber' = $softinfo.serialnumber;
					'version' = $softinfo.version;
					}
}

foreach($property in $properties) {
	if ($property -eq "") {
		$property = "Not Avaliable"
	}
}

$softobj = new-object -TypeName PSObject -Property $properties
write-output $softobj

write-output 'System Processor Information'

$processors = get-wmiObject Win32_Processor

foreach ($processor in $processors) {
	foreach ($cpuinfo in $processor) { 
		$properties = @{'name' = $cpuinfo.name;
						'clock speed' = $cpuinfo.currentclockspeed;
						'cores' = $cpuinfo.numberofcores;
						'l1 Cache Size' = $cpuinfo.l1cachesize;
						'l2 Cache Size' = $cpuinfo.l2cachesize;
						'l3 Cache Size' = $cpuinfo.l3cachesize;
						}
		$cpuobj = new-object -TypeName PSObject -Property $properties
		write-output $cpuobj
	}	
}

write-output 'System RAM Information'

$totalram = 0
$ram = get-wmiObject Win32_PhysicalMemory

foreach ($raminfo in $ram) {
	$properties = @{'label' = $raminfo.BankLabel;
					'manufacturer' = $raminfo.manufacturer
					'description' = $raminfo.description
					'capacity (MB)' = [long]$raminfo.capacity / 1mb
	
	}
	$totalram += $raminfo.capacity / 1mb
}

foreach($property in $properties) {
	if ($property -eq "") {
		$property = "Not Avaliable"
	}
}

$ramobj = new-object -TypeName PSObject -Property $properties
write-output $ramobj
write-output "total ram: ${ramobj}MB"


write-output 'System Disk Drive Information'
$diskdrives = Get-CIMInstance CIM_diskdrive

foreach ($disk in $diskdrives) {
  $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition
  foreach ($partition in $partitions) {
		$logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
		foreach ($logicaldisk in $logicaldisks) {
				 new-object -typename psobject -property @{Manufacturer=$disk.Manufacturer
														   Location=$partition.deviceid
														   Drive=$logicaldisk.deviceid
														   "Size(GB)"=$logicaldisk.size / 1gb -as [int]
														   }
	   }
  }
}

write-output 'System Network Information'
get-ciminstance win32_networkadapterconfiguration | ? ipenabled -eq "true" | Select-Object Description, Index, IPAddress, IPSubnet, DNSDomain, DNSServerSearchOrder | Format-Table -AutoSize

write-output 'System Video Information'
get-wmiObject Win32_VideoController | Select-Object Name, description, VideoModeDescription