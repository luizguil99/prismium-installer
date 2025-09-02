# 🚀 Prismium Installer

Instalador universal para o Prismium - um assistente de IA baseado em terminal para desenvolvimento de software.

## ⚡ Instalação Rápida

### Linux/macOS

```bash
curl -sSL https://raw.githubusercontent.com/luizguil99/prismium-installer/main/install.sh | bash
```

### Windows

```powershell
irm https://raw.githubusercontent.com/luizguil99/prismium-installer/main/install.ps1 | iex
```

### Go Install (Qualquer plataforma)

```bash
go install github.com/luizguil99/prismium@latest
```

## 📋 Pré-requisitos

- **Linux/macOS**: curl, tar
- **Windows**: PowerShell 5.1+
- **Go Install**: Go 1.25+

## 🔧 O que o Instalador Faz

1. **Detecta automaticamente** seu sistema operacional e arquitetura
2. **Baixa o binário correto** dos releases do GitHub
3. **Instala no local apropriado**:
   - Linux/macOS: `~/.local/bin/`
   - Windows: `%USERPROFILE%\.local\bin\`
4. **Configura o PATH** automaticamente
5. **Verifica integridade** dos downloads

## 🎯 Uso

Após a instalação:

```bash
# Iniciar o Prismium
prismium

# Ver ajuda
prismium --help

# Ver versão
prismium --version
```

## 🔑 Configuração de API Keys

O Prismium precisa de chaves de API para funcionar. Configure as variáveis de ambiente:

```bash
# Tavily API (para busca na web)
export TAVILY_API_KEY="sua_chave_tavily"

# OpenAI API
export OPENAI_API_KEY="sua_chave_openai"

# Anthropic API
export ANTHROPIC_API_KEY="sua_chave_anthropic"
```

## 🛠️ Desinstalação

### Linux/macOS

```bash
# Remover binário
rm ~/.local/bin/prismium

# Remover do PATH (editar ~/.zshrc ou ~/.bashrc)
# Remover a linha: export PATH="$HOME/.local/bin:$PATH"
```

### Windows

```powershell
# Remover binário
Remove-Item "$env:USERPROFILE\.local\bin\prismium.exe"

# Remover do PATH (via Painel de Controle ou PowerShell)
```

## 🔄 Atualizações

Para atualizar para a versão mais recente:

```bash
# Reinstalar
curl -sSL https://raw.githubusercontent.com/luizguil99/prismium-installer/main/install.sh | bash
```

## 📚 Documentação

- [Guia Completo de Instalação](https://github.com/luizguil99/prismium/blob/main/INSTALACAO.md)
- [Documentação do Prismium](https://github.com/luizguil99/prismium/blob/main/README-PRISMIUM.md)
- [Guia de Distribuição](https://github.com/luizguil99/prismium/blob/main/DISTRIBUICAO.md)

## 🆘 Suporte

- **Issues**: [GitHub Issues](https://github.com/luizguil99/prismium/issues)
- **Documentação**: [Wiki](https://github.com/luizguil99/prismium/wiki)
- **Discord**: [Servidor do Charm](https://charm.land/discord)

## 📄 Licença

Este instalador é distribuído sob a licença MIT. O Prismium é distribuído sob a licença FSL-1.1-MIT.

---

**Prismium** - Seu assistente de código favorito! 🚀
