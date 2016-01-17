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


  test "should vote for an option" do
    assert_difference "Ballot.count" do
      post poll_vote_path(@poll), params: { vote: options(:one_p1).id }
    end
    assert_response :success
  end

  test "should vote for multiple options of a multiple choices poll" do
    assert_difference "Ballot.count", 2 do
      post poll_vote_path(polls(:multi_poll_to_member)), params: { vote: { options(:one_p3).id.to_s => '1', options(:two_p3).id.to_s => '1' } }
    end
    assert_response :success
  end

  test "should overwrite vote for multiple options of a multiple choices poll" do
    assert_difference "Ballot.count" , 1 do
      post poll_vote_path(polls(:multi_poll_to_member)), params: { vote: { options(:one_p3).id.to_s => '1' } }
      assert_response :success
    end

    assert_no_difference "Ballot.count" do
      post poll_vote_path(polls(:multi_poll_to_member)), params: { vote: { options(:two_p3).id.to_s => '1' } }
      assert_response :success
    end
  end

  test "member shouldn't be able to vote an admin poll" do
    sign_out
    sign_in_as_member

    assert_raises Forbidden do
      post poll_vote_path(polls(:poll_to_admin)), params: { vote: { options(:one_p2).id.to_s => '1' } }
    end
  end

end
