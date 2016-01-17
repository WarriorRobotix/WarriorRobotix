require 'test_helper'

class MemberTest < ActiveSupport::TestCase

  test "generate a random 22 characters remember token" do
    member = members(:member)
    remember_token = member.remember_token

    assert_not_nil remember_token, "Should generate remember token"
    assert_equal 22, remember_token.length, "Length of the remember token should be 22"
    assert_not_nil member.remember_digest, "Should generate hashed remember_digest"
  end

  test "find and authenticate remember token" do
    member = members(:member)
    remember_token = member.remember_token

    assert_equal member, Member.find_and_authenticate_remember_token(member.id, remember_token)
    assert_nil Member.find_and_authenticate_remember_token(nil, nil)
    assert_nil Member.find_and_authenticate_remember_token(member.id, nil)
    assert_nil Member.find_and_authenticate_remember_token(member.id, "wrong token")
  end

  test "rest password" do
    member = members(:member)
    reset_password_token = member.generate_reset_password_token!

    assert member.valid_reset_password_token?(reset_password_token), "Should return true on correct token"
    assert_not member.valid_reset_password_token?("wrong token"), "Should return false on incorrect token"
    assert_not member.valid_reset_password_token?(nil), "Should return false on nil token"
  end

  test "invalid rest password after 2 days" do
    member = members(:member)
    reset_password_token = member.generate_reset_password_token!

    travel 1.day

    assert member.valid_reset_password_token?(reset_password_token), "Correct token should be valid on within 2 days"

    travel 2.days

    assert_not member.valid_reset_password_token?(reset_password_token), "Incorrect token should be invalid on within 2 days"
  end

  test "abbr_name" do
    member = members(:member)

    assert_equal("#{member.first_name} #{member.last_name[0]}.", member.abbr_name)
  end

  test "create_admin" do
    assert_difference("Member.count") do
      Member.create_admin({
        first_name: "New",
        last_name: "Admin",
        email: "new.admin@example.com",
        grade: "12",
        student_number: "000",
        password: "123456"
      })
    end
  end

  test "create_admin should failable" do
    assert_no_difference("Member.count") do
      Member.create_admin({
        first_name: "",
        last_name: "",
        email: "new.admin@example.com",
        grade: "12",
        student_number: "000",
        password: "123456"
      })
    end
  end

end
