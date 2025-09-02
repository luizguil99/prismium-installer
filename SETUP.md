# 🔧 Configuração do Repositório Prismium Installer

## 📋 Pré-requisitos

1. **Repositório principal** (privado): `seu-usuario/crush`
2. **Repositório de instalação** (público): `seu-usuario/prismium-installer`
3. **GitHub Personal Access Token** com permissões adequadas

## 🚀 Passos para Configurar

### 1. Criar Repositório Público

```bash
# No GitHub, criar novo repositório público
# Nome: prismium-installer
# Descrição: Universal installer for Prismium
# Público: ✅
# README: ❌ (já temos)
# .gitignore: ❌ (já temos)
# License: ❌ (já temos)
```

### 2. Configurar Secrets

No repositório `prismium-installer`, adicionar secrets:

```bash
# GitHub Settings > Secrets and variables > Actions
SOURCE_REPO=seu-usuario/crush  # Repositório principal (privado)
GITHUB_TOKEN=ghp_xxxxxxxxxxxx  # Token com acesso ao repo principal
```

### 3. Fazer Upload dos Arquivos

```bash
# Na pasta prismium-installer
cd prismium-installer
git init
git add .
git commit -m "feat: initial prismium installer setup"
git branch -M main
git remote add origin https://github.com/seu-usuario/prismium-installer.git
git push -u origin main
```

### 4. Configurar Workflow

O workflow `sync-releases.yml` vai:
- Verificar novos releases no repo principal a cada 6 horas
- Atualizar scripts automaticamente
- Criar releases do instalador

## 🔄 Como Funciona

### Fluxo de Trabalho:

1. **Desenvolvimento** (repo privado):
   ```bash
   # Fazer mudanças no código
   git add .
   git commit -m "feat: nova funcionalidade"
   git tag v1.1.0
   git push origin v1.1.0
   ```

2. **Release automático** (repo privado):
   - GitHub Actions cria release com binários
   - Binários ficam públicos

3. **Sincronização** (repo público):
   - Workflow detecta novo release
   - Atualiza scripts de instalação
   - Cria release do instalador

4. **Instalação** (usuários):
   ```bash
   curl -sSL https://raw.githubusercontent.com/seu-usuario/prismium-installer/main/install.sh | bash
   ```

## 🎯 Estrutura Final

```
seu-usuario/
├── crush/                    # Repositório PRIVADO
│   ├── .goreleaser.yml      # Configuração de releases
│   ├── .github/workflows/   # Workflows de build
│   └── ...                  # Código fonte
│
└── prismium-installer/       # Repositório PÚBLICO
    ├── install.sh           # Script Linux/macOS
    ├── install.ps1          # Script Windows
    ├── README.md            # Documentação
    ├── .github/workflows/   # Workflow de sincronização
    └── ...                  # Arquivos de instalação
```

## 🔐 Configuração de Segurança

### Personal Access Token

Criar token com permissões:
- `repo` (acesso a repositórios)
- `workflow` (executar workflows)
- `write:packages` (se usar packages)

### Secrets do Repositório

```bash
# No repositório prismium-installer
SOURCE_REPO=seu-usuario/crush
GITHUB_TOKEN=ghp_xxxxxxxxxxxx
```

## 📊 Monitoramento

### Verificar Status:

1. **Releases do repo principal**: https://github.com/seu-usuario/crush/releases
2. **Releases do instalador**: https://github.com/seu-usuario/prismium-installer/releases
3. **Workflows**: https://github.com/seu-usuario/prismium-installer/actions

### Logs de Sincronização:

- Workflow executa a cada 6 horas
- Verifica novos releases automaticamente
- Atualiza scripts quando necessário

## 🛠️ Manutenção

### Atualizar Scripts Manualmente:

```bash
# Editar scripts
nano install.sh
nano install.ps1

# Commit e push
git add .
git commit -m "fix: corrigir detecção de plataforma"
git push
```

### Forçar Sincronização:

```bash
# No GitHub, ir para Actions
# Executar workflow "Sync Releases" manualmente
# Ou aguardar execução automática (6 horas)
```

## 🎉 Resultado Final

Com essa configuração:

- ✅ **Código privado**: Desenvolvimento seguro
- ✅ **Instalação pública**: Um comando para instalar
- ✅ **Atualizações automáticas**: Scripts sempre atualizados
- ✅ **Distribuição simples**: Como Homebrew
- ✅ **Manutenção mínima**: Tudo automático

## 📞 Suporte

Se algo não funcionar:

1. Verificar secrets do repositório
2. Verificar permissões do token
3. Verificar logs dos workflows
4. Testar scripts localmente

---

**Prismium Installer** - Distribuição profissional! 🚀
