import 'stdlib'

# Class network
#
#  Manages the network configuration
#
# @author Nikita Ofitserov <himikof@gmail.com>
# @version 1.0
# @package network
#
class network {
  # OS-specific part
  case $operatingsystem {
    gentoo:
    {
      package {['iproute2', 'dhcpcd']:
        ensure   => 'present',
      }
      
      concat { '/etc/conf.d/net':
        force   => true,
        require => Package['openrc'],
      }

    }
  }
}
