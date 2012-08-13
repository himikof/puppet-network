# Custom resource network::interface
#
#  Manages a single network interface
#
# @author Nikita Ofitserov <himikof@gmail.com>
# @version 1.0
# @package network
#
define network::interface (
  $enable = true,
  $ensure = 'up',
  $configuration = 'dhcp',
) {
  
  # OS-specific part
  case $operatingsystem {
    gentoo:
    {

      baselayout::net_iface { $name:
      }
      
      baselayout::runlevel_service { "net.${name}":
        ensure => $enable ? {
          true  => 'present',
          false => 'absent',
        }
      }
      
      service { "net.${name}":
        ensure => $ensure ? {
          'up'   => 'running',
          'down' => 'stopped',
        },
      }
      
      case $configuration {
        'dhcp':
        {
          concat::fragment { 'confd_net':
            target => '/etc/conf.d/net',
            content => "config_$name=\"dhcp\"\n\n",
          }
        }
        'dhcp-nodns':
        {
          concat::fragment { 'confd_net':
            target => '/etc/conf.d/net',
            content => template('network/dhcp_nodns.erb'),
          }
        }
        default:
        {
          err("Unknown network interface configuration: ${configuration}")
        }
      }
      
    }
  }
  
}
