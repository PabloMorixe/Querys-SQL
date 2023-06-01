cls

$cantidadBak = Get-ChildItem E:\BACKUP\BACKUP1\Data\SSPR17DWH-01\Tableros -Recurse -File | Measure-Object | %{$_.Count}

if ( 15 -ne $cantidadBak )
{
	$body = @{
	"eventType"="AVAILABILITY_EVENT"
	"title"="Problema BKP failed DWH - Cantidad Archivos: $cantidadBak Menor a el minimo"
	"timeout"= 30
	"allowDavisMerge"= "false"
	"properties"=@{
	"State"="Fallo backup"
	"DisplayName"="SSPR17DWH-01"
	"Ip"="10.241.162.199"
	"Address"="SSPR17DWH-01"
	"Archivos_actuales"="$cantidadBak"
	"ruta"="E:\BACKUP\BACKUP1\Data\SSPR17DWH-01\Tableros"
    "GrupoResolutor"="BaseDeDatos"
	}
	} | ConvertTo-Json



	$apiAuth = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("ZHQwYzAxLkczS1UzQkdPNVZFWE5BNVpVMkZESkc2QS5GQk9VSkpDQk9SNkk3NTU1SEk3VjQzUVFGVjdOQVBBSlJGMkJFNU5SVzNQVzVOSDRXS1dOSzJUTTVIMlRUQTY1"))

	$header = @{
	 "Accept"="application/json; charset=utf-8"
	 "Authorization"="Api-Token $apiAuth"
	 "Content-Type"="application/json; charset=utf-8"
	} 
    
    ####################deshabilita certificado 
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocoltype]::Tls12
    function Disable-SslVerification {
        if (-not ([System.Management.Automation.PSTypeName]"TrustEverything").Type) {
            Add-Type -TypeDefinition  @"
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
public static class TrustEverything
{
    private static bool ValidationCallback(object sender, X509Certificate certificate, X509Chain chain,
    SslPolicyErrors sslPolicyErrors) { return true; }
    public static void SetCallback() { System.Net.ServicePointManager.ServerCertificateValidationCallback = ValidationCallback; }
    public static void UnsetCallback() { System.Net.ServicePointManager.ServerCertificateValidationCallback = null; } } 
"@
        }
        [TrustEverything]::SetCallback()
    }
    function Enable-SslVerification {
        if (([System.Management.Automation.PSTypeName]"TrustEverything").Type) {
            [TrustEverything]::UnsetCallback()
        }
    }
    Disable-SslVerification   
    ##

	Invoke-RestMethod -Uri "https://asdyn-02:9999/e/xgx85031/api/v2/events/ingest" -Method 'Post' -Body $body -Headers $header
#########
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocoltype]::Tls12
   function Disable-SslVerification {
        if (-not ([System.Management.Automation.PSTypeName]"TrustEverything").Type) {
            Add-Type -TypeDefinition  @"
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
public static class TrustEverything
{
    private static bool ValidationCallback(object sender, X509Certificate certificate, X509Chain chain,
    SslPolicyErrors sslPolicyErrors) { return true; }
    public static void SetCallback() { System.Net.ServicePointManager.ServerCertificateValidationCallback = ValidationCallback; }
    public static void UnsetCallback() { System.Net.ServicePointManager.ServerCertificateValidationCallback = null; } } 
"@
        }
        [TrustEverything]::SetCallback()
    }
function Enable-SslVerification {
	if (([System.Management.Automation.PSTypeName]"TrustEverything").Type) {
		[TrustEverything]::UnsetCallback()
	}
}
Enable-SslVerification
#########





    Write-Output 'mal'
}
else
{
Write-Output 'OK'
}




