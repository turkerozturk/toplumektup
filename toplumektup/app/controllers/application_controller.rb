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


class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user
  # unique bir cookie adı yaz ki diğerlerinden ayrılsın.
  #session :session_key => '_toplumektup'
  # session :disabled => true




  # basla http://madkingsmusings.blogspot.com/2011/05/session-timeouts-on-rails.html
  #before_filter :session_expiry
  #before_filter :update_activity_time

  #include SessionsHelper

  #def session_expiry
  #  get_session_time_left
  #  unless @session_time_left > 0
  #    # http://stackoverflow.com/questions/5767222/rails-call-another-controller-action-from-a-controller
  #    #log_out
  #    #redirect_to "sessions#destroy"
  #    deny_access 'Your session has timed out. Please log back in.'
  #  end
  #end
  #
  #def update_activity_time
  #  session[:expires_at] = 1.minutes.from_now
  #end
  # bit http://madkingsmusings.blogspot.com/2011/05/session-timeouts-on-rails.html





 # before_filter :authorize_access # interactive authentication için appcontrollerda metod tanımladık ve users modele de birşeyler ekledik. hepsi şifreli olacaksa
  # MAALESEF basic authenticationdan logout yok yani bir kere giris yapinca browser hep hatirliyor. http://stackoverflow.com/questions/449788/http-authentication-logout-via-php
  # bu rails 3.1den sonra işe yarıyor burada kullanamadım http_basic_authenticate_with :name => "turker", :password => "123456", :except => :index
  ###USER, PASSWORD = 'turker', 'turker'
  ###before_filter :authentication_check # , :except => :index # çalışmasını istemediklerimizi gidip o controller içine skip_before_filter_koyarak hallet http://stackoverflow.com/questions/2390178/skip-before-filter-in-rails #
  # yukarıdaki kullandım o yüzden: http://stackoverflow.com/questions/8138317/ror-undefined-method-http-basic-authenticate-with
  # http://api.rubyonrails.org/classes/ActionController/HttpAuthentication/Basic.html

  private
  # TODO bunu ana kontrollere koydum ama sonra ana helpere konabilir
  # http://stackoverflow.com/questions/8138317/ror-undefined-method-http-basic-authenticate-with
  ###def authentication_check
  ###authenticate_or_request_with_http_basic do |user, password|
  ###user == USER && password == PASSWORD
  ###end
  ###end

  #before_filter :en_az_bir_grup_var_mi? , :only => [:show_and_manage_ungrouped_users]
  def en_az_bir_grup_var_mi?
    @groups = Group.all # hata cikinca geri giderse yine ayni degisken ismini ariyor o yuzden validation baglantili islemlerde o degisken degerini ayni new metodunda ne tanimlamissan burada da tanimlaman gerekebiliyor hata vermemesi icin.
    unless @groups.count > 0 # sadece kullanılmamış mesajlardan birini seçmemiz için.
      respond_to do |format|
        format.html { redirect_to(groups_path,  :flash => { :error => "Bu işlemi yapabilmek için en az bir grup oluşturmaya ihtiyaç vardır." } ) } #http://stackoverflow.com/questions/7510418/rails-redirect-to-with-error-but-flasherror-empty

      end
    end
  end




  #def current_user
  #  @current_user ||= User.find(session[:user_id]) if session[:user_id]
  #end


  # basla intermediate authentication için lynda beyond basic videosundan
  #def authorize_access
  #  if !session[:user_id]
  #    flash[:notice] = "Lütfen giriş yapın."
  #    redirect_to(:controller => 'main', :action => 'index')
  #    return false
  #  end
  #end
  # bit intermediate authentication için lynda beyond basic videosundan


  # basla http://madkingsmusings.blogspot.com/2011/05/session-timeouts-on-rails.html
  #def get_session_time_left
  #  #http://stackoverflow.com/questions/17480487/rails-4-session-expiry
  #  expire_time = session[:expires_at] || Time.now
  #  @session_time_left = (expire_time - Time.now).to_i
  #end
# bit http://madkingsmusings.blogspot.com/2011/05/session-timeouts-on-rails.html


end