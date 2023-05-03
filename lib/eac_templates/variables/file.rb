# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_templates/variables/content'
require 'eac_templates/variables/providers'

module EacTemplates
  module Variables
    class File
      enable_simple_cache
      common_constructor :path do
        self.path = path.to_pathname
      end
      delegate :apply, :apply_to_file, :content, :variables, to: :content_applier

      private

      # @return [EacTemplates::Variables::Content]
      def content_applier_uncached
        ::EacTemplates::Variables::Content.from_file(path)
      end
    end
  end
end
