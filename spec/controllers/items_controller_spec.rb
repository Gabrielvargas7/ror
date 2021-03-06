require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe ItemsController do

  # This should return the minimal set of attributes required to create a valid
  # Item. As you add validations to Item, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ItemsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  #the (before) line will instance the variable for every (describe methods)

  before(:all){ create_init_data }
  after(:all){ delete_init_data }

  before  do
    @item = FactoryGirl.create(:item)
    @admin = FactoryGirl.create(:admin)
    sign_in @admin
    #puts "Admin user signin cookie: "+cookies[:remember_token].to_s
  end


  #the (subject)line declare the variable that is use in all the test
  subject { @item }


  #***********************************
  # rspec test  index
  #***********************************

  describe "GET index",tag_index:true do

    context "is admin user" do
      let(:item_all) { Item.order(:priority_order,:name).all }

      it "assigns all items as @item" do
        get :index
        assigns(:items).should eq(item_all)
      end

      it "renders the :index view" do
        get :index
        response.should render_template :index
      end
    end
    context "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirect to root " do
        get :index
        response.should redirect_to root_path
      end

      it "not render to index " do
        get :index
        response.should_not render_template :index
      end
    end

  end

  #***********************************
  # rspec test  show
  #***********************************

  describe "GET show", tag_show:true do

    context "is admin user" do

      it "assigns the requested item as @item" do
        get :show, id: @item
        assigns(:item).should eq(@item)

      end

      it "renders the #show view" do

        get :show, id: @item
        response.should render_template :show
      end

    end

    context "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirect to root " do
        get :show, id:@item
        response.should redirect_to root_path
      end

      it "not render to show " do
        get :show, id:@item
        response.should_not render_template :show
      end

    end

  end

  #***********************************
  # rspec test  new
  #***********************************

  describe "GET new",tag_new:true do

    context "is admin user"  do
      it "assigns a new item as @item" do

        new_item = FactoryGirl.create(:item)
        Item.should_receive(:new).and_return(new_item)
        get :new
        assigns[:item].should eq(new_item)
      end
    end
    context "is not admin user"  do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirect to root" do
        get :new
        response.should redirect_to root_path
      end
    end

  end

  #***********************************
  # rspec test  edit
  #***********************************


  describe "GET edit", tag_edit:true do

    context "is admin user"  do

      it "assigns the requested item as @item" do

        new_item = FactoryGirl.create(:item)
        get :edit, id: new_item
        assigns[:item].should eq(new_item)
      end
    end

    context "is not admin user" do

      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user

      end

      it "redirect to root " do
        new_item = FactoryGirl.create(:item)
        get :edit, id: new_item
        response.should redirect_to root_path
      end
    end
  end

  #***********************************
  # rspec test create
  #***********************************


  describe "POST create", tag_create:true  do

    describe "is admin user" do
      context "with valid params" do

        it "creates a new item" do

          expect {
            post :create,item: FactoryGirl.attributes_for(:item)
          }.to change(Item, :count).by(1)


        end

        it "assigns a newly created item as @item" do
          post :create,item: FactoryGirl.attributes_for(:item)
          assigns(:item).should be_a(Item)
          assigns(:item).should be_persisted
        end

        it "redirects to the created item" do
          post :create, item: FactoryGirl.attributes_for(:item)
          response.should redirect_to(Item.last)
        end
      end

      context "with invalid params" do

        context "with invalid attributes" do
          it "does not save the new contact" do
            expect{ post :create, item: FactoryGirl.attributes_for(:item,clickable:nil)
            }.to_not change(Item,:count)
          end
        end

      end

    end



      describe "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirects to root" do
        post :create, item: FactoryGirl.attributes_for(:item)
        response.should redirect_to(root_path)
      end
      it "not redirects to the created themes" do
        post :create, item: FactoryGirl.attributes_for(:item)
        response.should_not redirect_to(Item.last)
      end
    end


  end

  #***********************************
  # rspec test  update
  #***********************************


  describe "PUT update", tag_update:true do

    describe "is admin user" do

      context "valid attributes" do
        it "located the requested @item" do
          put :update, id: @item, item: FactoryGirl.attributes_for(:item)
          assigns(:item).should eq(@item)
        end
      end

      it "changes @item's attributes" do
        put :update, id: @item, item: FactoryGirl.attributes_for(:item, name: "my new item", clickable: "no")
        @item.reload
        @item.name.should eq("my new item")
        @item.clickable.should eq("no")
      end

      it "redirects to the updated item" do
        put :update, id: @item, item: FactoryGirl.attributes_for(:item)
        response.should redirect_to @item
      end

      context "invalid attributes" do

        it "locates the requested @item" do
          put :update, id: @item, item: FactoryGirl.attributes_for(:item,clickable:nil)
          assigns(:item).should eq(@item)
        end
        it "does not change @item's attributes" do
          put :update, id: @item, item: FactoryGirl.attributes_for(:item, name:"my new item", clickable: "other")
          @item.reload
          @item.name.should_not eq("my new item")
          @item.clickable.should_not eq("other")
        end
        it "re-renders the edit method" do
          put :update, id: @item, item: FactoryGirl.attributes_for(:item,clickable:nil)
          response.should render_template :edit
        end
      end
    end

    describe "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirects to root " do
        put :update, id: @item, item: FactoryGirl.attributes_for(:item)
        response.should redirect_to root_path
      end
    end
  end



end
