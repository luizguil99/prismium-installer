#!/bin/bash

# 🚀 Instalador Universal do Prismium
# Este script baixa e instala o Prismium em qualquer sistema operacional

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configurações
REPO="luizguil99/prismium"  # Repositório oficial do Prismium
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
        Linux*)     os="Linux" ;;
        Darwin*)    os="Darwin" ;;
        CYGWIN*)    os="Windows" ;;
        MINGW*)     os="Windows" ;;
        MSYS*)      os="Windows" ;;
        *)          os="Unknown" ;;
    esac
    
    case "$(uname -m)" in
        x86_64)     arch="x86_64" ;;
        i386)       arch="i386" ;;
        i686)       arch="i386" ;;
        arm64)      arch="arm64" ;;
        aarch64)    arch="arm64" ;;
        armv7l)     arch="armv7" ;;
        *)          arch="unknown" ;;
    esac
    
    echo "${os}_${arch}"
}

# Baixar a versão mais recente
get_latest_version() {
    local version
    version=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    echo "$version"
}

# Baixar e instalar o binário
install_prismium() {
    local platform="$1"
    local version="$2"
    
    print_status "Detectado: $platform"
    print_status "Baixando Prismium $version..."
    
    # URL do release
    local url="https://github.com/${REPO}/releases/download/${version}/prismium_${version}_${platform}.tar.gz"
    
    # Tentar baixar
    if ! curl -L -o "/tmp/prismium.tar.gz" "$url"; then
        print_error "Falha ao baixar o binário para $platform"
        print_status "Tentando com nome alternativo..."
        
        # Tentar com nome alternativo (sem versão)
        url="https://github.com/${REPO}/releases/download/${version}/prismium_${platform}.tar.gz"
        if ! curl -L -o "/tmp/prismium.tar.gz" "$url"; then
            print_error "Não foi possível baixar o binário"
            return 1
        fi
    fi
    
    print_success "Binário baixado com sucesso!"
    
    # Extrair
    print_status "Extraindo binário..."
    tar -xzf "/tmp/prismium.tar.gz" -C "/tmp/"
    
    # Criar diretório de instalação
    mkdir -p "$INSTALL_DIR"
    
    # Instalar binário
    if [ -f "/tmp/prismium" ]; then
        cp "/tmp/prismium" "$INSTALL_DIR/$BINARY_NAME"
        chmod +x "$INSTALL_DIR/$BINARY_NAME"
        print_success "Prismium instalado em $INSTALL_DIR/$BINARY_NAME"
    else
        print_error "Binário não encontrado após extração"
        return 1
    fi
    
    # Limpar arquivos temporários
    rm -f "/tmp/prismium.tar.gz" "/tmp/prismium"
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

# Verificar dependências
check_dependencies() {
    local missing_deps=()
    
    if ! command -v curl &> /dev/null; then
        missing_deps+=("curl")
    fi
    
    if ! command -v tar &> /dev/null; then
        missing_deps+=("tar")
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Dependências faltando: ${missing_deps[*]}"
        print_status "Por favor, instale as dependências e tente novamente"
        return 1
    fi
    
    return 0
}

# Função principal
main() {
    echo "🚀 Instalador Universal do Prismium"
    echo "===================================="
    echo ""
    
    # Verificar dependências
    if ! check_dependencies; then
        exit 1
    fi
    
    # Detectar plataforma
    local platform
    platform=$(detect_os)
    
    if [ "$platform" = "Unknown_unknown" ]; then
        print_error "Sistema operacional não suportado"
        exit 1
    fi
    
    # Obter versão mais recente
    print_status "Verificando versão mais recente..."
    local version
    version=$(get_latest_version)
    
    if [ -z "$version" ]; then
        print_error "Não foi possível obter a versão mais recente"
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
        echo "  1. Execute: source $shell_config"
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