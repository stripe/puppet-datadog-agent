require 'spec_helper'

describe 'datadog_agent::integrations::network' do
  let(:facts) {{
    operatingsystem: 'Ubuntu'
  }}

  let(:conf_dir) { '/etc/dd-agent/conf.d' }
  let(:dd_user) { 'dd-agent' }
  let(:dd_group) { 'root' }
  let(:dd_package) { 'datadog-agent' }
  let(:dd_service) { 'datadog-agent' }
  let(:conf_file) { "#{conf_dir}/network.yaml" }

  context 'with default parameters' do
    it { should compile.with_all_deps }
    it { should contain_datadog_agent__integration('network') }
    it { should contain_datadog_agent__integration__instance('network').with(
      integration: 'network',
      params: {
        'excluded_interfaces' => [],
        'excluded_interface_re' => :undef,
        'collect_connection_state' => false,
      }
    )}
  end

  context 'with parameters set' do
    let(:params) {{
      excluded_interfaces: %w{eth0 eth1 eth2},
      excluded_interface_re: 'igb.*',
      collect_connection_state: true,
    }}
    it { should contain_datadog_agent__integration__instance('network').with(
      integration: 'network',
      params: {
        'excluded_interfaces' => %w{eth0 eth1 eth2},
        'excluded_interface_re' => 'igb.*',
        'collect_connection_state' => true
      }
    )}
  end

  context 'with excluded_interfaces invalid' do
    let(:params) {{
      excluded_interfaces: {},
    }}
    it { should_not compile }
  end
end
