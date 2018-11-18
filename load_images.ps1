foreach($line in Get-Content .\images.properties) {
    $data = $line.Split('=')
    $key = $data[0];
    $value = $data[1];
    Write-Output "$key=$value"
    docker pull ${value}
    docker tag ${value} ${key}
    docker rmi ${value}
}