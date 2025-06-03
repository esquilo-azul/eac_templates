# frozen_string_literal: true

require 'eac_ruby_utils'
require 'eac_templates/interface_methods'

module EacTemplates
  module Modules
    class Ancestor
      module FsObject
        # @return [Pathname]
        delegate :path_for_search, to: :owner

        # @return [String]
        def to_s
          "#{self.class.name}[#{path_for_search}]"
        end

        private

        def source_object_uncached
          owner.source_set.send(type, path_for_search)
        end
      end
    end
  end
end
