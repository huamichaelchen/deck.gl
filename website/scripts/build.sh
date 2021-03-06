node scripts/validate-token.js

# staging or prod
MODE=$1
WEBSITE_DIR=`pwd`

# clean up cache
rm -rf ./.cache ./public

case $MODE in
  "prod")
    gatsby build
    ;;
  "staging")
    gatsby build --prefix-paths
    ;;
esac

# transpile workers
BABEL_ENV=es5 babel --config-file ../babel.config.js ./static/workers --out-dir public/workers

# build script
webpack -p --env.prod

# build gallery (scripting) examples
(
  cd ../examples/gallery
  yarn
  yarn build
)
mkdir public/gallery
cp -r ../examples/gallery/dist/* public/gallery/

# build playground (json) examples
(
  cd ../examples/playground
  yarn
  yarn build
)
mkdir public/playground
cp -r ../examples/playground/dist/* public/playground/
