# BgInfo WMAN

Projeto baseado no **BGInfo da Sysinternals**, configurado para uso corporativo em ambientes de suporte técnico, service desk e gerenciamento de máquinas Windows.  
Este pacote exibe automaticamente no desktop informações essenciais do computador, incluindo:

- Nome da máquina
- Endereço IP
- MAC Address
- Usuário logado
- ID do AnyDesk (extraído automaticamente via script)
- Wallpaper WMAM

O projeto é otimizado para implantação via **GPO**, login script ou execução local.

---

## 🔧 Funcionalidades

### ✔ Extração automática do ID AnyDesk
O script `AnyDesk.ps1` lê os arquivos internos  
`service.conf` e `system.conf` do AnyDesk e extrai o ID real da máquina, mesmo em instalações corporativas.

O ID é salvo em:
```
C:\BGInfo\Scripts\AnyDeskID.txt
```

### ✔ Atualização automática do BGInfo
Os scripts executam:

- Aplicação do layout definido no `Bginfo.bgi`
- Atualização silenciosa (sem pop-ups)
- Execução no logon e na inicialização da máquina

### ✔ Sincronização automática do pacote via rede
O script `bginfo_startup.cmd` copia todos os arquivos da pasta GPO para:

```
C:\BGInfo
```

Garantindo padronização em todas as máquinas.

---

## 📁 Estrutura dos arquivos

### **Bginfo.bat**
Executa o BGInfo e atualiza o ID do AnyDesk antes da renderização do wallpaper.

### **Bginfo.bgi**
Arquivo de layout do BGInfo definindo as variáveis:
```
Computador: <Host Name>
Endereço IP: <IP Address>
MAC Address: <MAC Address>
Usuário: <User Name>
AnyDesk: <AnyDesk>
```

### **AnyDesk.ps1**
Script PowerShell responsável por:

- Detectar se o AnyDesk está rodando
- Ler arquivos `.conf`
- Extrair e formatar o ID
- Registrar erros
- Atualizar o arquivo `AnyDeskID.txt`

### **bginfo_logon.cmd**
Executado no logon do usuário.  
Atualiza BGInfo e executa o script do AnyDesk.

### **bginfo_startup.cmd**
Executado no startup da máquina.  
Faz o deploy completo de `\\SEU-SERVIDOR\gpo\BGInfo` → `C:\BGInfo`.

---

## 🛠 Implantação

### **1) Copie a pasta BgInfo para seu servidor de GPO**
Exemplo:
```
\\SEU-SERVIDOR\gpo\BGInfo
```

### **2) Configure GPO para rodar no Logon**
User Configuration → Windows Settings → Scripts (Logon)  
Adicionar:
```
\\SEU-SERVIDOR\gpo\BGInfo\Scripts\bginfo_logon.cmd
```

### **3) Configure GPO para rodar no Startup**
Computer Configuration → Windows Settings → Scripts (Startup)  
Adicionar:
```
\\SEU-SERVIDOR\gpo\BGInfo\Scripts\bginfo_startup.cmd
```

---

## 📌 Requisitos

- Windows 10/11 ou Windows Server
- Permissões para execução de PowerShell (Bypass incluído no script)
- AnyDesk instalado (opcional)

---

## 📄 Licença

O executável **Bginfo.exe** e o arquivo **Eula.txt** pertencem à Microsoft Sysinternals.  
Este repositório contém apenas automações e configurações adicionais para uso corporativo.

---

## 🤝 Contribuição

Pull Requests são bem-vindos.  
Sugestões de melhoria podem ser enviadas via Issues.

---

## 🏷 Versão

**v1.0.0 — Release inicial**
- Estrutura completa do pacote
- Automação de leitura do ID AnyDesk
- Scripts de Logon e Startup
- Template do BGInfo integrado
- Wallpaper padrão
