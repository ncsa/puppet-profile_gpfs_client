# profile_gpfs_client

![pdk-validate](https://github.com/ncsa/puppet-profile_gpfs_client/workflows/pdk-validate/badge.svg)
![yamllint](https://github.com/ncsa/puppet-profile_gpfs_client/workflows/yamllint/badge.svg)

NCSA Common Puppet Profiles - configure GPFS client and mounts

## Usage

To install and configure:

```puppet
include profile_gpfs_client
```

## Configuration

The following parameters need to be set (hiera example):
```yaml
profile_gpfs_client::manager_hostlist:
  - "10.0.0.1"  # IP OF 1ST GPFS MANAGER HOST
  - "10.0.0.2"  # IP OF 2ND GPFS MANAGER HOST
  - "10.0.0.3"  # IP OF 3RD GPFS MANAGER HOST
```

Additional parameters need to be set for the GPFS module:
```yaml
gpfs::add_client::master_server: "10.0.0.1"
gpfs::add_client::ssh_private_key_contents: |
  -----BEGIN RSA PRIVATE KEY-----
  MIIEowIBAAK....WzklecO
  -----END RSA PRIVATE KEY-----
gpfs::add_client::ssh_public_key_contents: AAAAB3N...guPkx

gpfs::cron::accept_license: False

gpfs::firewall::allow_from:
  - "10.0.0.0/24"  # SUBNETS OF ALL GPFS SERVERS IN THE CLUSTER
  - "10.0.1.0/24"  # SUBNETS OF ALL GPFS CLIENTS IN THE CLUSTER

gpfs::install::yumrepo_baseurl: "https://xcat.server/gpfs/5.1.2.1/$releasever/$basearch"

gpfs::quota::host: "10.0.0.3"
gpfs::quota::port: 9910

gpfs::nativemounts::mountmap:
  user:
    opts: "nosuid"
    mountpoint: /gpfs/user
gpfs::bindmounts::mountmap:
  /home:
    opts: "nosuid"
    src_path:  /gpfs/user/home
    src_mountpoint: /gpfs/user
```

## Dependencies

- https://github.com/ncsa/puppet-spectrumscale


## Reference

[REFERENCE.md](REFERENCE.md)
