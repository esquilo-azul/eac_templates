# frozen_string_literal: true

require 'eac_templates/modules/base'
require 'eac_templates/abstract/not_found_error'
require 'eac_templates/sources/set'

RSpec.describe EacTemplates::Modules::Base do
  def self.on_node_specs(node_name, &block)
    context "when object is \"#{node_name}\"" do
      let(:node) { send(node_name) }

      instance_eval(&block)
    end
  end

  def self.dir_specs(node_name, expected_children)
    on_node_specs(node_name) do
      it do
        expect(node.children.map { |child| child.path.basename.to_path }).to(
          eq(expected_children)
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
        expect { node }.to raise_error(EacTemplates::Abstract::NotFoundError)
      end
    end
  end

  let(:a_module) do
    Module.new do
      def self.name
        'AModule'
      end
    end
  end
  let(:super_class) do
    r = Class.new do
      def self.name
        'SuperClass'
      end
    end
    r.include a_module
    r
  end
  let(:prepended_module) do
    Module.new do
      def self.name
        'PrependedModule'
      end
    end
  end
  let(:sub_class) do
    r = Class.new(super_class) do
      def self.name
        'SuperClass'
      end
    end
    r.prepend(prepended_module)
    r
  end
  let(:files_dir) { __dir__.to_pathname.join('base_spec_files') }
  let(:variables_source) { { vx: '_X_', vy: '_Y_' } }
  let(:source_set) do
    r = EacTemplates::Sources::Set.new
    %w[path1 path2].each do |sub|
      r.included_paths << files_dir.join(sub)
    end
    r
  end

  let(:a) { instance.child('a') }
  let(:a_a) { a.child('a_a') }
  let(:a_b) { a.child('a_b') }
  let(:a_c) { a.child('a_c') }
  let(:b) { instance.child('b') }
  let(:c) { instance.child('c') }

  context 'when module is AModule' do # rubocop:disable RSpec/EmptyExampleGroup
    let(:instance) { described_class.new(a_module, source_set: source_set) }

    dir_specs(:a, %w[a_a a_b])
    file_specs_ok(:a_a, "A_MODULE_A_A\n", "A_MODULE_A_A\n", [])
    file_specs_ok(:a_b, "A_MODULE_A_B\n", "A_MODULE_A_B\n", [])
    file_specs_error(:a_c)
    file_specs_ok(:b, "A_MODULE_B%%vy%%\n", "A_MODULE_B_Y_\n", %w[vy])
    file_specs_ok(:c, "A_MODULE_C%%vx%%\n", "A_MODULE_C_X_\n", %w[vx])
  end

  context 'when module is SuperClass' do # rubocop:disable RSpec/EmptyExampleGroup
    let(:instance) { described_class.new(super_class, source_set: source_set) }

    dir_specs(:a, %w[a_b])
    file_specs_error(:a_a)
    file_specs_ok(:a_b, "SUPER_CLASS_A_B\n", "SUPER_CLASS_A_B\n", [])
    file_specs_error(:a_c)
    file_specs_ok(:b, "SUPER_CLASS_B\n", "SUPER_CLASS_B\n", [])
    file_specs_error(:c)
  end

  context 'when module is SubClass' do # rubocop:disable RSpec/EmptyExampleGroup
    let(:instance) { described_class.new(sub_class, source_set: source_set) }

    dir_specs(:a, %w[a_b])
    file_specs_error(:a_a)
    file_specs_ok(:a_b, "SUPER_CLASS_A_B\n", "SUPER_CLASS_A_B\n", [])
    file_specs_error(:a_c)
    file_specs_ok(:b, "SUPER_CLASS_B\n", "SUPER_CLASS_B\n", [])
    file_specs_error(:c)
  end

  context 'when module is PrependedModule' do # rubocop:disable RSpec/EmptyExampleGroup
    let(:instance) { described_class.new(prepended_module, source_set: source_set) }

    file_specs_error(:a)
    file_specs_error(:a_a)
    file_specs_error(:a_b)
    file_specs_error(:a_c)
    file_specs_error(:b)
    file_specs_ok(:c, "PREPENDED_MODULE_C%%vy%%%%vx%%\n", "PREPENDED_MODULE_C_Y__X_\n", %w[vy vx])
  end
end
