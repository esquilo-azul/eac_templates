# frozen_string_literal: true

require 'erb'

class Module
  def erb_template(subpath, binding_obj)
    ::ERB.new(template.child(subpath).path.read).result(binding_obj)
  end
end
