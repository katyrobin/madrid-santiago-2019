# # run once
# git clone git@github.com:katyrobin/madrid-santiago-2019
# rm -Rv _book/
# mv madrid-santiago-2019 _book
# cd _book
# ls
# git checkout gh-pages
# ls
# cd ..

cd _book
git status
git add -A
git commit -am 'Update book'
git push
cd ..
