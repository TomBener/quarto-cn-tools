# Publish outputs to GitHub

# Render Quarto projects
make

# Check if the current branch is clean
if [[ -n $(git status --porcelain) ]]; then
    echo "Main branch is not clean. Please commit changes before proceeding."
    exit 1
fi

# Switch to gh-pages
git switch gh-pages

# Move new outputs to the current directory
rsync -a outputs/ .

# Commit and push to gh-pages
git add CNAME index.docx index.html index.pdf slides.html *_files/ figures/
git commit -m "Update outputs on $(date +'%Y-%m-%d')"
git push origin gh-pages

# Switch back to the original branch
git switch main

# Clean up
make clean
