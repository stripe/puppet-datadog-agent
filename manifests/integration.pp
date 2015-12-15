define datadog_agent::integration (
  $init_config = {},
) {
  include datadog_agent

  $config_file = "${datadog_agent::conf_dir}/${name}.yaml"

  datacat {
    $config_file:
      template => 'datadog_agent/integration.yaml.erb',
      mode     => '0600',
      owner    => $datadog_agent::dd_user,
      group    => $datadog_agent::dd_group,
      require  => Package[$datadog_agent::package_name],
      notify   => Service[$datadog_agent::service_name];
  }

  datacat_fragment {
    "dd_int_init_config_${name}":
      target => $config_file,
      data   => {
        init_config => $init_config
      };
  }

}
