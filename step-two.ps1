try {
  <# 
    BundleStandardPackageToolNode
    Script de instalação para configurar o ambiente padrão.
    Este script instala via winget e Install-Module os pacotes e configurações necessárias,
    registrando o andamento de cada etapa.
  #>

  # 9. Instalar a fonte JetBrainsMono para ligatures via Oh My Posh
  Write-Host "Instalando a fonte JetBrainsMono (ligatures)..." -ForegroundColor Green
  oh-my-posh font install JetBrainsMono

  # 10. Listar os temas disponíveis do Oh My Posh
  # Write-Host "Listando os temas disponíveis do Oh My Posh:" -ForegroundColor Cyan
  # Get-PoshThemes

  # 11. Instalar módulos do PowerShell via Install-Module

  # Terminal-Icons
  Write-Host "Instalando o módulo Terminal-Icons..." -ForegroundColor Green
  Install-Module -Name Terminal-Icons -Repository PSGallery -Force -Scope CurrentUser

  # Syntax-Highlighting
  Write-Host "Instalando o módulo syntax-highlighting..." -ForegroundColor Green
  Install-Module -Name syntax-highlighting -Force -Scope CurrentUser

  # PSReadLine
  Write-Host "Instalando o módulo PSReadLine..." -ForegroundColor Green
  Install-Module -Name PSReadLine -Force -Scope CurrentUser

  # Posh-Git
  Write-Host "Instalando o módulo posh-git..." -ForegroundColor Green
  Install-Module -Name posh-git -Force -Scope CurrentUser

  # 12. Obter o usuário atual
  Write-Host "Obtendo o usuário atual..." -ForegroundColor Yellow
  $GetUser = $env:USERNAME
  Write-Host "Usuário atual: $GetUser" -ForegroundColor Cyan

  # 13. Criar ou atualizar o arquivo de perfil do PowerShell ($PROFILE)
  Write-Host "Criando/Atualizando o arquivo de perfil do PowerShell: $PROFILE" -ForegroundColor Yellow
  if (-not (Test-Path -Path $PROFILE)) {
      New-Item -Path $PROFILE -ItemType File -Force
      Write-Host "Arquivo de perfil criado." -ForegroundColor Green
  } else {
      Write-Host "Arquivo de perfil já existe. Atualizando-o com as novas configurações." -ForegroundColor Green
  }

  # 14. Conteúdo a ser adicionado no perfil
$profileContent = @"
# Configurações adicionadas pelo BundleStandardPackageToolNode
oh-my-posh init pwsh --config "C:\Users\$GetUser\AppData\Local\Programs\oh-my-posh\themes\zash.omp.json" | Invoke-Expression
Import-Module PSReadLine
Import-Module syntax-highlighting
Import-Module posh-git
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
"@

  Add-Content -Path $PROFILE -Value $profileContent
  Write-Host "Configurações adicionadas ao arquivo de perfil." -ForegroundColor Green

}
catch {
  <#Do this if a terminating exception happens#>
  Write-Host "Erro: $($_.Exception.Message)" -ForegroundColor Red
}
finally {
  <#Do this after the try block regardless of whether an exception occurred or not#>
  # 15. Finalização
  Write-Host "=== Segunda etapa concluída ===" -ForegroundColor Cyan
  Write-Host "Reinicie o Windows Terminal ou a sessão do PowerShell para que todas as configurações sejam aplicadas." -ForegroundColor Magenta
  Read-Host
}
