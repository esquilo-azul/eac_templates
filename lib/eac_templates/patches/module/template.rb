# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'
require 'eac_templates/sources/set'

class Module
  def template
    @template ||= ::EacTemplates::Sources::Set.default.template(name.underscore)
  end
end
