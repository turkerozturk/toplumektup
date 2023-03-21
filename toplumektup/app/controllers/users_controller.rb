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


#http://www.quirksmode.org/dom/inputfile.html 
#http://stackoverflow.com/questions/4769483/rails-3-form-how-to-change-the-text-on-the-submit-button 

class UsersController < ApplicationController
  
  helper_method :sort_column, :sort_direction, :filter_archive, :en_az_bir_grup_var_mi?
  before_filter :en_az_bir_grup_var_mi? , :only => [:show_and_manage_ungrouped_users]
  
  # GET /users
  # GET /users.xml
  def index
	@arsiv = params[:arsiv]
	if @arsiv == "1"
		@users = User.where(:blocked => 1).order(sort_column + " " + sort_direction).search(params[:search], params[:filter])
		@pasif_kisi_sayisi = @users.count
		@aktif_kisi_sayisi = User.all.count - @pasif_kisi_sayisi
	else	
		@users = User.where(:blocked => 0).order(sort_column + " " + sort_direction).search(params[:search], params[:filter])
		@aktif_kisi_sayisi = @users.count
		@pasif_kisi_sayisi = User.all.count - @aktif_kisi_sayisi
	end
	
	@bulunan_kisi_sayisi = @users.count
	
	
	
	
	#@users = User.order(sort_column + " " + sort_direction)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
	@user = User.find(params[:id])
  # şu hatayı vermemesi için viewda önlem al yani resim dosyasını bulamıyor çünkü her kullanıcının resim dosyası yok: Routing Error No route matches "/internal_error.html"
  # http://stackoverflow.com/questions/7133762/internal-error-html-with-rails-3-app-on-dreamhost
  # random routing errors http://railsforum.com/viewtopic.php?id=36826
   
	@picture_file = "#{Rails.root}/public/images/recipient_profile_pictures/" + @user.id.to_s + ".jpg"
	 if File.exists?(@picture_file)
		@picture_url = "/images/recipient_profile_pictures/" + @user.id.to_s + ".jpg"
	 else
		@picture_url = "/images/icons/no_picture.png"
	 end 
	

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
	@groups = Group.find_by_sql("select name from groups")
	 #   respond_to do |format|
	#@grafiklibdurumu = `mogrify -version`
	@grafiklibdurumu = %x[mogrify -version] + "deneme"
	#	@grafiklibdurumu =  "deneme"

	# http://stackoverflow.com/questions/690151/getting-output-of-system-calls-in-ruby/690174#690174
	# http://www.imagemagick.org/script/command-line-tools.php
	# http://stackoverflow.com/questions/690151/getting-output-of-system-calls-in-ruby	
  end

  # POST /users
  # POST /users.xml
  def create
    #http://pupeno.com/2009/11/19/ensuring-the-displaying-of-flash-messages-in-ruby-on-rails/
	#if User.exists?(:email => params[:user][:email] )#'turker_ozt@yahoo.com' )
	
		#redirect_to (:action => "new", :notice => "email adresi kullanımda. Varolan bir kişiyi mi eklemeye çalışıyorsunuz?") and return
		#flash.keep[:notice]="This message will persist" 
		
	#end
	
   # @user = User.new(params[:user])
    @user = User.new(user_params)


    # http://www.tutorialspoint.com/ruby-on-rails/rails-file-uploading.htm
	# http://stackoverflow.com/questions/11644557/carrierwave-how-to-get-the-file-extension
	# http://stackoverflow.com/questions/7169923/parsing-string-pathname-with-ruby
		if params.has_key?(:picture)
			uzanti = File.extname(params[:picture].original_filename) #http://ruby-doc.org/core-2.0/File.html
			  uploaded_io = params[:picture]
		 # File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'w') do |file|
		 #http://stackoverflow.com/questions/4897568/ruby-on-rails-check-if-a-directory-file-symlink-exists-with-one-command
		 # http://www.simonecarletti.com/blog/2009/02/capistrano-uploads-folder/
		 #https://rails.lighthouseapp.com/projects/8994/tickets/1477-create-the-db-directory-if-it-doesnt-exist-sqlite-rake-dbcreate
		 if !File.exists?("#{RAILS_ROOT}/public/images/recipient_profile_pictures")
          FileUtils.mkdir "#{RAILS_ROOT}/public/images/recipient_profile_pictures"
         end 
		 
		 @dosya_hedef_yolu = Rails.root.join('public','images','recipient_profile_pictures', @user.id.to_s + uzanti)
			  File.open(@dosya_hedef_yolu, 'w') do |file|

			file.write(uploaded_io.read) # eskisini silmeye gerek kalmıyor üzerine yazıyor dosya varsa o yüzden hata vermiyor. çünkü dosyayı 'w' ile açtık.
		  end
		  # http://stackoverflow.com/questions/12432188/ruby-rails-pass-arguments-to-command-line-application-from-rake-task
		  # @resize_durumu = `mogrify -resize 160x160 #{@dosya_hedef_yolu}` # bunu kullanırsan yatayı 160 yapınca dikeyi en fazla 160 yapıyor orantıyı bozmadan.
		  # http://stackoverflow.com/questions/5518561/imagemagick-change-aspect-ratio-without-scaling-the-image
		  # @resize_durumu = `mogrify -resize 160x160 -background black -gravity center -extent 160x160 -flatten #{@dosya_hedef_yolu}`
			if uzanti != ".jpg"
				@resize_durumu = `mogrify -resize 160x160 -format jpg #{@dosya_hedef_yolu}` # burada aynı zamanda dosya uzantısını değiştirirken ikinci bir dosya oluşturduğu için orjinalini silmemiz gerekiyor sonradan.
				File.delete(@dosya_hedef_yolu)
			else
				@resize_durumu = `mogrify -resize 160x160 #{@dosya_hedef_yolu}` 
			end


		  # -format jpg *.png
		  
		  
		end
		
		if params.has_key?(:group)
			@group = params[:group]
			# http://stackoverflow.com/questions/4982371/handling-unique-record-exceptions-in-a-controller
			begin
				@user.groups << Group.find(@group)
			rescue
				# unique veri ise hata olusunca hatayş ekrana yazmamasi icin begin rescue kullandik ve ekrana ayni sayfayi getirdigin icin hatayi gostermiyor hata oldugunu anlayamiorsun.
			
			end

		end
		
		if params.has_key?(:groupn)
		@groupn = params[:groupn]
		@user.groups.delete(Group.find(@groupn))
		end
	

    respond_to do |format|
      if @user.save
        format.html { redirect_to(@user, :notice => 'Kişi oluşturuldu.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
  

    @user = User.find(params[:id])

	
		# http://www.tutorialspoint.com/ruby-on-rails/rails-file-uploading.htm
	# http://stackoverflow.com/questions/11644557/carrierwave-how-to-get-the-file-extension
	# http://stackoverflow.com/questions/7169923/parsing-string-pathname-with-ruby
		if params.has_key?(:picture)
			uzanti = File.extname(params[:picture].original_filename) #http://ruby-doc.org/core-2.0/File.html
			  uploaded_io = params[:picture]
		 # File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'w') do |file|
		 #http://stackoverflow.com/questions/4897568/ruby-on-rails-check-if-a-directory-file-symlink-exists-with-one-command
		 # http://www.simonecarletti.com/blog/2009/02/capistrano-uploads-folder/
		 #https://rails.lighthouseapp.com/projects/8994/tickets/1477-create-the-db-directory-if-it-doesnt-exist-sqlite-rake-dbcreate
		 if !File.exists?("#{RAILS_ROOT}/public/images/recipient_profile_pictures")
          FileUtils.mkdir "#{RAILS_ROOT}/public/images/recipient_profile_pictures"
         end 
		 
		 @dosya_hedef_yolu = Rails.root.join('public','images','recipient_profile_pictures', @user.id.to_s + uzanti)
			  File.open(@dosya_hedef_yolu, 'w') do |file|

			file.write(uploaded_io.read) # eskisini silmeye gerek kalmıyor üzerine yazıyor dosya varsa o yüzden hata vermiyor. çünkü dosyayı 'w' ile açtık.
		  end
		  # http://stackoverflow.com/questions/12432188/ruby-rails-pass-arguments-to-command-line-application-from-rake-task
		  # @resize_durumu = `mogrify -resize 160x160 #{@dosya_hedef_yolu}` # bunu kullanırsan yatayı 160 yapınca dikeyi en fazla 160 yapıyor orantıyı bozmadan.
		  # http://stackoverflow.com/questions/5518561/imagemagick-change-aspect-ratio-without-scaling-the-image
		  # @resize_durumu = `mogrify -resize 160x160 -background black -gravity center -extent 160x160 -flatten #{@dosya_hedef_yolu}`
			if uzanti != ".jpg"
				@resize_durumu = `mogrify -resize 160x160 -format jpg #{@dosya_hedef_yolu}` # burada aynı zamanda dosya uzantısını değiştirirken ikinci bir dosya oluşturduğu için orjinalini silmemiz gerekiyor sonradan.
				File.delete(@dosya_hedef_yolu)
			else
				@resize_durumu = `mogrify -resize 160x160 #{@dosya_hedef_yolu}` 
			end


		  # -format jpg *.png
		  
		  
		end
	

		# asagidaki :group ve groupn parametreleri aslinda cogul
		if params.has_key?(:group)
			@group = params[:group]
			# http://stackoverflow.com/questions/4982371/handling-unique-record-exceptions-in-a-controller
			begin
				@user.groups << Group.find(@group)
			rescue
				# unique veri ise hata olusunca hatayş ekrana yazmamasi icin begin rescue kullandik ve ekrana ayni sayfayi getirdigin icin hatayi gostermiyor hata oldugunu anlayamiorsun.
			
			end

		end
		
		if params.has_key?(:groupn)
			@groupn = params[:groupn]
			@user.groups.delete(Group.find(@groupn))
		end
    respond_to do |format|
      if @user.update(user_params)
		# http://stackoverflow.com/questions/7133762/internal-error-html-with-rails-3-app-on-dreamhost
		# sleep 2
		# dreamhost routing error problemini ben de internal_error.html sayfası oluşturup bu sayfadaki kodu içine aynen yapıştırarak ters kulaktan çözdüm http://www.cnblogs.com/walzer/archive/2011/07/10/2102435.html
        format.html { redirect_to(@user, :notice => 'Kişi bilgileri güncellendi.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end


  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
  
  
  
  def show_and_manage_ungrouped_users
  
  	# http://stackoverflow.com/questions/2616978/is-there-an-activerecord-equivalent-to-using-a-nested-subquery-i-e-where-no    (activerecord not in subquery)
	#@users = User.order(sort_column + " " + sort_direction).search(params[:search], params[:filter])

    @ungrouped_users = User.find_by_sql("select * from users where id not in(select distinct user_id from groups_users_relations) and blocked = 0 order by #{sort_column} #{sort_direction}")


    @groups = Group.all
  end
  
  def update_ungrouped_users
	# http://stackoverflow.com/questions/6472916/rails-group-action-on-selected-items-in-list-best-way
	# http://railscasts.com/episodes/52-update-through-checkboxes
	# @grouped_users = params["selectedusers"] #sadece idleri verir
	@grouped_users = User.find(params["selectedusers"])
	@group = Group.find(params["group"])
	begin
		@group.users << @grouped_users
	rescue
		# unique veri ise hata olusunca hatayş ekrana yazmamasi icin begin rescue kullandik ve ekrana ayni sayfayi getirdigin icin hatayi gostermiyor hata oldugunu anlayamiorsun.
	
	end
	
  end  
  
  def synch_eksik_evrak_group
	
	@users = User.where(:member => true)
	@group = Group.where(:name => '{eksik_evrak}').first
	#@group.users << @users
	@users.each do |user|
		if user.eksik_evrak_var_mi?
			unless @group.users.include?(user)		
				@group.users << user
			end	
		else
		    @group.users.delete(user) 
		
		end
		# http://stackoverflow.com/questions/3343861/how-to-check-if-my-array-includes-an-object-rails
		# unless @suggested_horses.include?(horse)
		#   @suggested_horses << horse
		# end		
	
	end
	
	
	
=begin	
	if @users.size > 0
		@eksik_evraklilar = Array.new
		@users.each do |user|
			if user.eksik_evrak_var_mi?
				@eksik_evraklilar << user.email
			end
		end
	else
		@eksik_evraklilar = ["Tüm üyelerin evrakları tamamlandı."]
	end
=end	
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :surname, :username, :password, :email, :phone, :occupation, :address, :blocked, :photo, :description, :created_at, :updated_at, :salt, :password_hash, :password_salt, :nufus_kagidi_fotokopisi, :giris_formu, :giris_banka_dekontu, :aidat_2012, :aidat_2013, :vesikalik_fotoğraf, :diploma_fotokopisi, :member)
  end
  
  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end   

  def filter_archive
	%w[0 1].include?(params[:arsiv]) ? params[:arsiv] : "0"
  end  
  
  
end


  
=begin  
# http://www.tutorialspoint.com/ruby-on-rails/rails-file-uploading.htm
BUNU CONTROLLERA

  def upload
	  uploaded_io = params[:picture]
	  File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'w') do |file|
		file.write(uploaded_io.read)
	  end
  end
  
BUNU DA VİEWA YAPIŞTIRIRSAN public içerisine uploads isminde klasör açarsan upload eder. modele falan gerek yok.
<%= form_tag({:action => :upload}, :multipart => true) do %>
  <%= file_field_tag 'picture' %>
      <%= submit_tag %>

<% end %>  
  
=end  
  
  

# http://stackoverflow.com/questions/11450451/using-a-multi-select-list-in-rails
# http://stackoverflow.com/questions/11450451/using-a-multi-select-list-in-rails
# many to many simple join tablo associationu bu video sayesinde yaptım: E:\egitim\ruby_ve_rails_hepsi\Lynda.com.Ruby.on.Rails.3.Essential.Training.2010-ADDiCT\8. Associations\Many-to-many associations_ Simple.wmv
# many to many tablo icin bu yaniltti beni biraz: E:\egitim\ruby_ve_rails_hepsi\Ruby on Rails Beyond the Basics [Lynda.com]\06. Databases and Migrations\07. Migrating a join table .mov
# http://strfti.me/
# http://railscasts.com/episodes/228-sortable-table-columns
# http://stackoverflow.com/questions/4058657/how-to-get-url-parameters-in-rails
# http://stackoverflow.com/questions/2695538/add-querystring-parameters-to-link-to


=begin
# rails generate model groups_recipients
# sonra asagidakileri db/migrate/tarih_create_groups_recipients.rb icine yapistir
class CreateGroupsRecipients < ActiveRecord::Migration
	def self.up
		create_table :groups_recipients, :id => false do |t|
			t.column :recipient_id, :integer, :null => false
			t.column :group_id, :integer, :null => false
			#t.timestamps
		end
		#add_index :groups_recipients, :recipient_id
		#add_index :groups_recipients, :group_id
		add_index :groups_recipients, [:group_id, :recipient_id]
	end
	
	def self.down
		drop_table :groups_recipients
	end
end


# rake db:migrate RAILS_ENV="production"
#  recipient.rb icine sunlari yapistir
# has_and_belongs_to_many :groups

# models/group.rb icine sunlari yapistir
# has_and_belongs_to_many :recipients

#sonra models/groups_recipients icine sunlari yapistir
# belongs_to :recipient
# belongs_to :group
# touch tmp/restart
# bak bakalim oldu simdi
# yanlis birsey yaparsan rake db:rollback RAILS_ENV="production" komutuyla tabloyu silersin. modele ve migration dosyasına birşey olmaz. düzenleyip yeniden migrate edersin.


=end


