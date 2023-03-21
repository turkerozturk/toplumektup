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


class EmailQueue < ActiveRecord::Base
	belongs_to :group
	belongs_to :user
	belongs_to :message
	belongs_to :task


	# http://stackoverflow.com/questions/6249475/ruby-on-rails-callback-what-is-difference-between-before-save-and-before-crea
	# http://stackoverflow.com/questions/1550688/how-do-i-create-a-default-value-for-attributes-in-rails-activerecords-model
	before_create :default_values

	def default_values
	  self.sent ||= 0
	end



end
