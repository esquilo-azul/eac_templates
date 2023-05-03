# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_templates/interface_methods'
require 'eac_templates/sources/fs_object'
require 'eac_templates/variables/file'

module EacTemplates
  module Sources
    class File < ::EacTemplates::Sources::FsObject
      delegate(*::EacTemplates::InterfaceMethods::FILE, to: :applier)

      # @return [Class]
      def applier_class
        ::EacTemplates::Variables::File
      end

      # @param path [Pathname]
      # @return [Boolean]
      def select_path?(path)
        super && path.file?
      end
    end
  end
end
