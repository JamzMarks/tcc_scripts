# main.ps1

# Caminhos relativos
$InjectorDir = ".\tcc_injector"
$AdapterDir = ".\tcc_adapter"


function Start-DockerCompose($dir) {
    if (Test-Path "$dir\docker-compose.yml") {
        Write-Host "Subindo docker-compose em $dir"
        Push-Location $dir
        docker-compose up -d --build
        Pop-Location
    } else {
        Write-Host "Nenhum docker-compose encontrado em $dir"
    }
}

Write-Host "===== Iniciando Injector ====="
Push-Location $InjectorDir
docker-compose up -d --build
Pop-Location

# --- Rodar adapters ---
Write-Host "===== Iniciando Adapters ====="
# Percorre todas as subpastas de tcc_adapter
Get-ChildItem -Directory $AdapterDir | ForEach-Object {
    $subdir = $_.FullName
    Start-DockerCompose $subdir
}

Write-Host "✅ Todos os serviços iniciados"
