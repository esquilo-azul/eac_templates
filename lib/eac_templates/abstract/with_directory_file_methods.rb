# frozen_string_literal: true

require 'eac_templates/abstract/not_found_error'

module EacTemplates
  module Abstract
    module WithDirectoryFileMethods
      common_concern do
        enable_simple_cache
      end

      def build_fs_object(type)
        fs_object_class(type).by_subpath(self, nil, subpath, source_set: source_set)
      end

      # @param child_basename [Pathname
      # @return [Pathname]
      def child_subpath(child_basename)
        subpath.if_present(child_basename) { |v| v.join(child_basename) }.to_pathname
      end

      # @return [Boolean]
      def directory?
        directory.found?
      end

      # @param type [Symbol]
      # @return [Class]
      def fs_object_class(type)
        self.class.const_get(type.to_s.camelize)
      end

      # @return [EacTemplates::Abstract::Directory, EacTemplates::Abstract::File]
      def sub_fs_object
        return file if file.found?
        return directory if directory.found?

        raise ::EacTemplates::Abstract::NotFoundError, "No template found: #{self}"
      end

      private

      # @return [EacTemplates::Abstract::Directory]
      def directory_uncached
        build_fs_object(:directory)
      end

      # @return [EacTemplates::Abstract::File]
      def file_uncached
        build_fs_object(:file)
      end
    end
  end
end
