# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_templates/interface_methods'

module EacTemplates
  module Modules
    class Ancestor
      module FsObject
        delegate :found?, :path, to: :source_object

        # @return [Pathname]
        delegate :path_for_search, to: :owner

        private

        def source_object_uncached
          owner.source_set.send(type, path_for_search)
        end
      end
    end
  end
end
