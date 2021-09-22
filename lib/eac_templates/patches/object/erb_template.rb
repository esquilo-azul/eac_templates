# frozen_string_literal: true

require 'eac_templates/patches/module/erb_template'

class Object
  def erb_template(subpath, binding_obj = nil)
    self.class.erb_template(subpath, binding_obj || binding)
  end
end
