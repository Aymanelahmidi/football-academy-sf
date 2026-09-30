$sf = 'C:\Program Files\sf\bin\sf.cmd'
$scripts = @(
    'demo_02_players_jeunes',
    'demo_03_players_seniors',
    'demo_04_contracts_medical',
    'demo_05_guardians',
    'demo_06_competitions_sessions',
    'demo_07_matches_events',
    'demo_08_attendances_evaluations',
    'demo_09_injuries_gps_fitness',
    'demo_10_transactions'
)
foreach ($s in $scripts) {
    Write-Host "=== Running $s ===" -ForegroundColor Cyan
    $result = & $sf apex run --file "scripts/data/$s.apex" --target-org 'FA DEMO' 2>&1
    $debugs = $result | Select-String 'USER_DEBUG'
    foreach ($d in $debugs) { Write-Host $d -ForegroundColor Green }
    $hasException = $result | Select-String 'FATAL_ERROR|DmlException|System.Exception|ERROR'
    if ($hasException) {
        Write-Host "FAILED - $hasException" -ForegroundColor Red
    } else {
        Write-Host "SUCCESS" -ForegroundColor Green
    }
}
Write-Host "=== ALL DEMO SCRIPTS COMPLETE ===" -ForegroundColor Yellow
