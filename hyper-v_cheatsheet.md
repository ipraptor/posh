# Активировать вложенную виртуализацию
```posh
Set-VMProcessor -VMName "имя_VM_с_учётом_регистра" -ExposeVirtualizationExtensions $true
```

# Проверить наличие вложенной виртуализации
```posh
Get-VMProcessor -VMName "имя_VM_с_учётом_регистра" | Select-Object ExposeVirtualizationExtensions
```
