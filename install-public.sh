#!/bin/bash

# 🚀 Instalador do Prismium via Releases Públicos
# Este script baixa e instala o Prismium dos releases públicos

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configurações
REPO="luizguil99/terminal-cli"
BINARY_NAME="prismium"
INSTALL_DIR="$HOME/.local/bin"

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detectar sistema operacional e arquitetura
detect_os() {
    local os=""
    local arch=""
    
    case "$(uname -s)" in
        Linux*)     os="linux" ;;
        Darwin*)    os="darwin" ;;
        CYGWIN*)    os="windows" ;;
        MINGW*)     os="windows" ;;
        MSYS*)      os="windows" ;;
        *)          os="unknown" ;;
    esac
    
    case "$(uname -m)" in
        x86_64)     arch="amd64" ;;
        i386)       arch="386" ;;
        i686)       arch="386" ;;
        arm64)      arch="arm64" ;;
        aarch64)    arch="arm64" ;;
        armv7l)     arch="armv7" ;;
        *)          arch="unknown" ;;
    esac
    
    echo "${os}_${arch}"
}

# Verificar dependências
check_dependencies() {
    local missing_deps=()
    
    if ! command -v curl &> /dev/null; then
        missing_deps+=("curl")
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Dependências faltando: ${missing_deps[*]}"
        print_status "Por favor, instale as dependências:"
        echo "  - curl: https://curl.se/"
        return 1
    fi
    
    return 0
}

# Baixar a versão mais recente
get_latest_version() {
    local version
    
    # Tentar obter releases públicos
    version=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    
    if [ -z "$version" ] || [ "$version" = "null" ]; then
        print_error "Nenhum release público encontrado"
        print_status "Para usar este instalador, você precisa:"
        echo "  1. Criar releases públicos no repositório $REPO"
        echo "  2. Ou usar o instalador alternativo que compila do código fonte"
        return 1
    fi

    echo "$version"
}

# Baixar e instalar o binário
install_prismium() {
    local platform="$1"
    local version="$2"
    
    print_status "Detectado: $platform"
    print_status "Baixando Prismium $version..."
    
    # Tentar diferentes formatos de nome de arquivo
    local possible_names=(
        "prismium_${version}_${platform}.tar.gz"
        "prismium_${version}_${platform}.zip"
        "prismium_${platform}.tar.gz"
        "prismium_${platform}.zip"
        "prismium-${version}-${platform}.tar.gz"
        "prismium-${version}-${platform}.zip"
    )
    
    local download_url=""
    local filename=""
    
    # Tentar cada formato
    for name in "${possible_names[@]}"; do
        local url="https://github.com/${REPO}/releases/download/${version}/${name}"
        if curl -s --head "$url" | head -n 1 | grep -q "200 OK"; then
            download_url="$url"
            filename="$name"
            break
        fi
    done
    
    if [ -z "$download_url" ]; then
        print_error "Não foi possível encontrar um binário compatível para $platform"
        print_status "Formatos tentados:"
        for name in "${possible_names[@]}"; do
            echo "  - $name"
        done
        return 1
    fi
    
    print_success "Encontrado: $filename"
    
    # Baixar
    if ! curl -L -o "/tmp/$filename" "$download_url"; then
        print_error "Falha ao baixar o binário"
        return 1
    fi
    
    print_success "Binário baixado com sucesso!"
    
    # Extrair
    print_status "Extraindo binário..."
    cd "/tmp"
    
    if [[ "$filename" == *.tar.gz ]]; then
        tar -xzf "$filename"
    elif [[ "$filename" == *.zip ]]; then
        unzip -q "$filename"
    fi
    
    # Criar diretório de instalação
    mkdir -p "$INSTALL_DIR"
    
    # Encontrar e instalar binário
    local binary_found=false
    for binary in prismium prismium.exe; do
        if [ -f "$binary" ]; then
            cp "$binary" "$INSTALL_DIR/$BINARY_NAME"
            chmod +x "$INSTALL_DIR/$BINARY_NAME"
            print_success "Prismium instalado em $INSTALL_DIR/$BINARY_NAME"
            binary_found=true
            break
        fi
    done
    
    if [ "$binary_found" = false ]; then
        print_error "Binário não encontrado após extração"
        return 1
    fi
    
    # Limpar arquivos temporários
    rm -f "/tmp/$filename" "/tmp/prismium" "/tmp/prismium.exe"
}

# Configurar PATH
setup_path() {
    local shell_config=""
    
    # Detectar shell
    case "$SHELL" in
        */zsh)  shell_config="$HOME/.zshrc" ;;
        */bash) shell_config="$HOME/.bashrc" ;;
        */fish) shell_config="$HOME/.config/fish/config.fish" ;;
        *)      shell_config="$HOME/.profile" ;;
    esac
    
    # Adicionar ao PATH se não estiver
    if ! grep -q "$INSTALL_DIR" "$shell_config" 2>/dev/null; then
        print_status "Adicionando $INSTALL_DIR ao PATH em $shell_config"
        
        if [[ "$shell_config" == *"fish"* ]]; then
            echo "set -gx PATH $INSTALL_DIR \$PATH" >> "$shell_config"
        else
            echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$shell_config"
        fi
        
        print_success "PATH configurado! Execute 'source $shell_config' ou abra um novo terminal"
    else
        print_success "PATH já está configurado"
    fi
}

# Função principal
main() {
    echo "🚀 Instalador do Prismium via Releases Públicos"
    echo "================================================"
    echo ""
    
    # Verificar dependências
    if ! check_dependencies; then
        exit 1
    fi
    
    # Detectar plataforma
    local platform
    platform=$(detect_os)
    
    if [ "$platform" = "unknown_unknown" ]; then
        print_error "Sistema operacional não suportado"
        exit 1
    fi
    
    # Obter versão mais recente
    print_status "Verificando versão mais recente..."
    local version
    version=$(get_latest_version)
    
    if [ -z "$version" ]; then
        exit 1
    fi
    
    print_success "Versão mais recente: $version"
    
    # Instalar
    if install_prismium "$platform" "$version"; then
        setup_path
        
        echo ""
        print_success "🎉 Prismium instalado com sucesso!"
        echo ""
        print_status "Para usar o Prismium:"
        echo "  1. Execute: source ~/.zshrc (ou ~/.bashrc)"
        echo "  2. Ou abra um novo terminal"
        echo "  3. Execute: prismium"
        echo ""
        print_status "Para configurar API keys:"
        echo "  prismium --help"
        echo ""
        print_status "Documentação: https://github.com/$REPO"
    else
        print_error "Falha na instalação"
        exit 1
    fi
}

# Executar se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
