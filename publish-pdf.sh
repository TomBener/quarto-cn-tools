# Publish PDF output to GitHub

# Render pdf
make pdf

# Check if the current branch is clean
if [[ -n $(git status --porcelain) ]]; then
    echo "Main branch is not clean. Please commit changes before proceeding."
    exit 1
fi

# Switch to gh-pages
git switch gh-pages

# Move new pdf to the current directory
mv outputs/index.pdf .

# Commit and push to gh-pages
git add index.pdf
git commit -m "Update pdf on $(date +'%Y-%m-%d')"
git push origin gh-pages

# Switch back to the original branch
git switch main

# Clean up
make clean
