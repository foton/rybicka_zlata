# frozen_string_literal: true

module Layout
  # One destination in the main navigation.
  NavItem = Data.define(:label, :path, :icon, :badge) do
    def initialize(label:, path:, icon:, badge: nil)
      super
    end

    # path may carry a query string (?locale=cs), current_path is request.path
    def active?(current_path)
      base = path.split('?').first
      current_path == base || current_path.to_s.start_with?("#{base}/")
    end
  end
end
