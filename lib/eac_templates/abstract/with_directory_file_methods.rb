# frozen_string_literal: true

require 'eac_templates/abstract/not_found_error'

module EacTemplates
  module Abstract
    module WithDirectoryFileMethods
      def build_fs_object(type)
        fs_object_class(type).by_subpath(self, nil, subpath, source_set: source_set)
      end

      # @return [EacTemplates::Abstract::Directory]
      def directory
        build_fs_object(:directory)
      end

      # @return [EacTemplates::Abstract::File]
      def file
        build_fs_object(:file)
      end

      # @param type [Symbol]
      # @return [Class]
      def fs_object_class(type)
        self.class.const_get(type.to_s.camelize)
      end

      # @return [EacTemplates::Abstract::Directory, EacTemplates::Abstract::File]
      def sub_fs_object
        file_search = file
        return file_search if file_search.found?

        directory_search = directory
        return directory_search if directory_search.found?

        raise ::EacTemplates::Abstract::NotFoundError, "No template found: #{path_for_search}"
      end
    end
  end
end
