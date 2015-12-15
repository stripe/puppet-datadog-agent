require 'spec_helper'


describe 'datadog_agent::integration' do
  let(:facts) {{
    operatingsystem: 'Ubuntu'
  }}
  let(:title) { 'foobar' }
  let(:conf_dir) { "/etc/dd-agent/conf.d" }
  let(:config_file) { "#{conf_dir}/#{title}.yaml" }


  context 'with default parameters' do
    it { should contain_class('datadog_agent') }
    it { should compile.with_all_deps }
    it { should contain_datacat(config_file).with(
      template: 'datadog_agent/integration.yaml.erb',
      mode: '0600',
      owner: 'dd-agent',
      group: 'root',
    )}

    it { should contain_datacat(config_file).that_requires('Package[datadog-agent]') }
    it { should contain_datacat(config_file).that_notifies('Service[datadog-agent]') }

    it { should contain_datacat_fragment("dd_int_init_config_#{title}").with(
      target: config_file,
      data: {
        "init_config" => {}
      }
    )}

  end

  context 'with init_config set' do
    let(:params) {{
      init_config: {
        "foo" => "bar"
      }
    }}

    it { should contain_datacat_fragment("dd_int_init_config_#{title}").with(
      target: config_file,
      data: {
        "init_config" => {
          "foo" => "bar"
        }
      }
    )}
  end
end
