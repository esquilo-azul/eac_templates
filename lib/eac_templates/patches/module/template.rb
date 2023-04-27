# frozen_string_literal: true

require 'eac_templates/modules/base'

class Module
  def template
    @template ||= ::EacTemplates::Modules::Base.new(self)
  end
end
