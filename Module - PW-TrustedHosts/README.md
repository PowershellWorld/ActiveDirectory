## Module - PW-TrustedHosts

Module to add/remove a TrustedHost to TrustedHosts for remote management   	

Use: 	<br>																
Place PSM1 in folder : 	<br>
<br>
C:\Program Files\WindowsPowerShell\Modules\<YOURFOLDERNAME>	

Import-Module YOURFOLDERNAME				

New-TrustedHost (FQDN to be trusted) <br><br>
EXAMPLE:<br>
<code> New-TrustedHosts Klimrek.Speeltuin.local</code>

Remove-TrustedHost (FQDN to be untrusted)	 	 <br><br>
EXAMPLE:<br>
<code> Remove-TrustedHost klimrek.speeltuin.local</code>

