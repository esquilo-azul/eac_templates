# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'
require 'eac_templates/searcher'

class Module
  def template
    @template ||= ::EacTemplates::Searcher.default.template(name.underscore)
  end
end
