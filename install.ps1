# 🚀 Instalador do Prismium para Windows
# Este script baixa e instala o Prismium no Windows

param(
    [string]$Version = "v1.0.0"
)

# Configurações
$REPO = "luizguil99/prismium"  # Repositório oficial do Prismium
$BINARY_NAME = "prismium"
$INSTALL_DIR = "$env:USERPROFILE\.local\bin"

# Cores para output
function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# Detectar arquitetura
function Get-Architecture {
    if ([Environment]::Is64BitOperatingSystem) {
        return "x86_64"
    } else {
        return "i386"
    }
}

# Obter versão mais recente
function Get-LatestVersion {
    try {
        $response = Invoke-RestMethod -Uri "https://api.github.com/repos/$REPO/releases/latest"
        return $response.tag_name
    }
    catch {
        Write-Error "Falha ao obter versão mais recente: $_"
        return $null
    }
}

# Baixar e instalar o binário
function Install-Prismium {
    param(
        [string]$Platform,
        [string]$Version
    )
    
    Write-Info "Detectado: $Platform"
    Write-Info "Baixando Prismium $Version..."
    
    # URL do release
    $url = "https://github.com/$REPO/releases/download/$Version/prismium_${Version}_${Platform}.zip"
    
    # Tentar baixar
    try {
        $tempFile = "$env:TEMP\prismium.zip"
        Invoke-WebRequest -Uri $url -OutFile $tempFile
        Write-Success "Binário baixado com sucesso!"
    }
    catch {
        Write-Error "Falha ao baixar o binário para $Platform"
        Write-Info "Tentando com nome alternativo..."
        
        # Tentar com nome alternativo
        $url = "https://github.com/$REPO/releases/download/$Version/prismium_${Platform}.zip"
        try {
            Invoke-WebRequest -Uri $url -OutFile $tempFile
            Write-Success "Binário baixado com sucesso!"
        }
        catch {
            Write-Error "Não foi possível baixar o binário"
            return $false
        }
    }
    
    # Extrair
    Write-Info "Extraindo binário..."
    $extractDir = "$env:TEMP\prismium"
    Expand-Archive -Path $tempFile -DestinationPath $extractDir -Force
    
    # Criar diretório de instalação
    if (!(Test-Path $INSTALL_DIR)) {
        New-Item -ItemType Directory -Path $INSTALL_DIR -Force | Out-Null
    }
    
    # Instalar binário
    $binaryPath = "$extractDir\prismium.exe"
    if (Test-Path $binaryPath) {
        Copy-Item $binaryPath "$INSTALL_DIR\$BINARY_NAME.exe" -Force
        Write-Success "Prismium instalado em $INSTALL_DIR\$BINARY_NAME.exe"
    } else {
        Write-Error "Binário não encontrado após extração"
        return $false
    }
    
    # Limpar arquivos temporários
    Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
    Remove-Item $extractDir -Recurse -Force -ErrorAction SilentlyContinue
    
    return $true
}

# Configurar PATH
function Setup-Path {
    $currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    
    if ($currentPath -notlike "*$INSTALL_DIR*") {
        Write-Info "Adicionando $INSTALL_DIR ao PATH do usuário"
        [Environment]::SetEnvironmentVariable("PATH", "$currentPath;$INSTALL_DIR", "User")
        Write-Success "PATH configurado! Reinicie o terminal ou execute: refreshenv"
    } else {
        Write-Success "PATH já está configurado"
    }
}

# Função principal
function Main {
    Write-Host "🚀 Instalador do Prismium para Windows" -ForegroundColor Cyan
    Write-Host "=======================================" -ForegroundColor Cyan
    Write-Host ""
    
    # Verificar se é PowerShell 5.1 ou superior
    if ($PSVersionTable.PSVersion.Major -lt 5) {
        Write-Error "PowerShell 5.1 ou superior é necessário"
        exit 1
    }
    
    # Detectar plataforma
    $arch = Get-Architecture
    $platform = "Windows_$arch"
    
    Write-Info "Plataforma detectada: $platform"
    
    # Obter versão
    if ($Version -eq "latest") {
        Write-Info "Verificando versão mais recente..."
        $Version = Get-LatestVersion
        
        if (!$Version) {
            Write-Error "Não foi possível obter a versão mais recente"
            exit 1
        }
    }
    
    Write-Success "Versão: $Version"
    
    # Instalar
    if (Install-Prismium $platform $Version) {
        Setup-Path
        
        Write-Host ""
        Write-Success "🎉 Prismium instalado com sucesso!"
        Write-Host ""
        Write-Info "Para usar o Prismium:"
        Write-Host "  1. Reinicie o terminal ou execute: refreshenv"
        Write-Host "  2. Execute: prismium"
        Write-Host ""
        Write-Info "Para configurar API keys:"
        Write-Host "  prismium --help"
        Write-Host ""
        Write-Info "Documentação: https://github.com/$REPO"
    } else {
        Write-Error "Falha na instalação"
        exit 1
    }
}

# Executar função principal
Main
