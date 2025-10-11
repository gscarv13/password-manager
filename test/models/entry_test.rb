require "test_helper"

class EntryTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @entry = Entry.new(
      name: "Test Service",
      url: "https://example.com",
      username: "testuser",
      password: "testpass123",
      user: @user
    )
  end

  # Basic validations
  test "should be valid with valid attributes" do
    assert @entry.valid?
  end

  test "should require name" do
    @entry.name = nil
    assert_not @entry.valid?
    assert_includes @entry.errors[:name], "can't be blank"
  end

  test "should require username" do
    @entry.username = nil
    assert_not @entry.valid?
    assert_includes @entry.errors[:username], "can't be blank"
  end

  test "should require password" do
    @entry.password = nil
    assert_not @entry.valid?
    assert_includes @entry.errors[:password], "can't be blank"
  end

  test "should require user" do
    @entry.user = nil
    assert_not @entry.valid?
    assert_includes @entry.errors[:user], "must exist"
  end

  test "should not accept whitespace name" do
    @entry.name = "   "
    assert_not @entry.valid?
    assert_includes @entry.errors[:name], "can't be blank"
  end

  test "should not accept whitespace username" do
    @entry.username = "   "
    assert_not @entry.valid?
    assert_includes @entry.errors[:username], "can't be blank"
  end

  test "should not accept whitespace password" do
    @entry.password = "   "
    assert_not @entry.valid?
    assert_includes @entry.errors[:password], "can't be blank"
  end

  # URL validation tests
  test "should be valid without url" do
    @entry.url = nil
    assert @entry.valid?
  end

  test "should be valid with http url" do
    @entry.url = "http://example.com"
    assert @entry.valid?
  end

  test "should be valid with https url" do
    @entry.url = "https://example.com"
    assert @entry.valid?
  end

  test "should be invalid with malformed url" do
    @entry.url = "not-a-url"
    assert_not @entry.valid?
    assert_includes @entry.errors[:url], "must be valid"
  end

  test "should be invalid with url missing protocol" do
    @entry.url = "example.com"
    assert_not @entry.valid?
    assert_includes @entry.errors[:url], "must be valid"
  end

  test "should be valid with complex urls" do
    valid_urls = [
      "https://subdomain.example.com",
      "http://example.com:8080",
      "https://example.com/path/to/resource",
      "https://example.com/path?param=value",
      "https://example.com/path#anchor"
    ]

    valid_urls.each do |url|
      @entry.url = url
      assert @entry.valid?, "#{url} should be valid"
    end
  end

  # Association tests
  test "should belong to user" do
    assert_respond_to @entry, :user
    assert_equal @user, @entry.user
  end

  test "should be destroyed when user is destroyed" do
    @entry.save!
    initial_count = Entry.count
    user_entries_count = @user.entries.count

    @user.destroy

    assert_equal initial_count - user_entries_count, Entry.count
  end

  # Encryption tests
  test "should encrypt username deterministically" do
    @entry.save!

    # Username should be encrypted
    raw_username = @entry.username
    encrypted_username = @entry.read_attribute_before_type_cast(:username)

    assert_not_equal raw_username, encrypted_username
    assert encrypted_username.present?
  end

  test "should encrypt password non-deterministically" do
    @entry.save!

    # Password should be encrypted
    raw_password = @entry.password
    encrypted_password = @entry.read_attribute_before_type_cast(:password)

    assert_not_equal raw_password, encrypted_password
    assert encrypted_password.present?
  end

  test "should decrypt username correctly" do
    original_username = "testuser123"
    @entry.username = original_username
    @entry.save!

    # Reload and verify decryption
    @entry.reload
    assert_equal original_username, @entry.username
  end

  test "should decrypt password correctly" do
    original_password = "secretpass456"
    @entry.password = original_password
    @entry.save!

    # Reload and verify decryption
    @entry.reload
    assert_equal original_password, @entry.password
  end

  test "deterministic encryption allows duplicate usernames across entries" do
    entry1 = Entry.create!(
      name: "Service 1",
      url: "https://service1.com",
      username: "sameuser",
      password: "pass1",
      user: @user
    )

    entry2 = Entry.create!(
      name: "Service 2",
      url: "https://service2.com",
      username: "sameuser",
      password: "pass2",
      user: @user
    )

    assert_equal entry1.username, entry2.username
    assert_not_equal entry1.password, entry2.password
  end

  # Search functionality tests
  test "should respond to search class method" do
    assert_respond_to Entry, :search
  end

  test "should respond to search_name scope" do
    assert_respond_to Entry, :search_name
  end

  test "search should return entries matching name" do
    @entry.name = "GitHub Account"
    @entry.save!

    other_entry = Entry.create!(
      name: "GitLab Account",
      url: "https://gitlab.com",
      username: "user",
      password: "pass",
      user: @user
    )

    results = Entry.search("GitHub")
    assert_includes results, @entry
    assert_not_includes results, other_entry
  end

  test "search should be case insensitive" do
    @entry.name = "Facebook Account"
    @entry.save!

    results = Entry.search("facebook")
    assert_includes results, @entry

    results = Entry.search("FACEBOOK")
    assert_includes results, @entry
  end

  test "search should return partial matches" do
    @entry.name = "My Important Service"
    @entry.save!

    results = Entry.search("Important")
    assert_includes results, @entry

    results = Entry.search("Service")
    assert_includes results, @entry
  end

  test "search should return empty array for no matches" do
    @entry.save!

    results = Entry.search("nonexistent")
    assert_empty results
  end

  test "search should return all entries when search term is blank" do
    @entry.save!
    other_entry = Entry.create!(
      name: "Another Service",
      url: "https://other.com",
      username: "user",
      password: "pass",
      user: @user
    )

    results = Entry.search("")
    assert_includes results, @entry
    assert_includes results, other_entry

    results = Entry.search(nil)
    assert_includes results, @entry
    assert_includes results, other_entry
  end

  test "search should order results by name" do
    Entry.create!(
      name: "Zebra Service",
      url: "https://zebra.com",
      username: "user",
      password: "pass",
      user: @user
    )

    Entry.create!(
      name: "Apple Service",
      url: "https://apple.com",
      username: "user",
      password: "pass",
      user: @user
    )

    results = Entry.search("")
    names = results.map(&:name)
    assert_equal names.sort, names
  end

  # Edge cases and security tests
  test "should handle very long field values" do
    @entry.name = "a" * 1000
    @entry.username = "b" * 1000
    @entry.password = "c" * 1000

    assert @entry.valid?
    @entry.save!

    @entry.reload
    assert_equal "a" * 1000, @entry.name
    assert_equal "b" * 1000, @entry.username
    assert_equal "c" * 1000, @entry.password
  end

  test "should handle special characters in fields" do
    @entry.name = "Service with émojis 🔐 and spëcial chars"
    @entry.username = "user@domain.com"
    @entry.password = "p@ssw0rd!#$%^&*()"

    assert @entry.valid?
    @entry.save!

    @entry.reload
    assert_equal "Service with émojis 🔐 and spëcial chars", @entry.name
    assert_equal "user@domain.com", @entry.username
    assert_equal "p@ssw0rd!#$%^&*()", @entry.password
  end

  test "should not expose encrypted data in to_json" do
    @entry.save!
    json_data = @entry.to_json

    # Should not contain encrypted values
    assert_not_includes json_data, @entry.read_attribute_before_type_cast(:username)
    assert_not_includes json_data, @entry.read_attribute_before_type_cast(:password)

    # Should contain decrypted values
    assert_includes json_data, @entry.username
    assert_includes json_data, @entry.password
  end
end
