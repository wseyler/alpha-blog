require 'test_helper'

class CreateArticlesTest < ActionDispatch::IntegrationTest

  def setup
    @user = User.create(username: "John", email: "john@example.com", password: "password", admin: true)
  end

  test "get new category form and create category" do
    sign_in_as(@user, "password")
    get new_article_path
    assert_template 'articles/new'
    assert_difference 'Article.count', 1 do
      post articles_path, params:{ article:{title:"First Test Article", description: "Description of first test article"} }
      follow_redirect!
    end
    assert_template 'articles/show'
    assert_match "First Test Article", response.body
  end

  test "invalid category submission results in failure" do
    sign_in_as(@user, "password")
    get new_article_path
    assert_template 'articles/new'
    assert_no_difference 'Article.count' do
      post articles_path, params:{ article:{title:""} }
    end
    assert_template 'articles/new'
    assert_select "h2.card-title"
    assert_select "div.card-body"
  end
end
