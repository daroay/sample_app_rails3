require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
      get :new
      response.should have_selector('title', :content => 'Sign up')
    end
  end

  describe "GET 'show'" do
    before(:each) do
      @user = Factory(:user)
    end

    it "should be successful by name" do
      get :show, :name => @user.name
      response.should be_success
    end

    it "should find the right user by name" do
      get :show, :name => @user.name
      assigns(:user).should == @user
    end

    it "should have the right title" do
      get :show, :name => @user.name
      response.should have_selector("title", :content => @user.name)
    end

    it "should include the user's name" do
      get :show, :name => @user.name
      response.should have_selector("h1", :content => @user.name)
    end

    it "should have a profile image" do
      get :show, :name => @user.name
      response.should have_selector("h1>img", :class => "gravatar")
    end

  end

  describe "POST 'create'" do
    
		describe "failure" do
    
      before(:each) do
        @attr = {:name => "", :email => "", :password => "", 
                             :password_confirmation => ""}
      end

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign up")
      end
 
      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end
    describe 'success' do
    
      before(:each) do
        @attr = { :name => "NewUser", :email => "valid@email.com",
                :password => "validpass", :password_confirmation => "validpass"}
      end

      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to the user show page by the name" do
        post :create, :user => @attr
        response.should redirect_to("/#{assigns(:user).name}")
      end

      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to the sample app/i
      end

      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
    
    end
  end
end
