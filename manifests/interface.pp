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
  $bridge_interfaces = false,
  # dns parameters
  $dns_servers = false,
  $dns_search_domains = false,
  $dns_domain = false,
  # bridge parameters
  $bridge_stp = true,
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
        },
        require  => Baselayout::Net_iface[$name],
      }
      
      service { "net.${name}":
        ensure => $ensure ? {
          'up'   => 'running',
          'down' => 'stopped',
        },
        require  => [
          Baselayout::Net_iface[$name],
          Concat['/etc/conf.d/net'],
        ],
      }
      
      if $bridge_interfaces {
          concat::fragment { "confd_net_${name}_${bridge}":
            target  => '/etc/conf.d/net',
            content => template('network/bridge.erb'),
          }
      }

      case $configuration {
        'dhcp':
        {
          concat::fragment { "confd_net_${name}":
            target  => '/etc/conf.d/net',
            content => "config_$name=\"dhcp\"\n\n",
          }
        }
        'dhcp-nodns':
        {
          concat::fragment { "confd_net_${name}":
            target  => '/etc/conf.d/net',
            content => template('network/dhcp_nodns.erb'),
          }
        }
        'static':
        {
          concat::fragment { "confd_net_${name}":
            target  => '/etc/conf.d/net',
            content => template('network/static.erb'),
          }
        }
        'null':
        {
          concat::fragment { "confd_net_${name}":
            target  => '/etc/conf.d/net',
            content => "config_$name=\"null\"\n\n",
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
