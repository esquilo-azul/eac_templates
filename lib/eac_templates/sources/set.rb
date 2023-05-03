# frozen_string_literal: true

require 'active_support/core_ext/object/blank'
require 'eac_templates/sources/directory'
require 'eac_templates/sources/file'
require 'eac_templates/sources/internal_set'
require 'eac_templates/abstract/not_found_error'

module EacTemplates
  module Sources
    class Set
      class << self
        def default
          @default ||= new
        end
      end

      # @param subpath [Pathname]
      # @return [EacTemplates::Sources::Directory]
      def directory(subpath)
        ::EacTemplates::Sources::Directory.by_subpath(self, nil, subpath, source_set: self)
      end

      # @param subpath [Pathname]
      # @return [EacTemplates::Sources::Directory]
      def file(subpath)
        ::EacTemplates::Sources::File.by_subpath(self, nil, subpath, source_set: self)
      end

      def template(subpath, required = true)
        found_file = file(subpath)
        return found_file if found_file.found?

        found_directory = directory(subpath)
        return found_directory if found_directory.found?

        return nil unless required

        raise_template_not_found(subpath)
      end

      # @return [EacTemplates::Sources::InternalSet]
      def included_paths
        @included_paths ||= ::EacTemplates::Sources::InternalSet.new
      end

      private

      def raise_template_not_found(subpath)
        raise ::EacTemplates::Abstract::NotFoundError, 'Template not found for subpath ' \
          "\"#{subpath}\" (Included paths: #{included_paths.to_a.join(::File::PATH_SEPARATOR)})"
      end
    end
  end
end
