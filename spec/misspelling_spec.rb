require_relative '../lib/awesome_list'

describe 'commonly misspelled English words check' do
  before(:each) do
    unless File.exists?('./bin/misspell')
      skip "Misspell is not installed. Run `rake setup`"
    end
  end

  context "README" do
    it 'should not have misspellings' do
      misspelling = `./bin/misspell README.md`

      expect(misspelling).to be_empty,
        "There is one or more misspellings on README.md \n" +
        "#{misspelling}"
    end
  end

  context "CONTRIBUTING" do
    it 'should not have misspellings' do
      misspelling = `./bin/misspell CONTRIBUTING.md`

      expect(misspelling).to be_empty,
        "There is one or more misspellings on CONTRIBUTING.md \n" +
        "#{misspelling}"
    end
  end
end
