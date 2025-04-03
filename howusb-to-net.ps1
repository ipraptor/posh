###=========================================================
### Checking USB and write it to txt in localnet
### By IPraptor i@ipraptor.ru 03.04.2025/1
###=========================================================


# Укажите сетевой путь для сохранения (без имени файла)
$networkPath = "\\127.0.0.1\Users\SUPERUSER\test"

# Генерируем имя файла
$userName = $env:USERNAME -replace '[\\\/:*?"<>|]', '_'
$currentDate = Get-Date -Format "dd-MM-yyyy_HH-mm-ss"
$fileName = "${userName}_${currentDate}.txt"
$outputPath = Join-Path -Path $networkPath -ChildPath $fileName

# Создаем папку, если её нет
if (-not (Test-Path $networkPath)) {
    New-Item -ItemType Directory -Path $networkPath -Force
}

# Формируем отчет
$reportContent = @"
========Отчет о съёмных накопителях===========

Компьютер: $($env:COMPUTERNAME)
Пользователь: $($env:USERNAME)
Время запроса: $(Get-Date -Format "dd-MM-yyyy HH:mm:ss")


***

"@

# Добавляем информацию о каждом диске
$disks = Get-WmiObject Win32_DiskDrive
foreach ($disk in $disks) {
    $reportContent += @"
==============================================
Модель: $($disk.Model)
Серийный номер: $($disk.SerialNumber)
Размер: $([math]::Round($disk.Size / 1GB, 2)) GB
DeviceID: $($disk.DeviceID)
PNPDeviceID: $($disk.PNPDeviceID)
==============================================
***
"@
}

# Сохраняем в файл
$reportContent | Out-File -FilePath $outputPath -Encoding UTF8

Write-Host "Отчет сохранен в: $outputPath" -ForegroundColor Green
