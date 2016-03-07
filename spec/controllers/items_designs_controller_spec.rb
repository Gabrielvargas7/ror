require 'spec_helper'


describe ItemsDesignsController do

  before(:all){ create_init_data }
  after(:all){ delete_init_data }

  before  do

    @item = FactoryGirl.create(:item)
    @items_design = FactoryGirl.create(:items_design,item_id:@item.id)
    @admin = FactoryGirl.create(:admin)
    sign_in @admin
  end


  #the (subject)line declare the variable that is use in all the test
  subject { @items_design }


  #***********************************
  # rspec test  index
  #***********************************

  describe "GET index",tag_index:true do

    context "is admin user" do
      let(:items_design_all) { ItemsDesign.all }

      it "assigns all items_design as @items_design" do
        get :index
        assigns(:items_designs).should eq(items_design_all)
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


  #
  ##***********************************
  ## rspec test  show
  ##***********************************


  describe "GET show", tag_show:true do

    context "is admin user" do

      it "assigns the requested items designs as @items designs" do
        get :show, id: @items_design
        assigns(:items_design).should eq(@items_design)

      end

      it "renders the #show view" do

        get :show, id: @items_design
        response.should render_template :show
      end

    end

    context "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirect to root " do
        get :show, id:@items_design
        response.should redirect_to root_path
      end

      it "not render to show " do
        get :show, id:@items_design
        response.should_not render_template :show
      end

    end

  end

  #***********************************
  # rspec test  new
  #***********************************

  describe "GET new",tag_new:true do

    context "is admin user"  do
      it "assigns a new items designs as @items designs" do
        @item = FactoryGirl.create(:item)
        new_items_design = FactoryGirl.create(:items_design,item_id:@item.id)
        ItemsDesign.should_receive(:new).and_return(new_items_design)
        get :new
        assigns[:items_design].should eq(new_items_design)
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

      it "assigns the requested item design as @item design" do
        @item = FactoryGirl.create(:item)
        new_items_design = FactoryGirl.create(:items_design,item_id:@item.id)
        get :edit, id: new_items_design
        assigns[:items_design].should eq(new_items_design)
      end
    end

    context "is not admin user" do

      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user

      end

      it "redirect to root " do
        @item = FactoryGirl.create(:item)
        new_items_design = FactoryGirl.create(:items_design,item_id:@item.id)
        get :edit, id: new_items_design
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

        it "creates a new Items design" do

          expect {
            post :create,items_design: FactoryGirl.attributes_for(:items_design,item_id:@item.id)
          }.to change(ItemsDesign, :count).by(1)


        end

        it "assigns a newly created items design as @item design" do
          post :create,items_design: FactoryGirl.attributes_for(:items_design,item_id:@item.id)
          assigns(:items_design).should be_a(ItemsDesign)
          assigns(:items_design).should be_persisted
        end

        it "redirects to the created items design" do

          post :create,items_design: FactoryGirl.attributes_for(:items_design,item_id:@item.id)
          response.should redirect_to(ItemsDesign.last)
        end
      end

      context "with invalid params" do

        context "with invalid attributes" do
          it "does not save the new contact" do
            expect{ post :create,items_design: FactoryGirl.attributes_for(:items_design,item_id:nil)
            }.to_not change(ItemsDesign,:count)
          end
          it "re-renders the new method" do
            post :create,items_design: FactoryGirl.attributes_for(:items_design,item_id:nil)
            response.should render_template :new
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
        post :create,items_design: FactoryGirl.attributes_for(:items_design,item_id:@item.id)
        response.should redirect_to(root_path)
      end
      it "not redirects to the created items design" do
        post :create,items_design: FactoryGirl.attributes_for(:items_design,item_id:@item.id)
        response.should_not redirect_to(ItemsDesign.last)
      end
    end

  end

  #***********************************
  # rspec test  update
  #***********************************


  describe "PUT update", tag_update:true do

    describe "is admin user" do

      context "valid attributes" do
        it "located the requested @items design" do

          @item = FactoryGirl.create(:item)
          put :update,id:@items_design,items_design: FactoryGirl.attributes_for(:items_design,item_id:@item.id)

          assigns(:items_design).should eq(@items_design)
        end
      end

      it "changes @items designs attributes" do
        put :update,id:@items_design,items_design: FactoryGirl.attributes_for(:items_design,item_id:@item.id,name:"new items desc",description:"new desc")
        @items_design.reload
        @items_design.name.should eq("new items desc")
        @items_design.description.should eq("new desc")
      end

      it "redirects to the updated items design" do
        put :update,id:@items_design,items_design: FactoryGirl.attributes_for(:items_design,item_id:@item.id,name:"new items desc",description:"new desc")
        response.should redirect_to @items_design
      end

      context "invalid attributes" do

        it "locates the requested @items design" do
          put :update,id:@items_design,items_design: FactoryGirl.attributes_for(:items_design,item_id:nil,name:"new items desc",description:"new desc")
          assigns(:items_design).should eq(@items_design)
        end
        it "does not change @items design's attributes" do
          put :update,id:@items_design,items_design: FactoryGirl.attributes_for(:items_design,item_id:nil,name:"new items desc",description:"new desc")
          @items_design.reload
          @items_design.name.should_not eq("new items desc")
          @items_design.description.should_not eq("new desc")
        end
        it "re-renders the edit method" do
          put :update,id:@items_design,items_design: FactoryGirl.attributes_for(:items_design,item_id:nil,name:"new items desc",description:"new desc")
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
        put :update,id:@items_design,items_design: FactoryGirl.attributes_for(:items_design,item_id:@item.id,name:"new items desc",description:"new desc")
        response.should redirect_to root_path
      end
    end

  end

  ##***********************************
  ## rspec test  #json_index_items_designs_by_item_id
  ##***********************************
  #     @items_designs = ItemsDesign.where('item_id=?',params[:item_id]).order("id")
  # /items_designs/json/index_items_designs_by_item_id/1.json
  #
  describe "api #json_index_items_designs_by_item_id",tag_json_index:true do

    describe "is public api" do
      before do
        sign_out
      end


      it "should be successful" do
        get :json_index_items_designs_by_item_id,item_id: @item.id, :format => :json
        response.should be_success
      end

      let(:items_design_all){ItemsDesign.where('item_id=?',@item.id).order("id")}
      it "should set item design" do
        get :json_index_items_designs_by_item_id,item_id: @item.id, :format => :json
        assigns(:items_designs).as_json.should == items_design_all.as_json
      end

      it "has a 200 status code" do
        get :json_index_items_designs_by_item_id,item_id: @item.id, :format => :json
        expect(response.status).to eq(200)
      end

      context "get all values " do
        it "should return json_index items designs  in json" do # depend on what you return in action
          get :json_index_items_designs_by_item_id,item_id: @item.id, :format => :json
          body = JSON.parse(response.body)
          #puts "body ---- > "+body.to_s
          #puts "theme ----> "+@theme.as_json.to_s
          #puts "body name ----> " + body[0]["name"].to_s
          #puts "body image name ----> " + body[0]["image_name"]["url"].to_s
          #puts "theme name----> "+@theme.name.to_s
          #puts "theme image name----> "+@theme.image_name.to_s

          #:description, :image_name, :item_id, :name,:image_name_hover,:image_name_selection

          body.each do |body_items_design|
            @items_design_json = ItemsDesign.find(body_items_design["id"])
            body_items_design["name"].should == @items_design_json.name
            body_items_design["description"].should == @items_design_json.description
            body_items_design["id"].should == @items_design_json.id
            body_items_design["image_name"]["url"].should == @items_design_json.image_name.to_s
            body_items_design["image_name_selection"]["url"].should == @items_design_json.image_name_selection.to_s
            body_items_design["image_name_hover"]["url"].should == @items_design_json.image_name_hover.to_s
            body_items_design["item_id"].should == @items_design_json.item_id
            body_items_design["category"].should == @items_design_json.category
            body_items_design["style"].should == @items_design_json.style
            body_items_design["brand"].should == @items_design_json.brand
            body_items_design["color"].should == @items_design_json.color
            body_items_design["make"].should == @items_design_json.make
            body_items_design["special_name"].should == @items_design_json.special_name
            body_items_design["like"].should == @items_design_json.like
            body_items_design["price"].should == @items_design_json.price.to_s
            body_items_design["product_url"].should == @items_design_json.product_url

          end
        end
      end
    end
  end


  #***********************************
  # rspec test  #json_index_items_designs_categories_by_item_id
  #***********************************

  describe "api #json_index_items_designs_categories_by_item_id",tag_json_category:true do


    describe "is public api" do
      before do
        sign_out

        @item = FactoryGirl.create(:item)
        FactoryGirl.create(:items_design,item_id:@item.id,
                           category:"furniture",style:"modern",brand:"nike",color:"green",make:"wood")
        FactoryGirl.create(:items_design,item_id:@item.id,
                           category:"electronics",style:"easter",brand:"prada",color:"red",make:"leather")
      end

      it "should be successful" do
        get :json_index_items_designs_categories_by_item_id,item_id:@item.id, :format => :json
        response.should be_success
      end

      it "has a 200 status code" do
        get :json_index_items_designs_categories_by_item_id,item_id:@item.id, :format => :json
        expect(response.status).to eq(200)
      end

      context "get all values " do

        it "should return json_index_bundles_categories" do # depend on what you return in action
          get :json_index_items_designs_categories_by_item_id,item_id:@item.id, :format => :json
          body = JSON.parse(response.body)
          #puts body.as_json
          puts body["category"]
          #puts @the

          body["items_designs_categories"].each do |body_b|
            @items_designs_json = ItemsDesign.find_all_by_category(body_b["category"]).first()
            body_b["category"].should == @items_designs_json.category
            #puts body_theme["category"]
          end

          body["items_designs_brands"].each do |body_b|
            @items_designs_json = ItemsDesign.find_all_by_brand(body_b["brand"]).first()
            body_b["brand"].should == @items_designs_json.brand
            #puts body_theme["brand"]
          end

          body["items_designs_styles"].each do |body_b|
            @items_designs_json = ItemsDesign.find_all_by_style(body_b["style"]).first()
            body_b["style"].should == @items_designs_json.style
            #puts body_theme["style"]
          end

          body["items_designs_colors"].each do |body_b|
            @items_designs_json = ItemsDesign.find_all_by_color(body_b["color"]).first()
            body_b["color"].should == @items_designs_json.color
            #puts body_theme["color"]
          end

          body["items_designs_makes"].each do |body_b|
            @items_designs_json = ItemsDesign.find_all_by_make(body_b["make"]).first()
            body_b["make"].should == @items_designs_json.make
            #puts body_theme["make"]
          end



        end
      end
    end
  end


  #***********************************
  # rspec test  #json_index_items_designs_filter_by_category_by_item_id_by_keyword_and_limit_and_offset
  #***********************************


  describe "api #json_index_bundles_filter_by_category_by_keyword_and_limit_and_offset",tag_json_index:true do

    describe "is public api" do
      before do
        sign_out
        @category = "category"
        @keyword = "electronics"
        @limit = 4
        @offset = 0


        @item = FactoryGirl.create(:item)
        FactoryGirl.create(:items_design,item_id:@item.id,
                           category:"furniture",style:"modern",brand:"nike",color:"green",make:"wood")

        FactoryGirl.create(:items_design,item_id:@item.id,
                           category:"electronics",style:"easter",brand:"prada",color:"red",make:"leather")

        FactoryGirl.create(:items_design,item_id:@item.id,
                           category:"electronics",style:"easter",brand:"prada",color:"red",make:"leather")


      end


      it "should be successful" do
        get :json_index_items_designs_filter_by_category_by_item_id_by_keyword_and_limit_and_offset,item_id:@item.id, category:@category,keyword:@keyword,limit:@limit,offset:@offset, :format => :json
        response.should be_success
      end


      it "has a 200 status code" do
        get :json_index_items_designs_filter_by_category_by_item_id_by_keyword_and_limit_and_offset,item_id:@item.id, category:@category,keyword:@keyword,limit:@limit,offset:@offset, :format => :json
        expect(response.status).to eq(200)
      end

      context "get all values " do
        it "json_index_items_designs_filter_by_category_by_item_id_by_keyword_and_limit_and_offset" do # depend on what you return in action
          get :json_index_items_designs_filter_by_category_by_item_id_by_keyword_and_limit_and_offset,item_id:@item.id, category:@category,keyword:@keyword,limit:@limit,offset:@offset, :format => :json
          body = JSON.parse(response.body)
          #puts "body ---- > "+body.to_s
          #puts "theme ----> "+@theme.as_json.to_s
          #puts "body name ----> " + body[0]["name"].to_s
          #puts "body image name ----> " + body[0]["image_name"]["url"].to_s
          #puts "theme name----> "+@theme.name.to_s
          #puts "theme image name----> "+@theme.image_name.to_s

          body.each do |body_b|
            @b_json = ItemsDesign.find(body_b["id"])
            body_b["name"].should == @b_json.name
            body_b["description"].should == @b_json.description
            body_b["id"].should == @b_json.id
            body_b["image_name"]["url"].should == @b_json.image_name.to_s
            body_b["image_name_hover"]["url"].should == @b_json.image_name_hover.to_s
            body_b["category"].should == @b_json.category
            body_b["style"].should == @b_json.style
            body_b["brand"].should == @b_json.brand
            body_b["color"].should == @b_json.color
            body_b["make"].should == @b_json.make
            body_b["special_name"].should == @b_json.special_name
            body_b["like"].should == @b_json.like


          end
        end
      end
    end
  end


  describe "api #json_index_items_designs_filter_by_category_by_item_id_by_keyword_and_limit_and_offset",tag_json_category:true do
    pending "pending test api"
  end

  describe "api #json_index_items_designs_categories_by_item_id",tag_json_category:true do
    pending "pending test api"
  end



end
