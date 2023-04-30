# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_templates/sources/fs_object'
require 'eac_templates/variables/directory'

module EacTemplates
  module Sources
    class Directory < ::EacTemplates::Sources::FsObject
      delegate :apply, :child, :children, :path, to: :applier

      # @return [Class]
      def applier_class
        ::EacTemplates::Variables::Directory
      end

      # @param path [Pathname]
      # @return [Boolean]
      def select_path?(path)
        super && path.directory?
      end
    end
  end
end
