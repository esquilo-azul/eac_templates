# frozen_string_literal: true

require 'eac_templates/modules/base'
require 'eac_templates/errors/not_found'
require 'eac_templates/sources/set'

RSpec.describe EacTemplates::Modules::Base, '#child' do
  include_context 'with modules resouces'

  def self.on_node_specs(node_name, &block)
    context "when object is \"#{node_name}\"" do
      let(:node) { send(node_name) }

      instance_eval(&block)
    end
  end

  def self.dir_specs(node_name, expected_children)
    on_node_specs(node_name) do
      it do
        expect(node.children.map { |child| child.basename.to_path }.sort).to(
          eq(expected_children.sort)
        )
      end
    end
  end

  def self.file_specs_ok(node_name, expected_content, expected_apply, # rubocop:disable Metrics/AbcSize
                         expected_variables)
    on_node_specs(node_name) do
      it { expect(node.content).to eq(expected_content) }
      it { expect(node.variables).to eq(Set.new(expected_variables)) }
      it { expect(node.apply(variables_source)).to eq(expected_apply) }

      it do
        target_file = temp_file
        node.apply_to_file(variables_source, target_file)
        expect(target_file.read).to eq(expected_apply)
      end
    end
  end

  def self.file_specs_error(node_name)
    on_node_specs(node_name) do
      it do
        expect { node }.to raise_error(EacTemplates::Errors::NotFound)
      end
    end
  end

  let(:a) { instance.child('a') }
  let(:a_a) { a.child('a_a') }
  let(:a_b) { a.child('a_b') }
  let(:a_c) { a.child('a_c') }
  let(:b) { instance.child('b') }
  let(:c) { instance.child('c') }
  let(:d) { instance.child('d') }

  context 'when module is AModule' do # rubocop:disable RSpec/EmptyExampleGroup
    let(:instance) { described_class.new(a_module, source_set: source_set) }

    dir_specs(:a, %w[a_a a_b])
    file_specs_ok(:a_a, "A_MODULE.P1.A_A\n", "A_MODULE.P1.A_A\n", [])
    file_specs_ok(:a_b, "A_MODULE.P2.A_B\n", "A_MODULE.P2.A_B\n", [])
    file_specs_error(:a_c)
    file_specs_ok(:b, "A_MODULE.P1.B.%%vy%%\n", "A_MODULE.P1.B._Y_\n", %w[vy])
    file_specs_ok(:c, "A_MODULE.P2.C.%%vx%%\n", "A_MODULE.P2.C._X_\n", %w[vx])
    file_specs_error(:d)
  end

  context 'when module is SuperClass' do # rubocop:disable RSpec/EmptyExampleGroup
    let(:instance) { described_class.new(super_class, source_set: source_set) }

    dir_specs(:a, %w[a_a a_b])
    file_specs_ok(:a_a, "A_MODULE.P1.A_A\n", "A_MODULE.P1.A_A\n", [])
    file_specs_ok(:a_b, "SUPER_CLASS.P1.A_B\n", "SUPER_CLASS.P1.A_B\n", [])
    file_specs_error(:a_c)
    file_specs_ok(:b, "SUPER_CLASS.P1.B\n", "SUPER_CLASS.P1.B\n", [])
    file_specs_ok(:c, "A_MODULE.P2.C.%%vx%%\n", "A_MODULE.P2.C._X_\n", %w[vx])
    file_specs_error(:d)
  end

  context 'when module is SubClass' do # rubocop:disable RSpec/EmptyExampleGroup
    let(:instance) { described_class.new(sub_class, source_set: source_set) }

    dir_specs(:a, %w[a_a a_b a_c a_d])
    file_specs_ok(:a_a, "A_MODULE.P1.A_A\n", "A_MODULE.P1.A_A\n", [])
    file_specs_ok(:a_b, "SUPER_CLASS.P1.A_B\n", "SUPER_CLASS.P1.A_B\n", [])
    file_specs_ok(:a_c, "SUB_CLASS.P1.A_C\n", "SUB_CLASS.P1.A_C\n", [])
    file_specs_ok(:b, "SUB_CLASS.P2.B\n", "SUB_CLASS.P2.B\n", [])
    file_specs_ok(:c, "PREPENDED_MODULE.P2.C.%%vy%%%%vx%%\n", "PREPENDED_MODULE.P2.C._Y__X_\n",
                  %w[vy vx])
    file_specs_ok(:d, "PREPENDED_MODULE.P2.D.%%vy%%%%vx%%\n", "PREPENDED_MODULE.P2.D._Y__X_\n",
                  %w[vy vx])
  end

  context 'when module is PrependedModule' do # rubocop:disable RSpec/EmptyExampleGroup
    let(:instance) { described_class.new(prepended_module, source_set: source_set) }

    dir_specs(:a, %w[a_d])
    file_specs_error(:a_a)
    file_specs_error(:a_b)
    file_specs_error(:a_c)
    file_specs_error(:b)
    file_specs_ok(:c, "PREPENDED_MODULE.P2.C.%%vy%%%%vx%%\n", "PREPENDED_MODULE.P2.C._Y__X_\n",
                  %w[vy vx])
    file_specs_ok(:d, "PREPENDED_MODULE.P2.D.%%vy%%%%vx%%\n", "PREPENDED_MODULE.P2.D._Y__X_\n",
                  %w[vy vx])
  end
end
