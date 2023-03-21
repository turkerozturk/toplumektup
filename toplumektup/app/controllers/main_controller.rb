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


class MainController < ApplicationController
#skip_before_filter :authentication_check, :only => :index # bu sayede sadece bu controllerin index sayfasının authenticationdan etkilenmemesini sağlamış olduk.
skip_before_filter :authorize_access, :only => :index # bu sayede sadece bu controllerin index sayfasının authenticationdan etkilenmemesini sağlamış olduk.

# http://stackoverflow.com/questions/2390178/skip-before-filter-in-rails # http://stackoverflow.com/questions/5507026/before-filter-with-parameters

  def index
	@t = Task.where(:completed => 0).count
    @m = Message.where(:used => 0).count
	@u = User.where(:blocked => 0).count
	@g = Group.all.count
	@eq = EmailQueue.where(:sent => 0).count
  end

=begin	  
	def index
		login
		render(:action => 'login')
	end
=end

	def login
		#@user = User.new
		# 123456 -> 7c4a8d09ca3762af61e59520943dc26494f8941b

	end

	def send_login
		found_user = User.authenticate(params[:username], params[:password]) # bu sekilde yapinca gereksiz yere taa en bastan user object olusturmaya gerek kalmiyor bu da performans icin iyi birsey.
		#@user = User.new(params[:user])
		#logged_in_user = @user.try_to_login
		if found_user
			session[:user_id] = found_user.id
			flash[:notice] = "Giriş yaptınız."
			redirect_to(:action => 'menu')
		else
			flash.now[:notice] = "Kullanıcı şifre kombinasyonu yanlış. Tekrar deneyin."
			render(:action => 'login')
		end
	end

	def logout
		session[:user_id] = nil
		flash[:notice] = 'Çıkış yaptınız.'
		redirect_to(:action => 'login')

	end
  
  
  
end
