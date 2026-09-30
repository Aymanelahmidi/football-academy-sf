Set-Location "C:\Users\ayman\Documents\football-academy-sf"
$result = sf apex run test --test-level RunLocalTests --code-coverage --result-format human --synchronous 2>&1
$result | Out-File "test_run_output.txt" -Encoding UTF8
# Show only summary lines
$result | Where-Object { $_ -match "Fail|Error|Pass|Total|Coverage|Org Wide|Overall" }
