# frozen_string_literal: true

require 'eac_ruby_utils'
require 'eac_templates/abstract/directory'
require 'eac_templates/interface_methods'
require 'eac_templates/modules/ancestor/fs_object'

module EacTemplates
  module Modules
    class Ancestor
      class Directory < ::EacTemplates::Abstract::Directory
        include ::EacTemplates::Modules::Ancestor::FsObject

        delegate :found?, :path, to: :source_object

        # @return [Hash<Pathname, Symbol>]
        def children_basenames
          source_object.children_basenames.to_h { |k, v| parse_child_basename(k, v) }
        end

        protected

        # @param basename [Pathname]
        # @param type [Symbol]
        # @return [Array]
        def parse_child_basename(basename, type)
          return [basename, type] unless type == :file

          new_basename = ::EacTemplates::Modules::Ancestor::File.parse_basename(basename)

          return [basename, type] if new_basename == basename

          [new_basename, :file_template]
        end
      end
    end
  end
end
