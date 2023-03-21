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


class Task < ActiveRecord::Base

	has_many :email_queue, :dependent => :restrict_with_error
	#belongs_to :message
	belongs_to :message
	#, :inverse_of => :task
	#has_one :message
	belongs_to :group
	
	# http://stackoverflow.com/questions/2732664/how-to-change-validation-messages-on-forms
	# http://stackoverflow.com/questions/7125127/i18n-error-message-localization-for-particular-model
	# http://guides.rubyonrails.org/i18n.html
	validates :name, :presence => true # => {:message => "boş bırakılamaz."} #http://guides.rubyonrails.org/active_record_validations_callbacks.html
	
	# http://stackoverflow.com/questions/1393698/rails-model-validation-on-create-and-update-only
	validate :tarih_baslangici, :on => :create # böylece update ederken devre dışı kalacak yani completed = true yapabilecğiz mailleri göndermişsek, öteki türlü buna takılıp tarihi geçti diye tabloyu güncellemeye izin vermiyordu. artık sadece new kayıtta validasyon yapacak.
	#validates_presence_of :name



	# http://stackoverflow.com/questions/6249475/ruby-on-rails-callback-what-is-difference-between-before-save-and-before-crea
	# http://stackoverflow.com/questions/1550688/how-do-i-create-a-default-value-for-attributes-in-rails-activerecords-model
	before_create :default_values

	def default_values
	  self.completed ||= 0
	end

	private
	
	#def validate
		#errors.add(:scheduled_at, "Seçtiğiniz tarih şimdiden eski olamaz.") if self.scheduled_at < Time.zone.now
		# return true
	#end
	
	# http://stackoverflow.com/questions/6401374/rails-validation-method-comparing-two-fields undefined method `>' for nil:NilClass
	# http://liahhansen.com/2011/04/15/rails-console-show-error-messages-for-all-attributes.html konsoldan update yaparken niye kaydetmediğini u.errors.full_messages komutunu verince validasyona takıldığını anlamış oldum.
	def tarih_baslangici
		simdi = Time.zone.now
		bas_saati = simdi - simdi.min.minutes - simdi.sec.seconds
		errors.add(:scheduled_at, "Tarih şimdiki zamandan eski olamaz.") unless self.scheduled_at > (bas_saati)
		#errors.add(:scheduled_at, "Tarih şimdiki zamandan eski olamaz.") unless self.scheduled_at > (Time.zone.now - 1.minutes) # 1 dakika içerisinde formu göndermezse tarihi eskidi kabul ediyorum.
	
	end



end

# http://guides.rubyonrails.org/i18n.html#adding-date-time-formats

# rails display boolean as yes no
# BUNU SEÇTİM çünkü viewda yes no dışında da tanımlayabilirim http://stackoverflow.com/questions/4936630/replace-output-of-true-and-false-in-a-view-with-rails
# http://juliankniephoff.wordpress.com/2011/04/09/formatting-boolean-values-in-rails/
# http://stackoverflow.com/questions/3664181/rails-or-ruby-yes-no-instead-of-true-false
# Bu hepsini yes no yapar http://stackoverflow.com/questions/5228823/is-there-an-existing-i18n-translation-for-booleans