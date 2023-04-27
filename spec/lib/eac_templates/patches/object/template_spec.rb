# frozen_string_literal: true

require 'eac_templates/patches/object/template'

RSpec.describe ::Object do
  class MyStubWithTemplate # rubocop:disable RSpec/LeakyConstantDeclaration
  end

  let(:instance) { ::MyStubWithTemplate.new }
  let(:templates_path) { ::File.join(__dir__, 'template_spec_files', 'path') }

  before do
    ::EacTemplates::Searcher.default.included_paths.add(templates_path)
  end

  after do
    ::EacTemplates::Searcher.default.included_paths.delete(templates_path)
  end

  describe '#template' do
    it { expect(instance.template).to be_a(::EacTemplates::File) }
  end
end
