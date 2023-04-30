# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_templates/interface_methods'
require 'eac_templates/modules/ancestor/fs_object'

module EacTemplates
  module Modules
    class Ancestor
      class File < ::EacTemplates::Modules::Ancestor::FsObject
        delegate(*::EacTemplates::InterfaceMethods::ONLY_FILE, to: :source_object)
      end
    end
  end
end
