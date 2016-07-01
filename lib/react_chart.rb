module ReactChart
  class << self
    def react_chart_config
      self.instance_variable_get(:@react_chart_config) || {}
    end

    def set_mount_prefix(mount_prefix)
      config = ReactChart.react_chart_config
      config[:mount_prefix] = mount_prefix
      ReactChart.instance_variable_set(:@react_chart_config, config)
    end

    def get_mount_prefix
      react_chart_config[:mount_prefix]
    end
  end
end

# 引用 rails engine
require 'react_chart/engine'
require 'react_chart/rails_routes'
