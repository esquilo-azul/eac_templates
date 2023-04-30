# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_templates/interface_methods'

module EacTemplates
  module Modules
    class Ancestor
      class FsObject
        enable_simple_cache
        common_constructor :base
        delegate(*::EacTemplates::InterfaceMethods::COMMON, :found?, to: :source_object)

        # @return [Symbol]
        def object_type
          self.class.name.demodulize.underscore.to_sym
        end

        # @return [Pathname, nil]
        def path
          source_object.found? ? source_object.send(:real_paths).first : nil
        end

        private

        def source_object_uncached
          base.source_set.send(object_type, base.path_for_search)
        end
      end
    end
  end
end
