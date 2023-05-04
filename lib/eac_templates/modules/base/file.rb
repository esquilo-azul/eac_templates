# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_templates/abstract/file'
require 'eac_templates/interface_methods'
require 'eac_templates/modules/base/fs_object'

module EacTemplates
  module Modules
    class Base
      class File < ::EacTemplates::Abstract::File
        include ::EacTemplates::Modules::Base::FsObject
        delegate(*EacTemplates::InterfaceMethods::FILE, to: :self_ancestor)
      end
    end
  end
end
