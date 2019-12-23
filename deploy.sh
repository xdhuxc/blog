#!/usr/bin/env bash
echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Commit changes.
msg="change the website's domain when it compiling"
if [[ "$#" -eq 1 ]]; then
    msg="$1"
fi

# Push Hugo content
git add -A
git commit -m "$msg"
git push origin master

# delete previous build
cd public
rm -r ./*
cd ..

echo -e "\033[0;32mBuild the blog.\033[0m"
hugo -t even  # if using a theme, replace with `hugo -t <YOURTHEME>`

# Go To Public folder
cd public
# Add changes to git.
git add .

git commit -m "$msg"

# Push source and build repos.
git push origin master

# Come Back up to the Project Root
cd ..
