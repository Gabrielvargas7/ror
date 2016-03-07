require 'spec_helper'


  describe "Authentication" do

    subject { page }

    describe "signin page" do

      before { visit signin_path }

      xit { should have_selector('h1',    text: 'Sign in') }
      xit { should have_selector('title', text: 'Sign in') }
    end

    describe "signin" do
      before { visit signin_path }

      describe "with invalid information" do
        before {  click_button "Sign in" }

        xit { should have_selector('title', text: 'Sign in') }
        xit { should have_selector('div.alert.alert-error', text: 'Invalid') }

        describe "after visiting another page" do
          before { click_link "Home" }
          xit { should_not have_selector('div.alert.alert-error') }
        end
      end

      describe "with valid information" do
        let(:user) { FactoryGirl.create(:user) }
        before { sign_in user }

        xit { should have_selector('title', text: user.name) }

        xit { should have_link('Users',    href: users_path) }
        xit { should have_link('Profile',  href: user_path(user)) }
        xit { should have_link('Settings', href: edit_user_path(user)) }
        xit { should have_link('Sign out', href: signout_path) }

        xit { should_not have_link('Sign in', href: signin_path) }

        describe "followed by signout" do
          before { click_link "Sign out" }
          xit { should have_link('Sign in') }
        end
      end

    end


    describe "authorization" do

      describe "for non-signin-users" do
        let(:user) {FactoryGirl.create(:user)}

        describe "when attempting to visit a protected page" do
          before do
            visit edit_user_path(user)
            fill_in "Email",    with: user.email
            fill_in "Password", with: user.password
            click_button "Sign in"
          end
          describe "after signing in" do

            xit "should render the desired protected page" do
              page.should have_selector('title', text: 'Edit user')
            end
          end
        end


        describe "in the Users Controller" do

          describe "visiting the edit page" do
            before {visit edit_user_path(user)}
            xit{should have_selector('title',text: 'Sign in')}
          end

          describe "submitting to the update action" do
            before {put user_path(user)}
            xspecify{response.should redirect_to(signin_path)}

          end

          describe "visiting the user index" do
            before { visit users_path }
            xit { should have_selector('title', text: 'Sign in') }
          end

        end

      end

      describe "as wrong user" do
        let(:user) {FactoryGirl.create(:user) }
        let(:wrong_user) {FactoryGirl.create(:user, email:"wrong@exemple.com")}
        before{sign_in user}

        describe "visiting User #edit pages" do
          before {visit edit_user_path(wrong_user)}
          xit { should_not have_selector('title', text: full_title('Edit user')) }

          describe "submitting a PUT request to the User#update action" do
            before { put user_path(wrong_user) }
            xspecify { response.should redirect_to(root_path) }
          end
        end
      end


      describe "as non-admin user" do
        let(:user) { FactoryGirl.create(:user) }
        let(:non_admin) { FactoryGirl.create(:user) }

        before { sign_in non_admin }

        describe "submitting a DELETE request to the Users#destroy action" do
          before { delete user_path(user) }
          xspecify { response.should redirect_to(root_path) }
        end
      end


    end


end