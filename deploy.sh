#!/usr/bin/env sh

# abort on errors
# set -e

# build
quasar build

# navigate into the build output directory
cd dist/spa

# if you are deploying to a custom domain
# echo 'www.example.com' > CNAME

git init
git add -A
git commit -m 'deploy'

# if you are deploying to https://<USERNAME>.github.io
# git push -f git@github.com:tadeaspaule/tadeaspaule.github.io.git master

# if you are deploying to https://<USERNAME>.github.io/<REPO>
git push -f git@github.com:tadeaspaule/gallery.git master:gh-pages

cd -