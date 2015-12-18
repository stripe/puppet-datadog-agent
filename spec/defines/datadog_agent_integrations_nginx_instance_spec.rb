require 'spec_helper'

describe 'datadog_agent::integrations::nginx::instance' do
  let(:facts) {{
    operatingsystem: 'Ubuntu'
  }}

  let(:conf_dir) { '/etc/dd-agent/conf.d' }
  let(:dd_user) { 'dd-agent' }
  let(:dd_group) { 'root' }
  let(:dd_package) { 'datadog-agent' }
  let(:dd_service) { 'datadog-agent' }
  let(:conf_file) { "#{conf_dir}/network.yaml" }

  let(:title) { 'foo' }
  let(:instance_title) { "nginx_#{title}" }
  let(:nginx_status_url) { 'http://localhost:1234/status' }

  let(:required_parameters) {{
    nginx_status_url: nginx_status_url,
  }}

  context 'with no parameters' do
    let(:params) { {} }
    it { should_not compile }
  end

  context 'with default parameters' do
    let(:params) { required_parameters }

    it { should contain_class('datadog_agent::integrations::nginx') }
    it { should compile.with_all_deps }
    it { should contain_datadog_agent__integration__instance(instance_title).with(
      integration: 'nginx',
      params: {
        'nginx_status_url' => nginx_status_url,
        'ssl_validation' => true,
      },
    )}
  end

  context 'with parameters set' do
    let(:params) { required_parameters.merge({
      ssl_validation: false,
      tags: %w{foo bar baz},
    })}

    it { should contain_datadog_agent__integration__instance(instance_title).with(
      integration: 'nginx',
      params: {
        'nginx_status_url' => nginx_status_url,
        'ssl_validation' => false,
      },
      tags: %w{foo bar baz},
    )}
  end

end
