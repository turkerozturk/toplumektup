=begin
/***********************************************************************
 * Copyright 2023 Turker Ozturk
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ***********************************************************************/
=end


class SessionsController < ApplicationController

skip_before_filter :authorize_access #, :only => :new # bu sayede sadece bu controllerin new sayfasının authenticationdan etkilenmemesini sağlamış olduk.

# basla http://madkingsmusings.blogspot.com/2011/05/session-timeouts-on-rails.html
  skip_before_filter :session_expiry
  skip_before_filter :update_activity_time
# bit http://madkingsmusings.blogspot.com/2011/05/session-timeouts-on-rails.html




	def new
	end

	def create
	  user = User.authenticate(params[:email], params[:password])
	  if user
		session[:user_id] = user.id
		redirect_to root_url, :notice => "Giriş Yapıldı!"
		#redirect_to :controller=>'main',:action=>'index', :notice => "Logged in!"

	  else
		flash.now.alert = "Email veya şifre geçersiz!"
		render "new"
	  end
	end

	def destroy
	  session[:user_id] = nil
	 redirect_to root_url, :notice => "Çıkış Yapıldı!"
	  #redirect_to :controller=>'main',:action=>'index', :notice => "Logged out!"
	end


end
