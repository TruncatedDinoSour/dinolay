# dinolay

## Depricated ebuilds overlay

https://github.com/TruncatedDinosour/deaddino

## Installation

### Manual

```bash
$ sudo mkdir -p /etc/portage/repos.conf
$ sudo curl -fl 'https://raw.githubusercontent.com/TruncatedDinosour/dinolay/main/dinolay.conf' -o /etc/portage/repos.conf/dinolay.conf
$ sudo emerge --sync dinolay
```

### Eselect repository

```bash
$ sudo eselect repository add 'dinolay' 'git' 'https://github.com/TruncatedDinosour/dinolay.git'
$ sudo eselect repository enable dinolay
$ sudo emerge --sync dinolay
```

### Layman

```bash
$ sudo layman -a dinolay
$ sudo layman -s dinolay
```
