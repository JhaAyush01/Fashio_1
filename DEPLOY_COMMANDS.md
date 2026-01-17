# Commands to Deploy to New GitHub Repo "Fashio-1"

## Step 1: Create Repository on GitHub
Go to https://github.com/new and create a new repository named "Fashio-1"

## Step 2: Update Remote and Push

```bash
# Remove the old remote
git remote remove origin

# Add the new remote (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/Fashio-1.git

# Push to the new repository
git push -u origin main
```

## Step 3: Deploy to Vercel

1. Go to https://vercel.com/new
2. Import your GitHub repository "Fashio-1"
3. Vercel will automatically detect:
   - FastAPI (from api/search.py)
   - Static files (from public/)
4. Click "Deploy"
5. Your app will be live at: https://your-project.vercel.app/

## After Deployment

- Frontend: https://your-project.vercel.app/
- API: https://your-project.vercel.app/api/search?query=your+query&k=5
