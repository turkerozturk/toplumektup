﻿=begin
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


module SessionsHelper
# basla http://madkingsmusings.blogspot.com/2011/05/session-timeouts-on-rails.html
	def deny_access(msg = nil)
=begin	
	  msg ||= "Please sign in to access this page."
	  flash[:notice] ||= msg
	  respond_to do |format|
		format.html {
		  #store_location
		  #destroy
		  #redirect_to "/sessions#destroy"
		  redirect_to :controller=>'sessions',:action=>'destroy' #, :notice => "Logged in!"
		}

	  end
=end
	end	
# bit http://madkingsmusings.blogspot.com/2011/05/session-timeouts-on-rails.html
end
