# bitbake-setup debian package

The package is prepare to only the `bitbake-setup` tool.

## Build
1. Clone this repo
2. Clone bitbake inside this repo
```
cd bitbake-package; git clone https://github.com/openembedded/bitbake.git
```
3. Create .orig.tar.xz
```
tar --exclude=.git -cJf ../bitbake-setup_2.16.0.orig.tar.xz .
```
4. Build the deb package
```
debuild -us -uc
```

## Install
Install the package
```
sudo apt install ../bitbake-setup_2.16.0-1_amd64.deb
```

## Usage
```
bitbake-setup init <Plain Text View link>

eg:

bitbake-setup init https://raw.githubusercontent.com/openembedded/bitbake/master/default-registry/configurations/oe-nodistro-master.conf.json
```
