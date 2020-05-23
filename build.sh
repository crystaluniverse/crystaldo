set +ex
crystal docs --output=./docs/ct
shards build
cp bin/crystaldo /usr/local/bin/ct
mkdir -p ~/Downloads/
cp bin/crystaldo ~/Downloads/ct

