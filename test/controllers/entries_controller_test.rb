require "test_helper"

class EntriesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:one)
    @other_user = users(:two)

    @entry = @user.entries.create!(
      name: "Test Entry",
      url: "https://test.com",
      username: "testuser",
      password: "testpass"
    )

    @other_entry = @other_user.entries.create!(
      name: "Other Entry",
      url: "https://other.com",
      username: "otheruser",
      password: "otherpass"
    )

    sign_in @user
  end

  test "should redirect to login when not authenticated" do
    sign_out @user

    get entries_path
    assert_redirected_to new_user_session_path

    get entry_path(@entry)
    assert_redirected_to new_user_session_path

    get new_entry_path
    assert_redirected_to new_user_session_path

    get edit_entry_path(@entry)
    assert_redirected_to new_user_session_path

    post entries_path, params: { entry: { name: "Test", username: "test", password: "test" } }
    assert_redirected_to new_user_session_path

    patch entry_path(@entry), params: { entry: { name: "Updated" } }
    assert_redirected_to new_user_session_path

    delete entry_path(@entry)
    assert_redirected_to new_user_session_path
  end

  test "should not allow access to other users entries" do
    get entry_path(@other_entry)
    assert_response :not_found

    get edit_entry_path(@other_entry)
    assert_response :not_found

    patch entry_path(@other_entry), params: { entry: { name: "Hacked" } }
    assert_response :not_found

    delete entry_path(@other_entry)
    assert_response :not_found
  end

  test "should get index" do
    get entries_path
    assert_response :success
  end

  test "should handle search on index" do
    get entries_path, params: { name: "Test" }
    assert_response :success
    # Modern Rails testing focuses on response rather than instance variables
    assert_match "Test Entry", response.body
  end

  test "should return turbo stream for single search result" do
    @user.entries.create!(
      name: "UniqueTestEntry",
      url: "https://unique.com",
      username: "unique",
      password: "unique"
    )

    get entries_path, params: { name: "UniqueTestEntry" }
    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type
  end

  test "should handle empty search results" do
    get entries_path, params: { name: "nonexistent" }
    assert_response :success
    # No specific content expected for empty results
  end

  test "should get new" do
    get new_entry_path
    assert_response :success
    # Test that the form is present instead of checking instance variables
    assert_match "form", response.body
  end

  test "should show entry" do
    get entry_path(@entry)
    assert_response :success
    # Test that the entry content is displayed
    assert_match @entry.name, response.body
  end

  test "should create entry with valid params" do
    entry_params = {
      name: "New Test Entry",
      url: "https://newtest.com",
      username: "newuser",
      password: "newpass"
    }

    assert_difference("Entry.count") do
      post entries_path, params: { entry: entry_params }
    end

    created_entry = Entry.last
    assert_equal @user, created_entry.user
    assert_equal entry_params[:name], created_entry.name
    assert_equal entry_params[:url], created_entry.url
    assert_equal entry_params[:username], created_entry.username
    assert_equal entry_params[:password], created_entry.password
  end

  test "should redirect to root after successful create" do
    entry_params = {
      name: "New Test Entry",
      url: "https://newtest.com",
      username: "newuser",
      password: "newpass"
    }

    post entries_path, params: { entry: entry_params }
    assert_redirected_to root_path
    assert_match /New Test Entry has been saved/, flash[:notice]
  end

  test "should return turbo stream on successful create" do
    entry_params = {
      name: "New Test Entry",
      url: "https://newtest.com",
      username: "newuser",
      password: "newpass"
    }

    post entries_path, params: { entry: entry_params }, headers: { "Accept" => "text/vnd.turbo-stream.html" }
    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type
  end

  test "should not create entry with invalid params" do
    invalid_params = {
      name: "",
      username: "user",
      password: "pass"
    }

    assert_no_difference("Entry.count") do
      post entries_path, params: { entry: invalid_params }
    end

    assert_response :unprocessable_content
    # Test that error is displayed in response instead of checking instance variables
    assert_match "can&#39;t be blank", response.body
  end

  test "should render new template on create failure" do
    invalid_params = {
      name: "",
      username: "user",
      password: "pass"
    }

    post entries_path, params: { entry: invalid_params }
    assert_response :unprocessable_content
    # Test that the new form is rendered again instead of using assert_template
    assert_match "form", response.body
  end

  test "should get edit" do
    get edit_entry_path(@entry)
    assert_response :success
    # Test that the edit form is displayed
    assert_match "form", response.body
  end


  test "should update entry with valid params" do
    new_name = "Updated Entry Name"
    new_url = "https://updated.com"

    patch entry_path(@entry), params: {
      entry: {
        name: new_name,
        url: new_url,
        username: @entry.username,
        password: @entry.password
      }
    }

    @entry.reload
    assert_equal new_name, @entry.name
    assert_equal new_url, @entry.url
  end

  test "should redirect to entry after successful update" do
    patch entry_path(@entry), params: {
      entry: {
        name: "Updated Name",
        url: @entry.url,
        username: @entry.username,
        password: @entry.password
      }
    }

    assert_redirected_to @entry
    assert_match /Updated Name has been updated/, flash[:notice]
  end

  test "should return turbo stream on successful update" do
    patch entry_path(@entry), params: {
      entry: {
        name: "Updated Name",
        url: @entry.url,
        username: @entry.username,
        password: @entry.password
      }
    }, headers: { "Accept" => "text/vnd.turbo-stream.html" }

    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type
  end

  test "should not update entry with invalid params" do
    original_name = @entry.name

    patch entry_path(@entry), params: {
      entry: {
        name: "",
        url: @entry.url,
        username: @entry.username,
        password: @entry.password
      }
    }

    assert_response :unprocessable_content
    @entry.reload
    assert_equal original_name, @entry.name
    # Test that the form shows validation errors (input has error class)
    assert_match "input-with-errors", response.body
  end

  test "should render edit template on update failure" do
    patch entry_path(@entry), params: {
      entry: {
        name: "",
        url: @entry.url,
        username: @entry.username,
        password: @entry.password
      }
    }

    assert_response :unprocessable_content
    # Test that the edit form is rendered again
    assert_match "form", response.body
  end

  test "should destroy entry" do
    assert_difference("Entry.count", -1) do
      delete entry_path(@entry)
    end
  end

  test "should redirect to root after destroy" do
    entry_name = @entry.name
    delete entry_path(@entry)

    assert_redirected_to root_path
    assert_match /#{entry_name} has been deleted/, flash[:notice]
  end


  test "should only permit allowed entry parameters" do
    patch entry_path(@entry), params: {
      entry: {
        name: "Updated Name",
        url: @entry.url,
        username: @entry.username,
        password: @entry.password,
        user_id: @other_user.id,
        created_at: 1.year.ago
      }
    }

    @entry.reload
    assert_equal "Updated Name", @entry.name
    assert_equal @user.id, @entry.user_id
    assert_not_equal 1.year.ago.to_date, @entry.created_at.to_date
  end

  test "should associate entry with current user on create" do
    entry_params = {
      name: "Security Test Entry",
      url: "https://security.com",
      username: "secureuser",
      password: "securepass"
    }

    post entries_path, params: { entry: entry_params }

    created_entry = Entry.last
    assert_equal @user, created_entry.user
  end

  test "should not allow changing entry owner through update" do
    original_user_id = @entry.user_id

    patch entry_path(@entry), params: {
      entry: {
        name: @entry.name,
        user_id: @other_user.id
      }
    }

    @entry.reload
    assert_equal original_user_id, @entry.user_id
  end

  test "should handle missing entry gracefully" do
    get entry_path(99999)
    assert_response :not_found
  end

  test "should handle malformed parameters gracefully" do
    post entries_path, params: { invalid: "data" }
    assert_response :bad_request
  end

  test "should handle empty search parameter" do
    get entries_path, params: { name: "" }
    assert_response :success
    # Empty search should still return a valid page
  end

  test "should set appropriate flash messages" do
    post entries_path, params: {
      entry: {
        name: "Flash Test Entry",
        url: "https://flash.com",
        username: "flashuser",
        password: "flashpass"
      }
    }
    assert_match /Flash Test Entry has been saved/, flash[:notice]

    patch entry_path(@entry), params: {
      entry: {
        name: "Updated Flash Entry",
        url: @entry.url,
        username: @entry.username,
        password: @entry.password
      }
    }
    assert_match /Updated Flash Entry has been updated/, flash[:notice]

    delete entry_path(@entry)
    assert_match /Updated Flash Entry has been deleted/, flash[:notice]
  end

  test "should only load current user entries" do
    get entries_path, params: { name: "Test" }
    assert_response :success
    # Test that user's entry is displayed
    assert_match @entry.name, response.body
    # Test that other user's entry is not displayed
    assert_no_match @other_entry.name, response.body
  end

  test "should maintain data integrity across operations" do
    original_count = Entry.count
    user_entries_count = @user.entries.count

    post entries_path, params: {
      entry: {
        name: "Integrity Test",
        url: "https://integrity.com",
        username: "integrityuser",
        password: "integritypass"
      }
    }

    assert_equal original_count + 1, Entry.count
    assert_equal user_entries_count + 1, @user.entries.count

    new_entry = Entry.last
    patch entry_path(new_entry), params: {
      entry: {
        name: "Updated Integrity Test",
        url: new_entry.url,
        username: new_entry.username,
        password: new_entry.password
      }
    }

    new_entry.reload
    assert_equal "Updated Integrity Test", new_entry.name
    assert_equal @user.id, new_entry.user_id

    delete entry_path(new_entry)

    assert_equal original_count, Entry.count
    assert_equal user_entries_count, @user.entries.count
  end
end
