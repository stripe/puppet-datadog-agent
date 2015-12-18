class datadog_agent::integrations::network (
  $excluded_interfaces      = [],
  $excluded_interface_re    = undef,
  $collect_connection_state = false,
) {
  validate_array($excluded_interfaces)
  validate_string($excluded_interface_re)
  $collect_connection_state_bool = str2bool($collect_connection_state)

  datadog_agent::integration { 'network': }
  datadog_agent::integration::instance {
    'network':
      integration => 'network',
      params => {
        excluded_interfaces      => $excluded_interfaces,
        excluded_interface_re    => $excluded_interface_re,
        collect_connection_state => $collect_connection_state_bool,
      }

  }
}
