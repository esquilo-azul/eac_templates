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
        r = {}
        real_paths.each do |real_path|
          real_path.children.each do |child|
            next if r.key?(child.basename)

            r[child.basename] = real_path_type(child)
          end
        end
        r
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
