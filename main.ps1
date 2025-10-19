# main.ps1

# Caminhos absolutos baseados no diretório do script
$InjectorDir = Join-Path $PSScriptRoot "tcc_injector"
$AdaptersRootDir = Join-Path $PSScriptRoot "tcc_adapters"

function Start-DockerCompose($dir) {
    if (Test-Path (Join-Path $dir "docker-compose.yaml")) {
        Write-Host "Subindo docker-compose em $dir"
        Push-Location $dir
        try {
            docker-compose up -d --build
        } finally {
            Pop-Location
        }
    } else {
        Write-Host "Nenhum docker-compose encontrado em $dir"
    }
}

# --- Rodar injector ---
Write-Host "===== Starting Injector ====="
Start-DockerCompose $InjectorDir

# --- Rodar todos os adapters ---
Write-Host "===== Starting Adapters ====="

# Pega todas as subpastas de tcc_adapters
$adapterDirs = Get-ChildItem -Path $AdaptersRootDir -Directory

foreach ($dir in $adapterDirs) {
    Write-Host $dir
    Start-DockerCompose $dir.FullName
}
