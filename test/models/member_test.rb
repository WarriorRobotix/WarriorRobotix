require 'test_helper'

class MemberTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "generate a random 22 characters remember token" do
    edward = members(:edward)
    remember_token = edward.remember_token

    assert_not_nil remember_token, "Should generate remember token"
    assert_equal 22, remember_token.length, "Length of the remember token should be 22"
    assert_not_nil edward.remember_digest, "Should generate hashed remember_digest"
  end

  test "find and authenticate remember token" do
    edward = members(:edward)
    remember_token = edward.remember_token

    assert_equal edward, Member.find_and_authenticate_remember_token(edward.id, remember_token)
    assert_nil Member.find_and_authenticate_remember_token(nil, nil)
    assert_nil Member.find_and_authenticate_remember_token(edward.id, nil)
    assert_nil Member.find_and_authenticate_remember_token(edward.id, "wrong token")
  end

  test "rest password" do
    edward = members(:edward)
    reset_password_token = edward.reset_password
    edward.save!

    assert edward.valid_reset_password_token?(reset_password_token), "Should return true on correct token"
    assert_not edward.valid_reset_password_token?("wrong token"), "Should return false on incorrect token"
    assert_not edward.valid_reset_password_token?(nil), "Should return false on nil token"
  end

  test "invalid rest password after 2 days" do
    edward = members(:edward)
    reset_password_token = edward.generate_reset_password_token!

    travel 1.day

    assert edward.valid_reset_password_token?(reset_password_token), "Correct token should be valid on within 2 days"

    travel 2.days

    assert_not edward.valid_reset_password_token?(reset_password_token), "Incorrect token should be invalid on within 2 days"
  end

end
