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
      
      service { "net.${name}":
        ensure => $ensure ? {
          'up'   => 'running',
          'down' => 'stopped',
        },
        enable => $enable,
      }
      
      case $configuration {
        'dhcp':
        {
          concat::fragment { 'confd_net':
            target => '/etc/conf.d/net',
            content => "config_$name=\"dhcp\"\n",
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
