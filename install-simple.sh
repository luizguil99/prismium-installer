#!/bin/bash

# 🚀 Instalador Simples do Prismium
# Este script baixa e instala o Prismium do repositório privado

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

# Verificar dependências
check_dependencies() {
    local missing_deps=()
    
    if ! command -v curl &> /dev/null; then
        missing_deps+=("curl")
    fi
    
    if ! command -v unzip &> /dev/null; then
        missing_deps+=("unzip")
    fi
    
    if ! command -v go &> /dev/null; then
        missing_deps+=("go")
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Dependências faltando: ${missing_deps[*]}"
        print_status "Por favor, instale as dependências:"
        echo "  - curl: https://curl.se/"
        echo "  - unzip: sudo apt install unzip (Linux) ou brew install unzip (macOS)"
        echo "  - go: https://golang.org/dl/"
        return 1
    fi
    
    return 0
}

# Baixar e compilar o Prismium
install_prismium() {
    print_status "Baixando código fonte do repositório privado..."
    
    # Criar diretório temporário
    local temp_dir="/tmp/prismium-build"
    rm -rf "$temp_dir"
    mkdir -p "$temp_dir"
    
    # Baixar código fonte usando GitHub API
    local download_url="https://api.github.com/repos/${REPO}/zipball/main"
    
    if ! curl -L -o "/tmp/prismium-source.zip" "$download_url"; then
        print_error "Falha ao baixar o código fonte"
        print_status "Verifique se o repositório existe e é acessível"
        return 1
    fi
    
    print_success "Código fonte baixado!"
    
    # Extrair código fonte
    print_status "Extraindo código fonte..."
    cd "$temp_dir"
    unzip -q "/tmp/prismium-source.zip"
    
    # Encontrar o diretório extraído
    local source_dir=$(ls -d */ | head -1)
    cd "$source_dir"
    
    # Verificar se é um projeto Go
    if [ -f "go.mod" ]; then
        print_status "Projeto Go detectado, compilando..."
        
        # Compilar
        print_status "Compilando Prismium..."
        if go build -o prismium .; then
            print_success "Compilação concluída!"
        else
            print_error "Falha na compilação"
            return 1
        fi
    else
        print_error "Tipo de projeto não suportado. Esperado: projeto Go"
        return 1
    fi
    
    # Criar diretório de instalação
    mkdir -p "$INSTALL_DIR"
    
    # Instalar binário
    if [ -f "prismium" ]; then
        cp "prismium" "$INSTALL_DIR/$BINARY_NAME"
        chmod +x "$INSTALL_DIR/$BINARY_NAME"
        print_success "Prismium instalado em $INSTALL_DIR/$BINARY_NAME"
    else
        print_error "Binário não encontrado após compilação"
        return 1
    fi
    
    # Limpar arquivos temporários
    rm -rf "$temp_dir" "/tmp/prismium-source.zip"
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
    echo "🚀 Instalador Simples do Prismium"
    echo "=================================="
    echo ""
    
    # Verificar dependências
    if ! check_dependencies; then
        exit 1
    fi
    
    # Instalar
    if install_prismium; then
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
