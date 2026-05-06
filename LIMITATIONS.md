# Limitations

## Package Availability

The cookbook installs the distribution-provided `rsync` package. It does not configure third-party
package repositories or build rsync from source.

### APT (Debian/Ubuntu)

* Debian 12: `rsync` 3.2.7 packages are available from Debian bookworm.
* Debian 13: `rsync` 3.4.1 packages are available from Debian trixie.
* Ubuntu 22.04: `rsync` packages are available from Ubuntu jammy.
* Ubuntu 24.04: `rsync` 3.2.7 packages are available from Ubuntu noble for amd64, arm64, armhf,
  ppc64el, riscv64, and s390x.

### DNF/YUM (RHEL Family)

* RHEL 8/9 and compatible distributions use the platform package repositories.
* AlmaLinux 8/9, Oracle Linux 8/9, Rocky Linux 8/9, CentOS Stream 9, Amazon Linux 2023, and Fedora
  provide `rsync` packages through their normal package managers.
* Fedora currently publishes `rsync` 3.4.1 packages for supported Fedora releases.

### Zypper (SUSE)

* openSUSE Leap is not supported by this cookbook baseline. Leap 15.6 reached EOL on April 30, 2026,
  and the openSUSE package portal does not list an official `rsync` package for Leap 16.0.

## Architecture Limitations

* Architecture availability is inherited from the operating system package repository.
* The Kitchen and CI baseline validate Linux containers on x86_64.

## Source/Compiled Installation

Source installation is not implemented. Use distribution packages or wrap this cookbook with a
separate source-build resource if you need custom rsync builds.

## Known Issues

* The daemon resources assume systemd-managed Linux hosts.
* Scientific Linux and CentOS Linux are not supported because those distributions are EOL.

## Research Sources

* Debian package search: <https://packages.debian.org/source/rsync>
* Ubuntu noble package: <https://packages.ubuntu.com/noble/rsync>
* Fedora package portal: <https://packages.fedoraproject.org/pkgs/rsync/rsync>
* Amazon Linux 2023 package list: <https://docs.aws.amazon.com/linux/al2023/release-notes/all-packages-AL2023.11.html>
* openSUSE package portal: <https://software.opensuse.org/package/rsync>
* Platform lifecycle data: <https://endoflife.date/>
