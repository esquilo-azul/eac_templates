# frozen_string_literal: true

require 'eac_fs/comparator'
require 'eac_templates/modules/base'
require 'eac_templates/errors/not_found'
require 'eac_templates/sources/set'

RSpec.describe EacTemplates::Modules::Base, '#apply' do
  include_context 'spec_paths', __FILE__
  include_context 'with modules resouces'

  %w[a_module prepended_module super_class sub_class].each do |module_variable|
    context "when module is #{module_variable.classify}" do
      let(:expected_path) { fixtures_directory.join(module_variable) }
      let(:instance) { described_class.new(send(module_variable), source_set: source_set) }
      let(:actual_path) { temp_dir }
      let(:comparator) { EacFs::Comparator.new }

      before do
        instance.apply(variables_source, actual_path)
      end

      it do
        expect(comparator.build(actual_path)).to eq(comparator.build(expected_path))
      end
    end
  end
end
