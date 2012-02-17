require 'test_helper'

class CompaniesMailerTest < ActionMailer::TestCase
  test "update" do
    mail = CompaniesMailer.update
    assert_equal "Update", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
