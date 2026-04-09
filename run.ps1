# devmind launcher — loads .env and starts the agent
# Usage: .\run.ps1
#        .\run.ps1 "Let's start a new interview"

param(
    [string]$Message = ""
)

$envFile = Join-Path $PSScriptRoot ".env"

if (-not (Test-Path $envFile)) {
    Write-Host "ERROR: .env file not found. Copy .env.example to .env and add your API key." -ForegroundColor Red
    exit 1
}

# Load .env into current session
Get-Content $envFile | ForEach-Object {
    if ($_ -match '^\s*([^#][^=]+)=(.+)$') {
        $key = $matches[1].Trim()
        $value = $matches[2].Trim()
        [System.Environment]::SetEnvironmentVariable($key, $value, "Process")
        Write-Host "Loaded: $key" -ForegroundColor DarkGray
    }
}

# Validate at least one key is set
if (-not $env:GROQ_API_KEY -and -not $env:ANTHROPIC_API_KEY -and -not $env:GOOGLE_API_KEY -and -not $env:OPENAI_API_KEY) {
    Write-Host "ERROR: No API key found in .env — add GROQ_API_KEY (free at https://console.groq.com)" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Starting devmind..." -ForegroundColor Cyan

if ($Message) {
    gitclaw --dir $PSScriptRoot $Message
} else {
    gitclaw --dir $PSScriptRoot
}
