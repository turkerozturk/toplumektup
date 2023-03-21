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


class User < ActiveRecord::Base
validates_uniqueness_of :email, :message => "Bu email adresini kullanamazsınız çünkü kullanımda."
has_many :email_queues, :dependent => :restrict_with_error
#has_many :groups_recipients
#has_many :groups
#has_and_belongs_to_many :groups # kulllanımıyourum artık çünkü dependent destroy etmiyor.
# http://stackoverflow.com/questions/1915229/how-can-i-delete-an-entry-from-a-habtm-join-table-in-rails
has_many :groups_users_relations, :dependent => :destroy # destroy yaparsan useri siler ve ona bağlı grup ilişkilerini siler ama grupların kendisini silmez. restrict yaparsan ilişkiyi silmez ve hata verir, önce ilişkiyi silmen gerekir.
has_many :groups, :through => :groups_users_relations
# eger baska bir isimle kullanmak istersen su sekilde yazman gerekir ki oteki modeli bulsun.
#has_and_belongs_to_many :baskaisim, class => "Group"
#accepts_nested_attributes_for :groups

attr_accessor :password # interactive authentication icin lynda beyond basics videosundan
before_save :encrypt_password
#attr_protected :hashed_password, :salt # interactive authentication icin lynda beyond basics videosundan
#attr_accessible :username, :password

  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

=begin
before_create :olusturma_oncesi # interactive authentication icin lynda beyond basics videosundan
before_update :guncelleme_oncesi # interactive authentication icin lynda beyond basics videosundan
before_destroy :silme_oncesi # interactive authentication icin lynda beyond basics videosundan
after_save :kaydetme_oncesi # interactive authentication icin lynda beyond basics videosundan

# interactive authentication icin lynda beyond basics videosundan
def olusturma_oncesi
	self.salt = User.make_salt(self.username) #veya email falan da yapabilirsin maksat unique olmaya çalışmak.
	self.hashed_password = User.hash_with_salt(@password, self.salt) # @password yazabilmemizin sebebi :password diye attr_accessor tanımladık çünkü.
end

# interactive authentication icin lynda beyond basics videosundan
def guncelleme_oncesi
	#self.salt = User.make_salt(self.username) #veya email falan da yapabilirsin maksat unique olmaya çalışmak. ??????????????

	if !@password.blank?
		self.salt = User.make_salt(self.username) if self.salt.blank?
		self.hashed_password = User.hash_with_salt(@password, self.salt) # @password yazabilmemizin sebebi :password diye attr_accessor tanımladık çünkü.
	end
end

# interactive authentication icin lynda beyond basics videosundan
def silme_oncesi
	return false if self.id == 1 # admin olan kullacıyı yanlışlıkla silmemek için. 
end

# interactive authentication icin lynda beyond basics videosundan
def kaydetme_oncesi
	@password = nil # şifreyi veritabanına hashli olarak geçirdiğimiz için değişkeni sıfırlıyoruz güvenlik gereği.
end
=end

#http://stackoverflow.com/questions/6828040/capitalize-the-string-in-the-options-from-collection-for-select
# bu metod tanimimiz sayesinde select list boxlarda görünen kısmın metnini düzenleme şansımız oluyor.
def display_name
  #self.email + self.name
  return "#{self.name} #{self.surname}|#{self.email}"
end

def self.search(search, filter)

	s = search.to_s
	f = filter.to_s
  if f.to_s == "0"
 #  find(:all, :conditions => ['status = ?', "%#{search}%"])
     #find(:all, :conditions => ['blocked = ? and name like ? or email like ?', "0", "%#{s}%","%#{s}%"])
    where('blocked = ? and name like ? or email like ?', "0", "%#{s}%","%#{s}%")

  elsif f.to_s == "1"
   #find(:all, :conditions => ['blocked = ? and name like ? or email like ?', "1","%#{s}%","%#{s}%"])
    where('blocked = ? and name like ? or email like ?', "1","%#{s}%","%#{s}%")
  else
   # find(:all)
   #  find(:all, :conditions => ['name like ? or email like ?', "%#{s}%","%#{s}%"])
     where('name like ? or email like ?', "%#{s}%","%#{s}%")

  
  end
end

	def eksik_evrak_var_mi?
		durum = false

		if !self.nufus_kagidi_fotokopisi?
			durum = true
		end

		if !self.giris_formu?
			durum = true
		end

		if !self.giris_banka_dekontu?
			durum = true
		end

		if !self.aidat_2012?
			durum = true
		end

		if !self.aidat_2013?
			durum = true
		end

		if !self.vesikalik_fotograf?
			durum = true
		end

		if !self.diploma_fotokopisi?
			durum = true
		end
		
		return durum

	end  
	
	
	def eksik_evrak_listesi
		liste = Array.new

		if !self.nufus_kagidi_fotokopisi?
			liste << "Nüfüs cüzdanı fotokopisi"
		end

		if !self.giris_formu?
			liste << "Üyelik başvuru formu"
		end

		if !self.giris_banka_dekontu?
			liste << "Giriş ücretini gösterir banka dekontu"
		end

		if !self.aidat_2012?
			liste << "2012 yılı aidat dekontu"
		end

		if !self.aidat_2013?
			liste << "2013 yılı aidat dekontu"
		end

		if !self.vesikalik_fotograf?
			liste << "Vesikalık Fotoğraf"
		end

		if !self.diploma_fotokopisi?
			liste << "Diploma fotokopisi"
		end
		
		return liste

	end  	
	
	

=begin
# interactive authentication icin lynda beyond basics videosundan
def self.authenticate(username = "", password = "")
	##hashed_password = self.hash_with_salt(password, self.salt)
	#hashed_password = self.hash_with_salt(username, password)
	#user = self.find(:first, :conditions => ["username = ? AND hashed_password = ?", username, hashed_password])
	user = self.find(:first, :conditions => ["username = ?", username])
	#return user
	return (user && user.authenticated?(password)) ? user : nil
end

# interactive authentication icin lynda beyond basics videosundan
# degerlerin nil gelmesi durumuna karsi hata vermemeler icin empty string olmasi icin defaulta = "" yaziyoruz.
def authenticated?(password = "")
	hashed_password = hash_with_salt(password, self.salt) # ???
	return hashed_password == User.hash_with_salt(password, self.salt)
end

private

# interactive authentication icin lynda beyond basics videosundan
def self.make_salt(string)
	return Digest::SHA1.hexdigest(string.to_s + Time.now.to_s) # her defasında farklı salt oluşturmak için zamanı ekledik.
	# bu hep 40 karakter uzunluğunda olur.
	end

# interactive authentication icin lynda beyond basics videosundan
def self.hash_with_salt(password, salt)
	return Digest::SHA1.hexdigest("Put #{salt} on the #{password}") #salting yapıyoruz.

end
=end


end
