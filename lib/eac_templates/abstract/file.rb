# frozen_string_literal: true

require 'eac_ruby_utils'
require 'eac_templates/interface_methods'
require 'eac_templates/abstract/fs_object'
require 'eac_templates/variables/file'

module EacTemplates
  module Abstract
    class File < ::EacTemplates::Abstract::FsObject
      enable_abstract_methods
      delegate(*::EacTemplates::InterfaceMethods::FILE - %i[content path], to: :applier)

      # @return [String]
      def content
        path.read
      end

      # @return [Pathname]
      def path
        raise_abstract_method __method__
      end
    end
  end
end
