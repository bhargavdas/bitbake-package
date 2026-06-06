# bitbake-setup Debian package

[![Build](https://github.com/bhargavdas/bitbake-package/actions/workflows/build.yaml/badge.svg)](https://github.com/bhargavdas/bitbake-package/actions/workflows/build.yaml)

A Debian package for the BitBake `bitbake-setup` helper, targeted at Yocto
Project and OpenEmbedded users. This repository provides packaging metadata,
build scripts and a wrapper that installs upstream BitBake into
`/usr/share/bitbake` and exposes the `bitbake-setup` CLI for initializing
build environments.

## Why this exists

Some users only need the `bitbake-setup` utility and do not want to manually
clone the full upstream BitBake repository before installing a helper. To set
up a BitBake build, users can directly install the tool and initialize a build
environment using configuration files, instead of first cloning BitBake and
then using `bitbake-setup`.

This package makes it possible to install `bitbake-setup` directly as a Debian
package, while still pulling the upstream BitBake sources on build.

## Prerequisites

Install the build tools on Ubuntu/Debian hosts before building:

```
sudo apt update
sudo apt install -y devscripts debhelper build-essential xz-utils python3 git
```

See `debian/control` for runtime dependency details.

## Build
1. Clone this repo:

```
git clone https://github.com/bhargavdas/bitbake-package.git
cd bitbake-package
```

2. Clone upstream BitBake (recommended, but you can rely on the
	automation in `scripts/bump-bitbake-version.sh` to keep versions in sync):

```
git clone https://github.com/openembedded/bitbake.git
```

3. Create an upstream tarball and build the package. The package version is
	derived from `debian/changelog`; use these commands to create the tarball
	and build:

```
VERSION=$(dpkg-parsechangelog -S Version | sed 's/-.*//')
PACKAGE=$(dpkg-parsechangelog -S Source)
tar --exclude=.git -cJf ../${PACKAGE}_${VERSION}.orig.tar.xz .
debuild -us -uc
```

Note: you can use `scripts/bump-bitbake-version.sh` to detect upstream
versions.

## Install
Install the locally built package (replace `<version>` accordingly):

```
sudo apt install ./bitbake-setup_<version>_amd64.deb
```

Or:

```
sudo dpkg -i bitbake-setup_<version>_amd64.deb
sudo apt-get -f install
```

## Usage

```
bitbake-setup init <Plain Text View link>

eg:

bitbake-setup init https://raw.githubusercontent.com/openembedded/bitbake/master/default-registry/configurations/oe-nodistro-master.conf.json
```

## License

Packaging layout and scripts are covered by the license referenced in
`debian/copyright`.
