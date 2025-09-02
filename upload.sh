#!/bin/bash

# 🚀 Script para fazer upload do Prismium Installer
# Este script configura e faz upload para o repositório GitHub

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

echo "🚀 Upload do Prismium Installer"
echo "==============================="
echo ""

# Verificar se estamos no diretório correto
if [ ! -f "install.sh" ] || [ ! -f "install.ps1" ]; then
    print_error "Execute este script dentro da pasta prismium-installer"
    exit 1
fi

# Verificar se git está instalado
if ! command -v git &> /dev/null; then
    print_error "Git não está instalado"
    exit 1
fi

# Verificar se o repositório já foi inicializado
if [ ! -d ".git" ]; then
    print_status "Inicializando repositório Git..."
    git init
    git branch -M main
    print_success "Repositório Git inicializado"
else
    print_success "Repositório Git já existe"
fi

# Adicionar remote se não existir
if ! git remote get-url origin &> /dev/null; then
    print_status "Configurando remote origin..."
    git remote add origin https://github.com/luizguil99/prismium-installer.git
    print_success "Remote origin configurado"
else
    print_success "Remote origin já configurado"
fi

# Adicionar todos os arquivos
print_status "Adicionando arquivos..."
git add .

# Verificar se há mudanças para commit
if git diff --staged --quiet; then
    print_warning "Nenhuma mudança para commit"
else
    # Fazer commit
    print_status "Fazendo commit..."
    git commit -m "feat: initial prismium installer setup

- Scripts de instalação para Linux/macOS e Windows
- Workflows de sincronização automática
- Documentação completa
- Configuração para repositório luizguil99/crush"
    
    print_success "Commit realizado"
fi

# Fazer push
print_status "Fazendo push para GitHub..."
if git push -u origin main; then
    print_success "Push realizado com sucesso!"
else
    print_error "Falha no push. Verifique suas credenciais Git"
    exit 1
fi

echo ""
print_success "🎉 Upload concluído com sucesso!"
echo ""
print_status "Próximos passos:"
echo "1. Acesse: https://github.com/luizguil99/prismium-installer"
echo "2. Configure os secrets do repositório:"
echo "   - SOURCE_REPO=luizguil99/crush"
echo "   - GITHUB_TOKEN=seu_token_com_acesso_ao_repo_principal"
echo "3. Teste a instalação:"
echo "   curl -sSL https://raw.githubusercontent.com/luizguil99/prismium-installer/main/install.sh | bash"
echo ""
print_status "Documentação:"
echo "- README: https://github.com/luizguil99/prismium-installer/blob/main/README.md"
echo "- Setup: https://github.com/luizguil99/prismium-installer/blob/main/SETUP.md"
