require "test_helper"

class SearchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    Card.all.each(&:reindex)
    Comment.all.each(&:reindex)

    sign_in_as :kevin
  end

  test "show" do
    get search_path(q: "broken")

    assert_select "li", text: /Layout is broken/
  end
end
