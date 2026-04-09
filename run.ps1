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

# Google Gemini needs BOTH env var names (gitclaw checks GOOGLE_API_KEY, pi-ai reads GEMINI_API_KEY)
if ($env:GOOGLE_API_KEY -and -not $env:GEMINI_API_KEY) {
    [System.Environment]::SetEnvironmentVariable("GEMINI_API_KEY", $env:GOOGLE_API_KEY, "Process")
    Write-Host "Loaded: GEMINI_API_KEY (from GOOGLE_API_KEY)" -ForegroundColor DarkGray
}
if ($env:GEMINI_API_KEY -and -not $env:GOOGLE_API_KEY) {
    [System.Environment]::SetEnvironmentVariable("GOOGLE_API_KEY", $env:GEMINI_API_KEY, "Process")
    Write-Host "Loaded: GOOGLE_API_KEY (from GEMINI_API_KEY)" -ForegroundColor DarkGray
}

# Validate at least one key is set
if (-not $env:GROQ_API_KEY -and -not $env:ANTHROPIC_API_KEY -and -not $env:GOOGLE_API_KEY -and -not $env:OPENAI_API_KEY) {
    Write-Host "" -ForegroundColor Red
    Write-Host "ERROR: No API key found in .env" -ForegroundColor Red
    Write-Host "Get a FREE Google Gemini key at: https://aistudio.google.com/app/apikey" -ForegroundColor Yellow
    Write-Host "Then add to .env:  GOOGLE_API_KEY=your_key_here" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Starting devmind..." -ForegroundColor Cyan

if ($Message) {
    gitclaw --dir $PSScriptRoot $Message
} else {
    gitclaw --dir $PSScriptRoot
}
