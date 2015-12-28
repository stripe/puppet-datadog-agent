class datadog_agent::integrations::network (
  $excluded_interfaces      = [],
  $excluded_interface_re    = undef,
  $collect_connection_state = false,
) {
  validate_array($excluded_interfaces)
  $collect_connection_state_bool = str2bool($collect_connection_state)

  $params = {
    excluded_interfaces      => $excluded_interfaces,
    collect_connection_state => $collect_connection_state_bool,
  }

  validate_string($excluded_interface_re)
  if ($excluded_interface_re) {
    $excluded_interface_re_fragment = {
      excluded_interface_re => $excluded_interface_re,
    }
  } else {
    $excluded_interface_re_fragment = {}
  }

  datadog_agent::integration { 'network': }
  datadog_agent::integration::instance {
    'network':
      integration => 'network',
      params => merge($params, $excluded_interface_re_fragment),
  }
}
