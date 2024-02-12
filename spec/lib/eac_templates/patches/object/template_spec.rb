# frozen_string_literal: true

require 'eac_templates/interface_methods'
require 'eac_templates/patches/object/template'

RSpec.describe ::Object do
  class MyStubWithTemplate # rubocop:disable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration
  end

  let(:instance) { ::MyStubWithTemplate.new }
  let(:templates_path) { ::File.join(__dir__, 'template_spec_files', 'path') }

  before do
    ::EacTemplates::Sources::Set.default.included_paths.add(templates_path)
  end

  after do
    ::EacTemplates::Sources::Set.default.included_paths.delete(templates_path)
  end

  describe '#template' do
    ::EacTemplates::InterfaceMethods::FILE.each do |method_name|
      it { expect(instance.template).to respond_to(method_name) }
    end
  end
end
