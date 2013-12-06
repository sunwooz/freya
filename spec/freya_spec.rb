require 'spec_helper'

describe Freya::Email do
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
        Freya::Email.new(name: 'test_email', subject: 'subject', to: 'test@test.com', cc: ['test1@test.com', 'test2@test.com']).link.should eq(
          'test@test.com?cc=test1%40test.com&cc=test2%40test.com&body=This%20is%20the%20test%20email&subject=subject'
        )
      end
    end

    describe '#body' do
      it 'returns a email body based on the name' do
        Freya::Email.new(name: 'test_email').body.should eq('This is the test email')
      end

      it 'returns a email body based on names separated by point' do
        reload_template

        IO.stub(read:
          <<-EOS
          test:
            email: This is the test email
          EOS
        )

        Freya::Email.new(name: 'test.email').body.should eq('This is the test email')
      end

      it 'raises exception if the key is not found' do
        expect {
          Freya::Email.new(name: 'wrong_name').body
        }.to raise_error
      end
    end

    describe '#cc' do
      it "doesn't contain #to email" do
        Freya::Email.new(name: 'test_email', to: 'test@test.com', cc: ['test@test.com', 'test2@test.com']).cc.should eq(['test2@test.com'])
      end
    end

    describe '#bcc' do
      it "doesn't contain #to email" do
        Freya::Email.new(name: 'test_email', to: 'test@test.com', bcc: ['test@test.com', 'test1@test.com']).bcc.should eq(['test1@test.com'])
      end
    end

    describe 'base_cc' do
      it 'contains the base ccs' do
        Freya::Email.new(
          name: 'test_email',
          to: 'test@test.com',
          cc: ['test@test.com','test2@test.com'],
          base_cc: ['base_email@test.com']
        ).cc.should eq(['base_email@test.com', 'test2@test.com'])
      end
    end

    describe 'base_bcc' do
      it 'contains the base bccs' do
        Freya::Email.new(
          name: 'test_email',
          to: 'test@test.com',
          bcc: ['test@test.com','test1@test.com'],
          base_bcc: ['base_email@test.com']
        ).bcc.should eq(['base_email@test.com', 'test1@test.com'])
      end
    end
  end

  describe Freya::Template do
    before do
      IO.stub(read:
        <<-EOS
        test_email: This is the first test email
        test_email2: This is the second test email
        EOS
      )

      reload_template
    end

    it 'responds to emails defined in emails.yml' do
      Freya::Template.new[:test_email].should be_present
      Freya::Template.new[:test_email2].should be_present
    end

    it 'its methods return an email containing the body of the corresponding emails' do
      Freya::Template.new[:test_email].should eq('This is the first test email')
      Freya::Template.new[:test_email2].should eq('This is the second test email')
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

      reload_template

      Freya::Template.new[:test1][:email].should eq('This is the first test email')
      Freya::Template.new[:test2][:email].should eq('This is the second test email')
    end
  end
end

describe Freya::Gmail do
  before do
    IO.stub(read:
      <<-EOS
      test_email: This is the test email
      EOS
    )
  end

  it 'builds the mail link for gmail if the type is set to gmail' do
    Freya::Gmail.new(name: 'test_email', subject: 'subject', to: 'test@test.com').link.should eq(
      'https://mail.google.com/mail?body=This%20is%20the%20test%20email&su=subject&to=test%40test.com&view=cm&fs=1'
    )
  end
end