$sf = 'C:\Program Files\sf\bin\sf.cmd'
Write-Host "=== Running fix_names ===" -ForegroundColor Cyan
$result = & $sf apex run --file "scripts/data/fix_names.apex" --target-org 'FA DEMO' 2>&1
$debugs = $result | Select-String 'USER_DEBUG'
foreach ($d in $debugs) { Write-Host $d -ForegroundColor Green }
$errors = $result | Select-String 'FATAL_ERROR|DmlException|System.Exception'
if ($errors) {
    Write-Host "ERRORS:" -ForegroundColor Red
    foreach ($e in $errors) { Write-Host $e -ForegroundColor Red }
} else {
    Write-Host "SUCCESS" -ForegroundColor Green
}
