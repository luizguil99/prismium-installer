# Configuração do Workflow de Sincronização

Este repositório contém um workflow do GitHub Actions que sincroniza automaticamente os releases do repositório privado `luizguil99/terminal-cli` para este repositório público `luizguil99/prismium-installer`.

## Configuração Necessária

Para que o workflow funcione corretamente, você precisa configurar os seguintes secrets no repositório público:

### 1. SOURCE_REPO (Opcional)
- **Nome**: `SOURCE_REPO`
- **Valor**: `luizguil99/terminal-cli`
- **Descrição**: Nome do repositório privado que contém o código principal

### 2. PRIVATE_REPO_TOKEN (Obrigatório)
- **Nome**: `PRIVATE_REPO_TOKEN`
- **Valor**: Token de acesso pessoal do GitHub
- **Descrição**: Token com acesso ao repositório privado `luizguil99/terminal-cli`

## Como Criar o Token

1. Acesse [GitHub Settings > Developer settings > Personal access tokens](https://github.com/settings/tokens)
2. Clique em "Generate new token (classic)"
3. Configure as seguintes permissões:
   - `repo` (acesso completo aos repositórios)
   - `read:org` (se o repositório estiver em uma organização)
4. Copie o token gerado
5. No repositório público, vá em Settings > Secrets and variables > Actions
6. Clique em "New repository secret"
7. Adicione o secret `PRIVATE_REPO_TOKEN` com o valor do token

## Como Configurar os Secrets

1. Acesse o repositório público: https://github.com/luizguil99/prismium-installer
2. Vá em **Settings** > **Secrets and variables** > **Actions**
3. Clique em **New repository secret**
4. Adicione os secrets conforme descrito acima

## Como o Workflow Funciona

1. **Execução Automática**: O workflow roda a cada 6 horas
2. **Execução Manual**: Você pode executar manualmente em Actions > Sync Releases
3. **Verificação**: Compara o último release do repositório privado com o público
4. **Atualização**: Se houver diferença, atualiza os scripts e cria um novo release
5. **Sincronização**: Mantém ambos os repositórios com a mesma versão

## Arquivos Atualizados Automaticamente

- `install.sh` - Script de instalação para Linux/macOS
- `install.ps1` - Script de instalação para Windows
- `README.md` - Documentação com a versão atual

## Troubleshooting

### Erro: "Not Found" ao acessar repositório privado
- Verifique se o token `PRIVATE_REPO_TOKEN` tem acesso ao repositório privado
- Confirme se o repositório `luizguil99/terminal-cli` existe e é privado

### Workflow não executa
- Verifique se os secrets estão configurados corretamente
- Confirme se o workflow está habilitado em Actions

### Release não é criado
- Verifique se há releases no repositório privado
- Confirme se o token tem permissão para criar releases no repositório público