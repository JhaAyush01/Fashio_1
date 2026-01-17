# Script to push code to the new Fashio_1 repository
# Make sure you've created the repo on GitHub first at https://github.com/new

Write-Host "Setting up remote for Fashio_1 repository..." -ForegroundColor Cyan

# Remove old remote if it exists
git remote remove origin 2>$null

# Add new remote
git remote add origin https://github.com/JhaAyush01/Fashio_1.git

Write-Host "✅ Remote added!" -ForegroundColor Green
Write-Host "`nPushing code to GitHub..." -ForegroundColor Yellow

# Push to the new repository
git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ Successfully pushed to https://github.com/JhaAyush01/Fashio_1.git" -ForegroundColor Green
    Write-Host "`nNext steps:" -ForegroundColor Cyan
    Write-Host "1. Go to https://vercel.com/new" -ForegroundColor White
    Write-Host "2. Import the 'Fashio_1' repository" -ForegroundColor White
    Write-Host "3. Click Deploy!" -ForegroundColor White
} else {
    Write-Host "`n❌ Error pushing to GitHub. Make sure the repository exists at:" -ForegroundColor Red
    Write-Host "   https://github.com/JhaAyush01/Fashio_1" -ForegroundColor Yellow
}
