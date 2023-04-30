# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_templates/variables/providers'

module EacTemplates
  module Variables
    class File
      VARIABLE_DELIMITER = ::Regexp.quote('%%')
      VARIABLE_PATTERN = /#{VARIABLE_DELIMITER}([a-z0-9\._]*)#{VARIABLE_DELIMITER}/i.freeze

      enable_simple_cache
      common_constructor :path do
        self.path = path.to_pathname
      end

      # +variables_provider+ A [Hash] or object which responds to +read_entry(entry_name)+.
      def apply(variables_source)
        variables_provider = ::EacTemplates::Variables::Providers.build(variables_source)
        variables.inject(content) do |a, e|
          a.gsub(variable_pattern(e), variables_provider.variable_value(e).to_s)
        end
      end

      def apply_to_file(variables_source, output_file_path)
        output_file_path.to_pathname.write(apply(variables_source))
      end

      private

      def variables_uncached
        content.scan(VARIABLE_PATTERN).map(&:first).map do |name|
          sanitize_variable_name(name)
        end.to_set
      end

      def content_uncached
        path.read
      end

      def sanitize_variable_name(variable_name)
        variable_name.to_s.downcase
      end

      def variable_pattern(name)
        /#{VARIABLE_DELIMITER}#{::Regexp.quote(name)}#{VARIABLE_DELIMITER}/i
      end
    end
  end
end
