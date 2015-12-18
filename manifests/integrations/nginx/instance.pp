define datadog_agent::integrations::nginx::instance (
  $nginx_status_url,
  $ssl_validation = true,
  $tags           = undef,
) {
  include datadog_agent::integrations::nginx
  $ssl_validation_bool = str2bool($ssl_validation)

  datadog_agent::integration::instance {
    "nginx_${name}":
      integration => 'nginx',
      params      => {
        nginx_status_url => $nginx_status_url,
        ssl_validation   => $ssl_validation_bool,
      },
      tags        => $tags;
  }

}
