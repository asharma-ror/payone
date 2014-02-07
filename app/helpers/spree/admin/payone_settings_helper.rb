module Spree
  module Admin
    module PayoneSettingsHelper

      def payone_settings_preference_field_tag(name, value, options)
        preference_field_tag(name, value, options)
      end

      def payone_settings_preference_visible_value(value, options)
        case options[:type]
        when :boolean
          value = value ? t(:yes) : t(:no)
        when :string
            if options.has_key? :values
              options[:values].each do |element|
                if element.kind_of?(Array) && element.length > 1 && element[1].to_s == value.to_s
                  value = t(element[0])
                end
              end
            end
        end
        value
      end
    end
  end
end
