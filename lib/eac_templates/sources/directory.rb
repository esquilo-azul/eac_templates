# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_templates/abstract/directory'
require 'eac_templates/sources/fs_object'

module EacTemplates
  module Sources
    class Directory < ::EacTemplates::Abstract::Directory
      include ::EacTemplates::Sources::FsObject

      # @return [Hash<Pathname, Symbol>]
      def children_basenames
        path.children.map { |c| [c.basename, real_path_type(c)] }.to_h
      end

      # @return [Pathname]
      def real_path_type(path)
        if path.file?
          :file
        elsif path.directory?
          :directory
        else
          raise "Path \"#{path}\" is not a file nor a directory"
        end
      end
    end
  end
end
