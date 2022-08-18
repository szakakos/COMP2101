function welcome {
	write-output "Welcome to planet $env:computername Overlord $env:username"
	$now = get-date -format 'HH:MM tt on dddd'
	write-output "It is $now."
}

welcome

function get-cpuinfo {
	$cpu = get-ciminstance cim_processor
	$cpu.Manufacturer, $cpu.name, $cpu.currentclockspeed, $cpu.maxclockspeed, $cpu.numberofcores
}

function get-mydisks {
	Get-PhysicalDisk | ft -AutoSize Manufacturer,SerialNumber,FirmwareVersion,Size

	#$diskManu=Get-PhysicalDisk | ft Manufacturer | out-string
	#$diskSerial=Get-PhysicalDisk | ft SerialNumber | out-string
	#$diskFirmware=Get-PhysicalDisk | ft FirmwareVersion | out-string
	#$diskSize=Get-PhysicalDisk | ft Size | out-string

	#$props = @{
	#	Manufacturer=$diskManu
	#	Serial=$diskSerial
	#	Firmware=$diskFirmware
	#	Size=$diskSize
	#}

	#$diskObject = New-Object -TypeName PSObject -Property $props


function displayInfo
{
	Param
	(
         	[Parameter(Mandatory=$false, Position=0)]
         	[int] $showNum
	)
	
	switch($showNum)
	{
		0 {Get-HardInfo
		   Get-Sysinfo
		   Get-CPUInfo
		   Get-RAMInfo
		   Get-DiskInfo
		   Get-NetInfo
		   Get-VideoInfo}
		1 {Get-CPUInfo
		   Get-Sysinfo
		   Get-RAMInfo
		   Get-VideoInfo}
		2 {Get-DiskInfo}
		3 {Get-NetInfo}
		Default {Get-HardInfo
		   Get-Sysinfo
		   Get-CPUInfo
		   Get-RAMInfo
		   Get-DiskInfo
		   Get-NetInfo
		   Get-VideoInfo}
	}
}


function Get-HardInfo
{
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
}



function Get-SysInfo
{
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
}


function Get-CPUInfo
{
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
}

function Get-RAMInfo
{
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
}

function Get-DiskInfo
{
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
}

function Get-NetInfo
{
	write-output 'System Network Information'
	get-ciminstance win32_networkadapterconfiguration | ? ipenabled -eq "true" | Select-Object Description, Index, IPAddress, IPSubnet, DNSDomain, DNSServerSearchOrder | Format-Table -AutoSize
}

function Get-VideoInfo
{
	write-output 'System Video Information'
	get-wmiObject Win32_VideoController | Select-Object Name, description, VideoModeDescription
}