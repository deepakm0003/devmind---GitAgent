# devmind launcher
param([string]$Message = "")

$envFile = Join-Path $PSScriptRoot ".env"
if (-not (Test-Path $envFile)) {
    Write-Host "ERROR: .env not found. Copy .env.example to .env and add your key." -ForegroundColor Red; exit 1
}

Get-Content $envFile | ForEach-Object {
    if ($_ -match '^\s*([^#][^=]+)=(.+)$') {
        $key = $matches[1].Trim(); $val = $matches[2].Trim()
        if ($val -notmatch '^your_') {
            [System.Environment]::SetEnvironmentVariable($key, $val, "Process")
            Write-Host "Loaded: $key" -ForegroundColor DarkGray
        }
    }
}

if (-not $env:OPENROUTER_API_KEY -and -not $env:GEMINI_API_KEY -and -not $env:ANTHROPIC_API_KEY -and -not $env:OPENAI_API_KEY -and -not $env:GROQ_API_KEY) {
    Write-Host ""
    Write-Host "ERROR: No API key found in .env" -ForegroundColor Red
    Write-Host "Add OPENROUTER_API_KEY to .env (free at https://openrouter.ai)" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Starting devmind..." -ForegroundColor Cyan
if ($Message) { gitclaw --dir $PSScriptRoot $Message }
else { gitclaw --dir $PSScriptRoot }