# Overview

This puppet module manages the network configuration.

# Classes

## network

This class manages the overall network configuration.

# Resources

## network::interface

This resource manages a single network interface.

### Parameters

#### $ensure

What interface state to ensure. Valid values are `up`, `down`.

The default value is `up`.

#### $enable

Whether the interface should be started automatically on boot.

The default is true.

#### $configuration

The interface configuration type. Valid value is `dhcp`.

The default is `dhcp`.


# Licensing

This puppet module is licensed under the GPL version 3 or later. Redistribution
and modification is encouraged.

The GPL version 3 license text can be found in the "LICENSE" file accompanying
this puppet module, or at the following URL:

http://www.gnu.org/licenses/gpl-3.0.html
