# Активация Hyper-V
```posh
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
```
# Проверка службы
```posh
Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V
```

# Активировать вложенную виртуализацию
```posh
Set-VMProcessor -VMName "имя_VM_с_учётом_регистра" -ExposeVirtualizationExtensions $true
```

# Проверить наличие вложенной виртуализации
```posh
Get-VMProcessor -VMName "имя_VM_с_учётом_регистра" | Select-Object ExposeVirtualizationExtensions
```

