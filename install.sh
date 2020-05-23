#!/bin/bash
set -ex

if [[ "$OSTYPE" != "darwin"* ]] && [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo OS is not supported ..
    exist 1
fi

if ! [ -x "$(command -v crystal)" ]; then

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then

        apt-get install -y build-essential curl libevent-dev libssl-dev libxml2-dev libyaml-dev libgmp-dev wget

        if ! [ -x "$(command -v crystal)" ]; then
            curl -sSL https://dist.crystal-lang.org/apt/setup.sh |  bash ; \
            curl -sL "https://keybase.io/crystal/pgp_keys.asc" |  apt-key add - ; \
            echo "deb https://dist.crystal-lang.org/apt crystal main" > /etc/apt/sources.list.d/crystal.list  ; \
            apt-get update  ; \
            apt install crystal -y

        fi
        # # install nodejs
        # if ! [ -x "$(command -v node)" ]; then
        #   curl -sL https://deb.nodesource.com/setup_14.x | bash -  ; \
        #   sudo apt-get install nodejs -y

        # fi
    fi

    if [[ "$OSTYPE" == "darwin"* ]]; then

        if ! [ -x "$(command -v crystal)" ]; then

            if ! [ -x "$(command -v brew)" ]; then
            echo 'Error: brew is not installed, please do so' >&2
            exit 1
            fi

        brew install crystal
        brew install git
        # brew install node
    fi
        
fi


if ! [ -x "$(command -v git)" ]; then
echo 'Error: git is not installed, please install git' >&2
exit 1
fi

if ! [ -x "$(command -v crystal)" ]; then
echo 'Error: git is not installed, please install crystal' >&2
exit 1
fi

# if ! [ -x "$(command -v node)" ]; then
# echo 'Error: node is not installed, please install node' >&2
# exit 1
# fi

export DEST=~/code/github/crystaluniverse/
if [ -d "$DEST/crystaldo" ] ; then
    cd $DEST/crystaldo
    echo " - CRYSTALDO DIR ALREADY THERE, pullling it .."
    git pull
else
    mkdir -p $DEST
    cd $DEST
    git clone "git@github.com:crystaluniverse/crystaldo"
fi

if ! [ -x "$(command -v tc)" ]; then
    # rm -f /usr/local/bin/ct 2>&1 > /dev/null
    cd $DEST/crystaldo
    bash build.sh
fi


if ! [ -x "$(command -v tc)" ]; then
echo 'Error: crystal tools did not build' >&2
exit 1
fi

