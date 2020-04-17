require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  before(:each) do
    # @user = FactoryBot.create(:user) # Create the user
    @user = FactoryBot.create(:admin) # Create the user
    @article = FactoryBot.create(:article) # Create the user

    # Set up the basic premise of the test by making sure that you have to log in
    visit root_path
    expect(current_path).to eq(new_user_session_path)
    expect(current_path).to_not eq(root_path)

    # Within the form #new_user do the following
    # The reason I put this within a within block is so if there are 2 form fields
    # on the page called Email it will fill in only this one
    within('#new_user') do
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log in'
    end

    # Since we've logged in we should check if the application redirected us to the right path
    expect(current_path).to eq(root_path)
    expect(current_path).to_not eq(new_user_session_path)
    expect(page).to have_content('Signed in successfully.')
  end

  describe 'GET #index' do
    describe 'valid: ' do
      it 'should return a list of comments' do
        @comment = FactoryBot.create(:comment)
        click_link 'Comments'
        expect(current_path).to eq(comments_path)

        expect(page).to have_content(@comment.message)
        # save_and_open_page
      end
    end

    describe 'invalid: ' do
    end
  end

  describe 'GET #show' do
    describe 'valid: ' do
      it 'should return a comment' do
        @comment = FactoryBot.create(:comment)
        click_link 'Comments'
        expect(current_path).to eq(comments_path)

        expect(page).to have_content(@comment.message)

        click_link 'Show'
        expect(current_path).to eq(comment_path(@comment))
        # redirect_to @comment
        expect(page).to have_content(@comment.message)
        # save_and_open_page
      end
    end

    describe 'invalid: ' do
      it 'should not return a comment if one does not exist' do
        visit comment_path(99_999)
        expect(current_path).to eq(comments_path)
        expect(page).to have_content('Comment Not Found')
        # save_and_open_page
      end
    end
  end

  describe 'GET #new' do
    describe 'valid: ' do
      it 'should create a new comment with valid attributes' do
        click_link 'Comments'
        expect(current_path).to eq(comments_path)

        click_link 'New Comment'
        expect(current_path).to eq(new_comment_path)

        fill_in 'comment_message', with: 'New_Comment'
        select @user.email, from: 'comment[user_id]'
        select @article.title, from: 'comment[article_id]'
        click_button 'Create Comment'
        # save_and_open_page
        expect(page).to have_content('Comment was successfully created.')
        expect(page).to have_content('New_Comment')
        # expect(page).to have_content('New_content_with_a_lot_of_typing')
      end
    end

    describe 'invalid: ' do
      it 'should not create a new comment with invalid attributes' do
        click_link 'Comments'
        expect(current_path).to eq(comments_path)

        click_link 'New Comment'
        expect(current_path).to eq(new_comment_path)

        fill_in 'comment_message', with: ''
        select @user.email, from: 'comment[user_id]'
        select @article.title, from: 'comment[article_id]'
        click_button 'Create Comment'
        # save_and_open_page
        expect(page).to have_content("Message can't be blank")
      end
    end
  end

  describe 'GET #edit' do
    describe 'valid: ' do
      it 'should update a comment with valid attributes' do
        @comment = FactoryBot.create(:comment)
        click_link 'Comments'
        expect(current_path).to eq(comments_path)

        expect(page).to have_content(@comment.message)

        click_link 'Show'
        expect(current_path).to eq(comment_path(@comment))

        expect(page).to have_content(@comment.message)

        @new_user = FactoryBot.create(:user)
        @new_article = FactoryBot.create(:article)

        click_link 'Edit'
        expect(current_path).to eq(edit_comment_path(@comment))

        fill_in 'comment_message', with: 'Edited_Comment_Message'
        select @new_user.email, from: 'comment[user_id]'
        select @new_article.title, from: 'comment[article_id]'
        click_button 'Update Comment'

        expect(page).to have_content('Comment was successfully updated.')
        expect(page).to have_content('Edited_Comment_Message')
        # expect(page).to have_content('New_New_Comment_Message')
        expect(page).to have_content(@new_user.email)
        expect(page).to have_content(@new_article.title)
        expect(current_path).to eq(comment_path(@comment))
        # save_and_open_page
      end
    end

    describe 'invalid: ' do
      it 'should not update a comment with invalid attributes' do
        @comment = FactoryBot.create(:comment)
        click_link 'Comments'
        expect(current_path).to eq(comments_path)

        expect(page).to have_content(@comment.message)

        click_link 'Show'
        expect(current_path).to eq(comment_path(@comment))

        expect(page).to have_content(@comment.message)

        click_link 'Edit'
        expect(current_path).to eq(edit_comment_path(@comment))

        fill_in 'comment_message', with: ''
        click_button 'Update Comment'

        expect(page).to have_content("Message can't be blank")
        # save_and_open_page
      end
    end
  end

  describe 'DELETE #destroy' do
    describe 'valid: ' do
      it 'should destroy a comment when destroy is clicked' do
        @comment = FactoryBot.create(:comment)
        click_link 'Comments'
        expect(current_path).to eq(comments_path)

        expect(page).to have_content(@comment.message)
        click_link 'Destroy'

        expect(current_path).to eq(comments_path)
        expect(page).to have_content('Comment was successfully destroyed.')
      end
    end
  end
end