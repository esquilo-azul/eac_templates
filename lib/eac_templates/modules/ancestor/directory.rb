# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_templates/abstract/directory'
require 'eac_templates/interface_methods'
require 'eac_templates/modules/ancestor/fs_object'

module EacTemplates
  module Modules
    class Ancestor
      class Directory < ::EacTemplates::Abstract::Directory
        include ::EacTemplates::Modules::Ancestor::FsObject
        delegate :children_basenames, to: :source_object
      end
    end
  end
end
