require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:event_to_member)
    sign_in_as_admin
  end

  test "should redirect Events#index to Posts#index" do
    get events_url
    assert_redirected_to posts_path
  end

  test "should get new" do
    get new_event_url
    assert_response :success
  end

  test "should create event" do
    assert_difference('Event.count') do
      post events_url, params: {
        event: {
          description: @event.description,
          restriction: @event.restriction,
          title: @event.title,
          start_at: {
            date: @event.start_at.to_date.to_s,
            hour: @event.start_at.strftime('%H'),
            minute: @event.start_at.strftime('%M')
          },
          end_at: {
            date: @event.end_at.to_date.to_s,
            hour: @event.end_at.strftime('%H'),
            minute: @event.end_at.strftime('%M')
          }
        }
      }
    end

    assert_redirected_to event_path(Event.last)
  end

  test "should show event" do
    get event_url(@event)
    assert_response :success
  end

  test "should get edit" do
    get edit_event_url(@event)
    assert_response :success
  end

  test "should update event" do
    patch event_url(@event), params: { event: { description: @event.description, restriction: @event.restriction, title: @event.title } }
    assert_redirected_to event_path(@event)
  end

  test "should destroy event" do
    assert_difference('Event.count', -1) do
      delete event_url(@event)
    end

    assert_redirected_to posts_path
  end
end
