################## ADD AND REMOVE TRUSTED HOSTS TO SERVERS #####################
####                                                                        ####










function New-TrustedHost 
{
	Param
	(
		[parameter(Mandatory=$true)]
		[String]$RemoteDomain
	)
$TrustedHostsGW = $(Get-Item WSMAN:\Localhost\Client\TrustedHosts).value
$NewTrustedHost = set-item wsman:\localhost\Client\TrustedHosts -value "$TrustedHostsGW, $RemoteDomain" -Force
}

function Remove-TrustedHost
{
	Param
	(
		[parameter(Mandatory=$true)]
		[String]$RemoteDomain
	)


$TrustedHosts = ((Get-Item WSMan:\localhost\Client\TrustedHosts).Value).Replace("$RemoteDomain,","")
Set-Item WSMan:\localhost\Client\TrustedHosts $TrustedHosts -force
}