# frozen_string_literal: true

require 'eac_templates/errors/not_found'

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

      # @return [Boolean]
      def file?
        file.found?
      end

      # @return [Boolean]
      def file_template?
        file? && file.template?
      end

      # @return [Boolean]
      def found?
        directory? || file?
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

        raise ::EacTemplates::Errors::NotFound, "No template found: #{self}"
      end

      # @return [String]
      def to_s
        v = 'NOT_FOUND'
        v = directory.to_s if directory?
        v = file.to_s if file?
        "#{self.class.name}[#{v}]"
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
