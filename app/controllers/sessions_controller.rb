class SessionsController < ApplicationController

  def new

  end
  def create

    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Sign the user in and redirect to the user's show page.

      sign_in user
      verified_and_insert_new_item_to_user user
      redirect_back_or user
      #redirect_to user



    else
      flash.now[:error] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end

  end

  def destroy
    sign_out
    redirect_to root_url
  end



  def create_facebook
    auth = env["omniauth.auth"]
    email = auth.extra.raw_info.email

    # if the user exist, check it is a facebook user
    if User.exists?(email:email)
      user = User.find_by_email(email)

      if user.uid.blank? then
      # this user is already on the system with room login
        flash.now[:error] = 'Invalid email/password combination' # Not quite right!
        render 'new'
      else
       # this user is on the system with facebook login (login fine)
        user = User.from_omniauth(env["omniauth.auth"])

        sign_in user
        verified_and_insert_new_item_to_user user
        redirect_back_or user
      end
    else
      #this user is new
      user = User.from_omniauth(env["omniauth.auth"])

      sign_in user
      redirect_back_or user

    end
  end

  def verified_and_insert_new_item_to_user(user)

        @items_locations = ItemsLocation.all

        @items_locations.each do |item_location|

          unless UsersItemsDesign.joins(:items_design).where('user_id = ? and items_designs.item_id =? and location_id = ?',user.id,item_location.item_id,item_location.location_id).exists?
            if ItemsDesign.exists?(item_id:item_location.item_id)
              @item_design = ItemsDesign.find_by_item_id(item_location.item_id)
              UsersItemsDesign.create(items_design_id:@item_design.id, user_id:user.id,hide:"no" ,location_id:item_location.location_id)
            end
          end
        end
  end
end
