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


class ImportController < ApplicationController

	def index

	end

	def wizpage2
		@group_id = params[:group_id]
		@rawusers = params[:rawusers]
		@rawuserssplitted = @rawusers.split(/\r?\n/)
		
		@newusers, @existingusers = [], []

		@rawuserssplitted.each do |rawuser|
					user = rawuser.split('|')

=begin	
		
			user = rawuser.split('|')
			
				tmp = user[08].split
				name, surname = '',''
				i = 0
				tmp.each do |t|
				 if i == tmp.size - 1
				   surname = t
				 elsif i == 0  
				  name << "#{t}"
				 else 
				  name << " #{t}"
				 end 
				 i = i + 1
				end
=end
						   name = user[8]
				   surname = user[8]

				    
				email = user[9].to_s.gsub('"', '')
				occupation = user[10]
				
				kontrol = User.where(:email => email).first
				if kontrol.blank?
				
				
				  @newusers << {:name => name, :surname => surname, :email => email, :occupation => occupation}
			    else
				  @existingusers << {:name => name, :surname => surname, :email => email, :occupation => occupation}

				end
			
			
		  

		end

	end

end