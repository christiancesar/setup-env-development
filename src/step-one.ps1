try {
  <# 
    BundleStandardPackageToolNode
    Script de instalação para configurar o ambiente padrão.
    Este script instala via winget e Install-Module os pacotes e configurações necessárias,
    registrando o andamento de cada etapa.
#>

# Início do script
# Write-Host "=== Iniciando a instalação do BundleStandardPackageToolNode ===" -ForegroundColor Cyan

# --- Instalação do Winget (caso não esteja instalado) ---
$progressPreference = 'SilentlyContinue'
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "Winget não encontrado. Instalando o módulo WinGet a partir da PSGallery..." -ForegroundColor Cyan
    Install-PackageProvider -Name NuGet -Force | Out-Null
    Install-Module -Name Microsoft.WinGet.Client -Force -Repository PSGallery | Out-Null
    Write-Host "Utilizando Repair-WinGetPackageManager para configurar o Winget..." -ForegroundColor Cyan
    Repair-WinGetPackageManager
    Write-Host "Winget instalado com sucesso." -ForegroundColor Green
} else {
    Write-Host "Winget já está instalado." -ForegroundColor Yellow
}


# --- 1. Configurar a política de execução ---
try {
  Write-Host "Configurando a política de execução para RemoteSigned (CurrentUser e LocalMachine)..." -ForegroundColor Yellow

  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
  Write-Host "Política de execução para CurrentUser alterada com sucesso." -ForegroundColor Green

  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine -Force
  Write-Host "Política de execução para LocalMachine alterada com sucesso." -ForegroundColor Green

} catch {
  Write-Host "Não foi possível alterar a política de execução: $($_.Exception.Message)" -ForegroundColor Red
  Write-Host "A política efetiva atual é: $(Get-ExecutionPolicy)" -ForegroundColor Magenta
  Write-Host "Continuando a execução do script..." -ForegroundColor Yellow
}

# 2. Instalar Microsoft PowerShell via winget
Write-Host "Instalando Microsoft PowerShell via winget..." -ForegroundColor Green
winget install --id=Microsoft.PowerShell --accept-package-agreements --accept-source-agreements -e

# 3. Instalar Windows Terminal via winget
Write-Host "Instalando Windows Terminal via winget..." -ForegroundColor Green
winget install --id=Microsoft.WindowsTerminal --accept-package-agreements --accept-source-agreements -e

# 4. Instalar Visual Studio Code via winget
Write-Host "Instalando Visual Studio Code via winget..." -ForegroundColor Green
winget install --id=Microsoft.VisualStudioCode --accept-package-agreements --accept-source-agreements -e

# 5. Instalar Git via winget
Write-Host "Instalando Git via winget..." -ForegroundColor Green
winget install --id=Git.Git --accept-package-agreements --accept-source-agreements -e

# 6. Instalar NodeJS via winget
Write-Host "Instalando NodeJS via winget..." -ForegroundColor Green

# 7. Instalar Oh My Posh via winget
Write-Host "Instalando Oh My Posh via winget..." -ForegroundColor Green
winget install --id=JanDeDobbeleer.OhMyPosh --source winget --accept-package-agreements --accept-source-agreements -e

# Instrução para reinício do terminal, se necessário
$current = Get-Location
wt -d "$current" pwsh -File "$current\step-two.ps1"

}
catch {
  <#Do this if a terminating exception happens#>
  Write-Host "Erro: $($_.Exception.Message)" -ForegroundColor Red
}
finally {
  <#Do this after the try block regardless of whether an exception occurred or not#>
  # 15. Finalização
  Write-Host "=== Primeira etapa concluída ===" -ForegroundColor Cyan
  Write-Host "Reinicie o Windows Terminal ou a sessão do PowerShell para que todas as configurações sejam aplicadas." -ForegroundColor Magenta
  Read-Host
}
