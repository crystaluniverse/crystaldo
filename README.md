# crystaldo

TODO: Write a description here



## to get started

a oneliner gets you going (will remove existing installed version & rebuild)

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/crystaluniverse/crystaldo/master/install.sh)" a pull reset
#next will only execute if not installed yet
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/crystaluniverse/crystaldo/master/install.sh)"
```

## libs used

- https://aca-labs.github.io/terminimal/
- https://github.com/at-grandpa/clim  : command line parser (looked at many, think this one best for now)
- https://github.com/DFabric/dppm
    - https://dfabric.github.io/dppm/Process.html


## Git trigger

### Add webhook

Go to repo settings page and add new webhook and set the url of the webhook to `<your server address>/github`

### Add deployment script to repos
add the `.neph.yml` file to the root directory of the repo
> Check the syntax [here](https://github.com/tbrand/neph#usage)

### Start git trigger server

```bash
ct gittrigger start
```
