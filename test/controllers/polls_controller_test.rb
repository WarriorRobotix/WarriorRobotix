require 'test_helper'

class PollsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @poll = polls(:poll_to_member)
    sign_in_as_admin
  end

  test "should redirect Polls#index to Posts#index" do
    get polls_url
    assert_redirected_to posts_path
  end

  test "should get new" do
    get new_poll_url
    assert_response :success
  end

  test "should create poll" do
    assert_difference('Poll.count') do
      assert_difference('Option.count', 3) do
        post polls_url, params: {
          poll: {
            description: @poll.description,
            restriction: @poll.restriction,
            title: @poll.title,
            options_attributes: {
              '0' => { :description => 'Ruby' },
              '1' => { :description => 'Java' },
              '2' => { :description => 'C++'  }
            }
          }
        }
      end
    end

    assert_redirected_to poll_path(Poll.last)

  end

  test "should show poll" do
    get poll_url(@poll)
    assert_response :success
  end

  test "should get edit" do
    get edit_poll_url(@poll)
    assert_response :success
  end

  test "should update poll" do
    patch poll_url(@poll), params: { poll: { description: @poll.description, restriction: @poll.restriction, title: @poll.title } }
    assert_redirected_to poll_path(@poll)
  end

  test "should destroy poll and its options" do
    @poll.options.create! [{description: "Ruby"},{description: "Java"},{description: "Python"}]
    options_count = @poll.options.count
    
    assert_difference('Poll.count', -1) do
      assert_difference('Option.count',-options_count) do
        delete poll_url(@poll)
      end
    end

    assert_redirected_to posts_path
  end
end
