require "test_helper"

class AccessTest < ActiveSupport::TestCase
  test "acesssed" do
    freeze_time

    assert_changes -> { accesses(:writebook_kevin).reload.accessed_at }, from: nil, to: Time.current do
      accesses(:writebook_kevin).accessed
    end

    travel 2.minutes

    assert_no_changes -> { accesses(:writebook_kevin).reload.accessed_at } do
      accesses(:writebook_kevin).accessed
    end
  end
end
