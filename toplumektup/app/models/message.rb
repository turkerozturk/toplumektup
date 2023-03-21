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


class Message < ActiveRecord::Base
has_many :email_queues, :dependent => :restrict_with_error

has_one :task, :dependent => :restrict_with_error
#, :inverse_of => :message

# before_create :default_values



# http://stackoverflow.com/questions/2732664/how-to-change-validation-messages-on-forms
# http://stackoverflow.com/questions/7125127/i18n-error-message-localization-for-particular-model
# http://guides.rubyonrails.org/i18n.html
validates :subject, :presence => true # => {:message => "boş bırakılamaz."} #http://guides.rubyonrails.org/active_record_validations_callbacks.html
validates :body, :presence => true # => {:message => "boş bırakılamaz."} #http://guides.rubyonrails.org/active_record_validations_callbacks.html

# http://stackoverflow.com/questions/6249475/ruby-on-rails-callback-what-is-difference-between-before-save-and-before-crea
# http://stackoverflow.com/questions/1550688/how-do-i-create-a-default-value-for-attributes-in-rails-activerecords-model
before_save :default_values # hem create hem de update durumunda

private

def default_values
  self.used ||= 0
  self.locked ||= 0
  
  unless self.description?
	self.description = self.subject # açıklama alanı boş bırakılırsa ubject ile aynı isimde olsun diye.
  end
  #self.description = "yok"
end




def self.search(search, filter)

	s = search.to_s
	f = filter.to_s
  if f.to_s == "0"
 #  find(:all, :conditions => ['status = ?', "%#{search}%"])
    # find(:all, :conditions => ['subject = ? and body like ? or description like ?', "0", "%#{s}%","%#{s}%"])
    where('subject = ? and body like ? or description like ?', "0", "%#{s}%","%#{s}%")
  elsif f.to_s == "1"
   #find(:all, :conditions => ['subject = ? and body like ? or description like ?', "1","%#{s}%","%#{s}%"])
    where('subject = ? and body like ? or description like ?', "1","%#{s}%","%#{s}%")
  else
   # find(:all)
    # find(:all, :conditions => ['subject like ? or body like ?', "%#{s}%","%#{s}%"])
     where('subject like ? or body like ?', "%#{s}%","%#{s}%")
  
  end
end




end
