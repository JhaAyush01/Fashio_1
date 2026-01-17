# Script to create GitHub repository using GitHub API
# You'll need a GitHub Personal Access Token

$repoName = "Fashio_1"
$username = "JhaAyush01"  # Your GitHub username
$isPrivate = $false  # Set to $true for private repo

# Prompt for GitHub token
$token = Read-Host "Enter your GitHub Personal Access Token (create one at https://github.com/settings/tokens if needed)"

if ([string]::IsNullOrWhiteSpace($token)) {
    Write-Host "Error: GitHub token is required!" -ForegroundColor Red
    Write-Host "Create a token at: https://github.com/settings/tokens" -ForegroundColor Yellow
    exit 1
}

$headers = @{
    "Authorization" = "token $token"
    "Accept" = "application/vnd.github.v3+json"
}

$body = @{
    name = $repoName
    description = "FASHIO - Fashion recommendation system using SentenceTransformer and FAISS"
    private = $isPrivate
    auto_init = $false
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "https://api.github.com/user/repos" -Method Post -Headers $headers -Body $body
    
    Write-Host "✅ Repository '$repoName' created successfully!" -ForegroundColor Green
    Write-Host "Repository URL: $($response.html_url)" -ForegroundColor Cyan
    
    # Now add remote and push
    Write-Host "`nSetting up git remote..." -ForegroundColor Yellow
    
    git remote remove origin 2>$null
    git remote add origin "https://github.com/$username/$repoName.git"
    
    Write-Host "✅ Remote added!" -ForegroundColor Green
    Write-Host "`nNow run: git push -u origin main" -ForegroundColor Cyan
    
} catch {
    Write-Host "Error creating repository: $_" -ForegroundColor Red
    if ($_.Exception.Response.StatusCode -eq 401) {
        Write-Host "Invalid token. Please check your GitHub Personal Access Token." -ForegroundColor Red
    } elseif ($_.Exception.Response.StatusCode -eq 422) {
        Write-Host "Repository might already exist or name is invalid." -ForegroundColor Red
    }
}
