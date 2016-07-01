module ReactChart
  class Routing
    # ReactChart::Routing.mount "/react_chart", :as => 'react_chart'
    def self.mount(prefix, options)
      ReactChart.set_mount_prefix prefix

      Rails.application.routes.draw do
        mount ReactChart::Engine => prefix, :as => options[:as]
      end
    end
  end
end
