set +ex
crystal docs --output=./docs/tc
shards build
cp bin/tc /usr/local/bin
mkdir -p ~/Downloads/
cp bin/tc ~/Downloads/tc

