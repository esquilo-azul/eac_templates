# frozen_string_literal: true

require 'eac_templates/searcher'

RSpec.describe ::EacTemplates::Searcher do
  let(:files_dir) { ::File.join(__dir__, 'searcher_spec_files') }
  let(:instance) do
    r = described_class.new
    r.included_paths << ::File.join(files_dir, 'path1')
    r.included_paths << ::File.join(files_dir, 'path2')
    r
  end

  describe '#template' do
    {
      'subdir1' => ::EacTemplates::Directory,
      'subdir1/file1.template' => ::EacTemplates::File,
      'subdir1/file2' => ::EacTemplates::File,
      'subdir1/file3.template' => ::EacTemplates::File,
      'does_not_exist' => ::NilClass
    }.each do |subpath, klass|
      context "when subpath is \"#{subpath}\"" do
        let(:result) { instance.template(subpath, false) }

        it "returns a #{klass}'s instance" do
          expect(result).to be_a(klass)
        end
      end
    end
  end
end
