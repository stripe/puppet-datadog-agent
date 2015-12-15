define datadog_agent::integration::instance (
  $integration,
  $params = {},
  $tags = [],
) {
  include datadog_agent

  # tags param supports hash value, array value, or single element (which we'll just wrap with an array)
  if is_array($tags) or is_hash($tags) {
    $real_tags = $tags
  } elsif is_string($tags) {
    $real_tags = [$tags]
  } else {
    fail('tags must be a single string or an array or a hash')
  }

  if $params['tags'] {
    fail('do not supply tags in the params parameter, use the tags parameter')
  }

  validate_string($integration)
  validate_hash($params)

  $config_file = "${datadog_agent::conf_dir}/${integration}.yaml"
  $instance = merge({ tags => $real_tags }, $params)

  datacat_fragment {
    "dd_int_instance_${integration}_${name}":
      target => $config_file,
      data   => {
        instances => [$instance]
      };
  }

}
