# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_templates/abstract/file'
require 'eac_templates/interface_methods'
require 'eac_templates/modules/ancestor/fs_object'

module EacTemplates
  module Modules
    class Ancestor
      class File < ::EacTemplates::Abstract::File
        include ::EacTemplates::Modules::Ancestor::FsObject
      end
    end
  end
end
