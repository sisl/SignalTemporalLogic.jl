@ECHO OFF
git checkout gh-pages
git merge main
git push
git checkout main
