################## ADD AND REMOVE TRUSTED HOSTS TO SERVERS #####################
####                                                                        ####
#### Module to add/remove a TrustedHost to TrustedHosts for remote          ####
#### management   							    ####
####									    ####
#### Use: 								    ####
####   Place PSM1 in folder : 						    ####
####		C:\Program Files\WindowsPowerShell\Modules\<YOURFOLDERNAME> ####
####									    ####
####   Import-Module <YOURFOLDERNAME>					    ####
####									    ####
####   New-TrustedHost <FQDN to be trusted>           			    ####
####									    ####
####   Remove-TrustedHost <FQDN to be untrusted>			    ####
####								            ####
################################################################################


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
