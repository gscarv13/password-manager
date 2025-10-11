require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(email: "test@example.com", password: "password123")
  end

  # Basic validations (provided by Devise)
  test "should be valid with valid attributes" do
    assert @user.valid?
  end

  test "should require email" do
    @user.email = nil
    assert_not @user.valid?
    assert_includes @user.errors[:email], "can't be blank"
  end

  test "should require password" do
    @user.password = nil
    assert_not @user.valid?
    assert_includes @user.errors[:password], "can't be blank"
  end

  test "should require unique email" do
    @user.save!
    duplicate_user = User.new(email: @user.email, password: "password123")
    assert_not duplicate_user.valid?
    assert_includes duplicate_user.errors[:email], "has already been taken"
  end

  test "should require valid email format" do
    invalid_emails = %w[invalid_email @example.com user@]
    invalid_emails.each do |email|
      @user.email = email
      assert_not @user.valid?, "#{email} should be invalid"
      assert_includes @user.errors[:email], "is invalid"
    end
  end

  test "should downcase email before saving" do
    mixed_case_email = "TeSt@ExAmPlE.CoM"
    @user.email = mixed_case_email
    @user.save!
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  # Association tests
  test "should have many entries" do
    assert_respond_to @user, :entries
  end

  test "should destroy associated entries when user is destroyed" do
    @user.save!
    @user.entries.create!(
      name: "Test Entry",
      url: "https://example.com",
      username: "testuser",
      password: "testpass"
    )

    assert_difference "Entry.count", -1 do
      @user.destroy
    end
  end

  test "entries association should return user's entries only" do
    @user.save!
    other_user = User.create!(email: "other@example.com", password: "password123")

    user_entry = @user.entries.create!(
      name: "User Entry",
      url: "https://example.com",
      username: "user",
      password: "pass"
    )

    other_entry = other_user.entries.create!(
      name: "Other Entry",
      url: "https://other.com",
      username: "other",
      password: "pass"
    )

    assert_includes @user.entries, user_entry
    assert_not_includes @user.entries, other_entry
    assert_equal 1, @user.entries.count
  end

  # Edge cases
  test "should handle very long email" do
    long_email = "a" * 244 + "@example.com"
    @user.email = long_email
    @user.valid?

    assert @user.errors[:email].empty? || @user.errors[:email].any? { |error| error.include?("too long") }
  end
end
