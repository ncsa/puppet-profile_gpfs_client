# @summary Configure GPFS client
#
# @param manager_hostlist
#   List of GPFS manager hosts
# 
# @example
#   include profile_gpfs_client
class profile_gpfs_client (
  Array[ String, 1 ]   $manager_hostlist,
) {

  include ::gpfs

  # Allow SSH from gpfs_master
  $gpfs_master = lookup( 'gpfs::add_client::master_server' )
  $params = {
    'PubkeyAuthentication'  => 'yes',
    'PermitRootLogin'       => 'without-password',
    'AuthenticationMethods' => 'publickey',
    'Banner'                => 'none',
  }

  $clean_hostlist = unique( [ $gpfs_master ] + $manager_hostlist )

  ::sshd::allow_from{ 'profile::gpfs_client':
    hostlist                => $clean_hostlist,
    users                   => [root],
    additional_match_params => $params,
  }

  # DISABLE SETUID ON GPFS BINARIES
  exec { 'remove_setuid_on_gpfs_binaries':
    path    => ['/bin', '/usr/bin', '/usr/sbin'],
    onlyif  => 'test `find /usr/lpp/mmfs/bin/ -perm /4000 | wc -l` -gt 0',
    command => 'find /usr/lpp/mmfs/bin/ -perm /4000 -exec chmod u-s "{}" \;',
  }

}
