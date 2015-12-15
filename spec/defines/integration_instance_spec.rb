require 'spec_helper'

describe 'datadog_agent::integration::instance' do
  let(:facts) {{
    operatingsystem: 'Ubuntu'
  }}

  let(:title) { 'apache_example.com' }
  let(:integration) { 'apache' }
  let(:conf_dir) { '/etc/dd-agent/conf.d'}
  let(:config_file) { "#{conf_dir}/#{integration}.yaml" }
  let(:datacat_fragment_title) { "dd_int_instance_#{integration}_#{title}" }

  context 'with default parameters' do
    it { should_not compile }
  end

  context 'with only integration set' do
    let(:params) {{ integration: integration }}

    it { should compile.with_all_deps }
    it { should contain_class('datadog_agent') }
    it { should contain_datacat_fragment(datacat_fragment_title).with(
      target: config_file,
      data: {
        "instances" => [
          {
            "tags" => []
          }
        ],
      },
    )}
  end

  context 'with non-string integration name' do
    context 'as array' do
      let(:params) {{ integration: [] }}
      it { should_not compile }
    end

    context 'as hash' do
      let(:params) {{ integration: {} }}
      it { should_not compile }
    end

    context 'as numeric' do
      let(:params) {{ integration: 1234 }}
      it { should compile.with_all_deps }
    end
  end

  context 'with params set' do
    context 'without tags' do
      let(:params) {{
        integration: integration,
        params: {
          "foo" => "bar",
          "baz" => "bat",
        }
      }}

      it { should contain_datacat_fragment(datacat_fragment_title).with(
        target: config_file,
        data: {
          "instances" => [{
            "foo" => "bar",
            "baz" => "bat",
            "tags" => [],
          }],
        }
      )}
    end

    context 'with tags' do
      let(:params) {{
        integration: integration,
        params: {
          "foo" => "bar",
          "baz" => "bat",
        },
        tags: %w{foo bar baz}
      }}

      it { should contain_datacat_fragment(datacat_fragment_title).with(
        target: config_file,
        data: {
          "instances" => [{
            "foo" => "bar",
            "baz" => "bat",
            "tags" => %w{foo bar baz},
          }]
        }
      )}
    end
  end

  context 'with params set to non-hash' do
    let(:params) {{
      integration: integration,
      params: %w{abc 123},
    }}

    it { should_not compile }

    let(:params) {{
      integration: integration,
      params: 'htnasoeu',
    }}

    it { should_not compile }
  end

  context 'tags in params hash' do
    let(:params) {{
      integration: integration,
      params: {
        'tags' => %w{foo bar baz},
        'foo' => 'bar',
        'baz' => 'bat',
      }
    }}

    it { should_not compile }
  end

  context 'tags is single element' do
    let(:params) {{
      integration: integration,
      tags: 'foo',
    }}

    it { should contain_datacat_fragment(datacat_fragment_title).with(
      target: config_file,
      data: {
        "instances" => [{
          "tags" => %w{foo},
        }]
      }
    )}
  end

  context 'tags is array' do
    let(:params) {{
      integration: integration,
      tags: %w{foo bar baz},
    }}
    it { should contain_datacat_fragment(datacat_fragment_title).with(
      target: config_file,
      data: {
        "instances" => [{
          "tags" => %w{foo bar baz},
        }]
      }
    )}
  end

  context 'tags is hash' do
    let(:params) {{
      integration: integration,
      tags: {
        "foo" => "bar",
        "baz" => "bat",
      }
    }}
    it { should contain_datacat_fragment(datacat_fragment_title).with(
      target: config_file,
      data: {
        "instances" => [{
          "tags" => {
            "foo" => "bar",
            "baz" => "bat",
          }
        }]
      }
    )}
  end
end
