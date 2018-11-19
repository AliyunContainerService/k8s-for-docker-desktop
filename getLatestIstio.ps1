param(
    [string] $IstioVersion = "1.0.3"
)

$url = "https://github.com/istio/istio/releases/download/$($IstioVersion)/istio-$($IstioVersion)-win.zip"
$Path = Get-Location
$output = [IO.Path]::Combine($Path, "istio-$($IstioVersion)-win.zip¡±)
    
Write-Host "Downloading Istio from $url to path " $Path -ForegroundColor Green 
    
#Download file
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
(New-Object System.Net.WebClient).DownloadFile($url, $output)
    
# Unzip the Archive
Expand-Archive $output -DestinationPath $Path
    
#Set the environment variable
$IstioHome = [IO.Path]::Combine($Path, "istio-$($IstioVersion)")
    
[Environment]::SetEnvironmentVariable("ISTIO_HOME", "$IstioHome", "User")