## Module - PW-LocalSecurityPolicy

PW-LocalSecurityPolicy.psm1 Powershell Module enables user to edit Local Security Policy by Powershell.
Simple use command with Username and it is set.  	

Use: 	<br>																
Place PSM1 in folder : 	<br>
<br>
C:\Program Files\WindowsPowerShell\Modules\<YOURFOLDERNAME>	

Import-Module YOURFOLDERNAME				

<code>PW-LSP-AddLogonAsAService <username></code>
* Add user to Logon As A Service in the Local Security Policy

<code>PW-LSP-DenyLogonLocally <username></code>
* Add user to Deny Logon Locally in the Local Security Policy

<code>PW-LSP-DenyAccessFromNetwork <username></code>
* Add user to Deny access to this computer from the network in the Local Security Policy
