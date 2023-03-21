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


class Group < ActiveRecord::Base
has_many :tasks, :dependent => :restrict_with_error
has_many :email_queues, :dependent => :restrict_with_error

#has_and_belongs_to_many :users
# http://stackoverflow.com/questions/1915229/how-can-i-delete-an-entry-from-a-habtm-join-table-in-rails
# http://stackoverflow.com/questions/7040022/rails-why-has-many-through-association-results-in-nameerror-un
has_many :groups_users_relations,  :dependent => :destroy  # destroy yaparsan grubu siler ve ona bağlı user ilişkilerini siler ama userların kendisini silmez. restrict yaparsan ilişkiyi silmez ve hata verir, önce ilişkiyi silmen gerekir.
has_many :users, :through => :groups_users_relations

# http://stackoverflow.com/questions/2799746/habtm-relationship-does-not-support-dependent-option
# http://neyric.com/2007/07/08/how-to-delete-a-many-to-many-association-with-rails/
# http://thinkwhere.wordpress.com/2009/05/09/adding-a-primary-key-id-to-table-in-rails/

# http://stackoverflow.com/questions/2732664/how-to-change-validation-messages-on-forms
# http://stackoverflow.com/questions/7125127/i18n-error-message-localization-for-particular-model
# http://guides.rubyonrails.org/i18n.html
validates :name, :presence => true # => {:message => "boş bırakılamaz."} #http://guides.rubyonrails.org/active_record_validations_callbacks.html


# http://stackoverflow.com/questions/6249475/ruby-on-rails-callback-what-is-difference-between-before-save-and-before-crea
# http://stackoverflow.com/questions/1550688/how-do-i-create-a-default-value-for-attributes-in-rails-activerecords-model
before_save :default_values # hem create hem de update durumunda




private

def default_values
  unless self.description?
	self.description = self.name # açıklama alanı boş bırakılırsa name ile aynı isimde olsun diye.
  end
  #self.description = "yok"
end









end
