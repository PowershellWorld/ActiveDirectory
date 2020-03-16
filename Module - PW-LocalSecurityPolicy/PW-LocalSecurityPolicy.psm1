<#	
	===========================================================================
	 Created on:   	13/03/2020 15:41
	 Created by:   	John Doe
	 Organization: 	PowershellWorld for Buzz-ICT
	 Filename:     	PW-LocalSecurityPolicy.psm1
	 Website: 		https://www.powershellworld.com
	-------------------------------------------------------------------------
	 Module Name: PW-LocalSecurityPolicy
	===========================================================================
	.DESCRIPTION
		PW-LocalSecurityPolicy.psm1 Powershell Module enables user to edit Local Security Policy by Powershell.
		Simple use command with Username and it is set.
	
	.OUTPUTS
		PW-LSP-AddLogonAsAService <username>
		* Add user to Logon As A Service in the Local Security Policy

		PW-LSP-DenyLogonLocally <username>
		* Add user to Deny Logon Locally in the Local Security Policy

		PW-LSP-DenyAccessFromNetwork <username>
		* Add user to Deny access to this computer from the network in the Local Security Policy

#>



function PW-LSP-AddLogonAsAService
{
	param ($accountToAdd)
	
	if ([string]::IsNullOrEmpty($accountToAdd))
	{
		Write-Host "no account specified"
		exit
	}
	
	$sidstr = $null
	try
	{
		$ntprincipal = new-object System.Security.Principal.NTAccount "$accountToAdd"
		$sid = $ntprincipal.Translate([System.Security.Principal.SecurityIdentifier])
		$sidstr = $sid.Value.ToString()
	}
	catch
	{
		$sidstr = $null
	}
	
	Write-Host "Adding $($accountToAdd) to Logon As A Service in the Local Security Policy" -ForegroundColor Green
	
	if ([string]::IsNullOrEmpty($sidstr))
	{
		Write-Host "Account not found!" -ForegroundColor Red
		exit -1
	}
	
	Write-Host "Account $($accountToAdd) has SID $($sidstr)" -ForegroundColor Green
	
	$tmp = [System.IO.Path]::GetTempFileName()
	
	Write-Host "Saving current settings in Local Security Policy"  -ForegroundColor Green
	secedit.exe /export /cfg "$($tmp)"
	
	$c = Get-Content -Path $tmp
	
	$currentSetting = ""
	
	foreach ($s in $c)
	{
		if ($s -like "SeServiceLogonRight*")
		{
			$x = $s.split("=", [System.StringSplitOptions]::RemoveEmptyEntries)
			$currentSetting = $x[1].Trim()
		}
	}
	
	if ($currentSetting -notlike "*$($sidstr)*")
	{
		Write-Host "Modify Setting ""Logon as a Service""" -ForegroundColor Orange
		
		if ([string]::IsNullOrEmpty($currentSetting))
		{
			$currentSetting = "*$($sidstr)"
		}
		else
		{
			$currentSetting = "*$($sidstr),$($currentSetting)"
		}
		
		Write-Host "$currentSetting"
		
		$outfile = @"
[Unicode]
Unicode=yes
[Version]
signature="`$CHICAGO`$"
Revision=1
[Privilege Rights]
SeServiceLogonRight = $($currentSetting)
"@
		
		$tmp2 = [System.IO.Path]::GetTempFileName()
		
		
		Write-Host "Import new settings to Local Security Policy" -ForegroundColor Green
		$outfile | Set-Content -Path $tmp2 -Encoding Unicode -Force
		
		#notepad.exe $tmp2
		Push-Location (Split-Path $tmp2)
		
		try
		{
			secedit.exe /configure /db "secedit.sdb" /cfg "$($tmp2)" /areas USER_RIGHTS
			#write-host "secedit.exe /configure /db ""secedit.sdb"" /cfg ""$($tmp2)"" /areas USER_RIGHTS "
		}
		finally
		{
			Pop-Location
		}
	}
	else
	{
		Write-Host "NO ACTIONS REQUIRED! Account already in ""Logon as a Service""" -ForegroundColor Red
	}
	
	Write-Host "User $($accountToAdd) is added to ""Logon As A Service"" in the Local Security Policy" -ForegroundColor Green
	
}

function PW-LSP-DenyLogonLocally
{
	param ($accountToAdd)
	if ([string]::IsNullOrEmpty($accountToAdd))
	{
		Write-Host "no account specified"
		exit
	}
	
	## ---> End of Config
	
	$sidstr = $null
	try
	{
		$ntprincipal = new-object System.Security.Principal.NTAccount "$accountToAdd"
		$sid = $ntprincipal.Translate([System.Security.Principal.SecurityIdentifier])
		$sidstr = $sid.Value.ToString()
	}
	catch
	{
		$sidstr = $null
	}
	
	Write-Host "Adding $($accountToAdd) to Deny Logon Locally in the Local Security Policy" 
	
	if ([string]::IsNullOrEmpty($sidstr))
	{
		Write-Host "Account not found!" -ForegroundColor Red
		exit -1
	}
	
	Write-Host "Account $($accountToAdd) has SID $($sidstr)" -ForegroundColor Green
	
	$tmp = [System.IO.Path]::GetTempFileName()
	
	Write-Host "Export current Local Security Policy" -ForegroundColor Green
	secedit.exe /export /cfg "$($tmp)"
	
	$c = Get-Content -Path $tmp
	
	$currentSetting = ""
	
	foreach ($s in $c)
	{
		if ($s -like "SeDenyInteractiveLogonRight*")
		{
			$x = $s.split("=", [System.StringSplitOptions]::RemoveEmptyEntries)
			$currentSetting = $x[1].Trim()
		}
	}
	
	if ($currentSetting -notlike "*$($sidstr)*")
	{
		Write-Host "Modify Setting ""Deny Logon Locally""" -ForegroundColor Orange
		
		if ([string]::IsNullOrEmpty($currentSetting))
		{
			$currentSetting = "*$($sidstr)"
		}
		else
		{
			$currentSetting = "*$($sidstr),$($currentSetting)"
		}
		
		Write-Host "$currentSetting"
		
		$outfile = @"
[Unicode]
Unicode=yes
[Version]
signature="`$CHICAGO`$"
Revision=1
[Privilege Rights]
SeDenyInteractiveLogonRight = $($currentSetting)
"@
		
		$tmp2 = [System.IO.Path]::GetTempFileName()
		
		
		Write-Host "Import new settings to Local Security Policy" -ForegroundColor Green
		$outfile | Set-Content -Path $tmp2 -Encoding Unicode -Force
		
		#notepad.exe $tmp2
		Push-Location (Split-Path $tmp2)
		
		try
		{
			secedit.exe /configure /db "secedit.sdb" /cfg "$($tmp2)" /areas USER_RIGHTS
			#write-host "secedit.exe /configure /db ""secedit.sdb"" /cfg ""$($tmp2)"" /areas USER_RIGHTS "
		}
		finally
		{
			Pop-Location
		}
	}
	else
	{
		Write-Host "NO ACTIONS REQUIRED! Account already in ""Deny Logon Locally""" -ForegroundColor Red
	}
	
	Write-Host "User $($accountToAdd) is added to ""Deny Logon Locally"" in the Local Security Policy" -ForegroundColor Green
	
}

function PW-LSP-DenyAccessFromNetwork
{
	param ($accountToAdd)
	if ([string]::IsNullOrEmpty($accountToAdd))
	{
		Write-Host "no account specified" -ForegroundColor Red
		exit
	}
	
	## ---> End of Config
	
	$sidstr = $null
	try
	{
		$ntprincipal = new-object System.Security.Principal.NTAccount "$accountToAdd"
		$sid = $ntprincipal.Translate([System.Security.Principal.SecurityIdentifier])
		$sidstr = $sid.Value.ToString()
	}
	catch
	{
		$sidstr = $null
	}
	
	Write-Host "Adding $($accountToAdd) to ""Deny access to this computer from the network""  in the Local Security Policy" -ForegroundColor Green
	
	if ([string]::IsNullOrEmpty($sidstr))
	{
		Write-Host "Account not found!" -ForegroundColor Red
		exit -1
	}
	
	Write-Host "Account $($accountToAdd) has SID $($sidstr)" -ForegroundColor Green
	
	$tmp = [System.IO.Path]::GetTempFileName()
	
	Write-Host "Export current Local Security Policy" -ForegroundColor Green
	secedit.exe /export /cfg "$($tmp)"
	
	$c = Get-Content -Path $tmp
	
	$currentSetting = ""
	
	foreach ($s in $c)
	{
		if ($s -like "SeNetworkLogonRight*")
		{
			$x = $s.split("=", [System.StringSplitOptions]::RemoveEmptyEntries)
			$currentSetting = $x[1].Trim()
		}
	}
	
	if ($currentSetting -notlike "*$($sidstr)*")
	{
		Write-Host "Modify Setting ""Deny access to this computer from the network""" -ForegroundColor Orange
		
		if ([string]::IsNullOrEmpty($currentSetting))
		{
			$currentSetting = "*$($sidstr)"
		}
		else
		{
			$currentSetting = "*$($sidstr),$($currentSetting)"
		}
		
		Write-Host "$currentSetting"
		
		$outfile = @"
[Unicode]
Unicode=yes
[Version]
signature="`$CHICAGO`$"
Revision=1
[Privilege Rights]
SeNetworkLogonRight = $($currentSetting)
"@
		
		$tmp2 = [System.IO.Path]::GetTempFileName()
		
		
		Write-Host "Import new settings to Local Security Policy" -ForegroundColor Green
		$outfile | Set-Content -Path $tmp2 -Encoding Unicode -Force
		
		#notepad.exe $tmp2
		Push-Location (Split-Path $tmp2)
		
		try
		{
			secedit.exe /configure /db "secedit.sdb" /cfg "$($tmp2)" /areas USER_RIGHTS
			#write-host "secedit.exe /configure /db ""secedit.sdb"" /cfg ""$($tmp2)"" /areas USER_RIGHTS "
		}
		finally
		{
			Pop-Location
		}
	}
	else
	{
		Write-Host "NO ACTIONS REQUIRED! Account already in ""Deny access to this computer from the network""" -ForegroundColor Red
	}
	
	Write-Host "User $($accountToAdd) is added to ""Deny access to this computer from the network"" in the Local Security Policy." -ForegroundColor Green
	
}

