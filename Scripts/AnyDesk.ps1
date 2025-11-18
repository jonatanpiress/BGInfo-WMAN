$anydeskPaths = @("C:\ProgramData\AnyDesk\service.conf", "C:\ProgramData\AnyDesk\system.conf")
$outputFileAnyDesk = "C:\BGInfo\Scripts\AnyDeskID.txt"
$logFile = "C:\BGInfo\Scripts\ErrorLog.txt"

# Padrões para extrair o ID do AnyDesk
$idPatterns = @('ad.telemetry.last_cid=(\d+)', 'ad.anynet.id=(\d+)')

$anydeskID = "Não está instalado"

# Função para registrar erros no log
function Write-ErrorToLog {
    param ($message)
    $logDir = Split-Path -Path $logFile
    if (!(Test-Path $logDir)) {
        New-Item -ItemType Directory -Path $logDir -Force | Out-Null
    }
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    "$timestamp - $message" | Out-File -Append -FilePath $logFile
}

# Verifica se o serviço AnyDesk está em execução
$anydeskRunning = Get-Process -Name "AnyDesk" -ErrorAction SilentlyContinue

# Função para buscar o ID nos arquivos de configuração
function Get-AnyDeskID {
    foreach ($path in $anydeskPaths) {
        if ((Test-Path $path) -and ((Get-Item $path).Length -gt 0)) {
            try {
                $content = Get-Content $path -Raw
                foreach ($pattern in $idPatterns) {
                    if ($content -match $pattern) {
                        return $matches[1]  # Retorna o primeiro ID encontrado
                    }
                }
            } catch {
                Write-ErrorToLog "Erro ao ler o arquivo $path. Linha: $($_.InvocationInfo.ScriptLineNumber). Mensagem: $($_.Exception.Message)"
            }
        }
    }
    return $null  # Retorna $null caso não encontre o ID em nenhum dos arquivos
}

# Obtém o ID do AnyDesk se o serviço estiver rodando
if ($anydeskRunning) {
    $foundID = Get-AnyDeskID
    if ($foundID) {
        # Formatação do ID
        if ($foundID -match '^\d{9}$') {
            $anydeskID = $foundID -replace '(\d{3})(\d{3})(\d{3})', '$1 $2 $3'
        } elseif ($foundID -match '^\d{10}$') {
            $anydeskID = $foundID -replace '(\d{1})(\d{3})(\d{3})(\d{3})', '$1 $2 $3 $4'
        } else {
            $anydeskID = $foundID
        }
    }
}

# Salva o ID ou "Não está instalado"
try {
    $anydeskID | Out-File -FilePath $outputFileAnyDesk -Encoding UTF8 -NoNewline
} catch {
    Write-ErrorToLog "Erro ao salvar o ID do AnyDesk no arquivo $outputFileAnyDesk. Linha: $($_.InvocationInfo.ScriptLineNumber). Mensagem: $($_.Exception.Message)"
}

Write-Host "ID do AnyDesk formatado: $anydeskID"
