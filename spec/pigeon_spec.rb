require 'pigeon'
require 'pry'

describe Pigeon::Email do
  before do
    File.stub(exists?: true)
    Rails.stub(root: 'pigeon')
    Pigeon.send(:remove_const, 'Template')
    load 'lib/pigeon.rb'
  end

  describe 'methods' do
    before do
      IO.stub(read:
        <<-EOS
        test_email: This is the test email
        EOS
      )
    end

    describe '#link' do
      it 'builds a mail link with options like to, cc and the email body' do
        Pigeon::Email.new(name: 'test_email', subject: 'subject', to: 'test@test.com', cc: ['test2@test.com']).link.should eq(
          'test@test.com?subject=subject&cc%5B%5D=test2%40test.com&body=This%20is%20the%20test%20email'
        )
      end
    end

    describe '#body' do
      it 'returns a email body based on the name' do
        Pigeon::Email.new(name: 'test_email').body.should eq('This is the test email')
      end

      it 'returns a email body based on names separated by space' do
        IO.stub(read:
          <<-EOS
          test:
            email: This is the test email
          EOS
        )

        Pigeon::Email.new(name: 'test email').body.should eq('This is the test email')
      end
    end
  end

  describe Pigeon::Template do
    before do
      IO.stub(read:
        <<-EOS
        test_email: This is the first test email
        test_email2: This is the second test email
        EOS
      )
    end

    it 'responds to emails defined in emails.yml' do
      Pigeon::Template.new[:test_email].should be_present
      Pigeon::Template.new[:test_email2].should be_present
    end

    it 'its methods return an email containing the body of the corresponding emails' do
      Pigeon::Template.new[:test_email].should eq('This is the first test email')
      Pigeon::Template.new[:test_email2].should eq('This is the second test email')
    end

    it 'allows access to nested email templates' do
      IO.stub(read:
        <<-EOS
        test1:
          email: This is the first test email
        test2:
          email: This is the second test email
        EOS
      )

      Pigeon::Template.new[:test1][:email].should eq('This is the first test email')
      Pigeon::Template.new[:test2][:email].should eq('This is the second test email')
    end
  end
end