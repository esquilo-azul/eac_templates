# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_templates/interface_methods'
require 'eac_templates/abstract/not_found_error'

module EacTemplates
  module Modules
    class Ancestor
      class << self
        # @param a_module [Module]
        # @return [Pathname]
        def path_for_search(a_module)
          a_module.name.underscore.to_pathname
        end
      end

      common_constructor :base, :ancestor
      delegate :subpath, :source_set, to: :base
      delegate(*::EacTemplates::InterfaceMethods::ALL, to: :source_object)

      # @return [EacTemplates::Modules::Directory]
      def directory
        @directory ||= ::EacTemplates::Modules::Ancestor::Directory
                         .new(self, nil, nil, source_set: source_set)
      end

      # @return [EacTemplates::Modules::File]
      def file
        @file ||= ::EacTemplates::Modules::Ancestor::File
                    .new(self, nil, nil, source_set: source_set)
      end

      # @return [Pathname]
      def path_for_search
        r = self.class.path_for_search(ancestor)
        subpath.if_present(r) { |v| r.join(v) }
      end

      # @return [EacTemplates::Modules::Ancestor::FsObject]
      def source_object
        return file if file.found?
        return directory if directory.found?

        raise ::EacTemplates::Abstract::NotFoundError, "No template found: #{path_for_search}"
      end

      require_sub __FILE__
    end
  end
end
