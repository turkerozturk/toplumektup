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


class TasksController < ApplicationController
  # bu rails 3.1den sonra işe yarıyor burada kullanamadım http_basic_authenticate_with :name => "turker", :password => "123456", :except => :index
	#USER, PASSWORD = 'turker', '123456'
	#before_filter :authentication_check, :except => :index
  # yukarıdaki kullandım o yüzden: http://stackoverflow.com/questions/8138317/ror-undefined-method-http-basic-authenticate-with
  # http://api.rubyonrails.org/classes/ActionController/HttpAuthentication/Basic.html
  # güvenliği ana kontrollere koydum
  
  # before_filter :authorize_access # interactive authentication için appcontrollerda metod tanımladık ve users modele de birşeyler ekledik. hepsi şifreli olacaksa
   #before_filter :authorize_access, :except => [:index, :login, :send_login]
  
  
  helper_method :sort_column, :sort_direction, :filter_archive, :en_az_bir_grup_var_mi?
  
  before_filter :bosta_mesaj_var_mi? , :only => [:new]
  before_filter :en_az_bir_grup_var_mi? , :only => [:new]
   
  
  def bosta_mesaj_var_mi? 
	@message = Message.where(:used => 0) # hata cikinca geri giderse yine ayni degisken ismini ariyor o yuzden validation baglantili islemlerde o degisken degerini ayni new metodunda ne tanimlamissan burada da tanimlaman gerekebiliyor hata vermemesi icin.
	unless @message.count > 0 # sadece kullanılmamış mesajlardan birini seçmemiz için.
		respond_to do |format|
			format.html { redirect_to(tasks_path,  :flash => { :error => "Görev oluşturmak için kullanılmamış en az bir mesaj oluşturun veya varolan başlamamış görevlerden birini silerek bir mesajı boşa çıkarın." } ) } #http://stackoverflow.com/questions/7510418/rails-redirect-to-with-error-but-flasherror-empty

		end
	end
  end
=begin  
   before_filter :en_az_bir_grup_var_mi? , :only => [:new, :show_and_manage_ungrouped_users]
  def en_az_bir_grup_var_mi? 
	@groups = Group.all # hata cikinca geri giderse yine ayni degisken ismini ariyor o yuzden validation baglantili islemlerde o degisken degerini ayni new metodunda ne tanimlamissan burada da tanimlaman gerekebiliyor hata vermemesi icin.
	unless @groups.count > 0 # sadece kullanılmamış mesajlardan birini seçmemiz için.
		respond_to do |format|
			format.html { redirect_to(tasks_path,  :flash => { :error => "Görev oluşturmak için en az bir grup oluşturun." } ) } #http://stackoverflow.com/questions/7510418/rails-redirect-to-with-error-but-flasherror-empty

		end
	end
  end
=end 

  # GET /tasks
  # GET /tasks.xml
  def index
    #task.completed ? 'Bitti' : 'Bitmedi'
	#@task_status = Array.new
	
	@arsiv = params[:arsiv]
	if @arsiv == "1"
		@tasks = Task.where(:completed => 1).order(sort_column + " " + sort_direction)
	else	
		@uncompleted_tasks = Task.where(:completed => 0)
		@uncompleted_tasks.each do |utask|
			gonderilmis = utask.email_queue.where(:sent => 1).count
			gonderilmesi_gerekenler = utask.email_queue.all.count
			if gonderilmesi_gerekenler == gonderilmis
				#utask.update_attributes(:completed => 1)
				utask.completed = true
				utask.save
				
			else
			
			end
		end
	
		@tasks = Task.where(:completed => 0).order(sort_column + " " + sort_direction)
		#@tasks = Task.where(:completed => 0)
	#elsif @arsiv == "1"
	
		
	end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.xml
  def show
    @task = Task.find(params[:id])
	#@group = Group.find(@task.group_id).name
	#@message = Message.find(@task.message_id).subject
	@group = @task.group
	@message = @task.message
	
	#şu anki vaktin saat aralığı ne?
	@hour_now = Time.zone.now.hour
	# http://railscasts.com/episodes/29-group-by-month
	# http://api.rubyonrails.org/classes/Time.html#method-i-beginning_of_hour dreamhost rails versiyonunda hour için yok!
	@q = @task.email_queue
	@saat_dilimi = Array.new
	@saatteki_adet = Array.new
	#@task.email_queue.count( :group => ["HOUR(scheduled_at)"]).each do |u|
	#	@saat_dilimi <<	u[0]
	#	@saatteki_adet << u[1]
	#end
	# TODO: YUKARIDAKİ ORFANLARI PİSLİKLERİ TEMİZLE
	
	@kuyruk_sayisi = @task.email_queue.count
	@bitmis_kuyruk_sayisi = @task.email_queue.where(:sent => 1).count
	@bitmemis_kuyruk_sayisi = @task.email_queue.where(:sent => 0).count
	
	if @kuyruk_sayisi == @bitmis_kuyruk_sayisi
		@gorev_durum_mesaji = "Bu görev tamamlandı. Tüm mesajlar ilgili kişilere gönderildi."
	elsif @kuyruk_sayisi == @bitmemis_kuyruk_sayisi	
		@gorev_durum_mesaji = "Bu görev henüz başlamadı. Tüm mesajlar ilgili kişilere gönderilmeyi bekliyor."
	else
		@gorev_durum_mesaji = "Bu görev başladı. Mesajların bir kısmı gönderildi, kalan kısmı vakti geldiğinde gönderilecek."
	end

	# önce o task kaç güne yayılmış onu bulalım:
	@task_days = @task.email_queue.select("DATE(scheduled_at) as Tarih, count(*) as Adet").group("DATE(scheduled_at)")
	#@task_days_count = @task_days.size
	#@gun = Array.new
	#@gun_eleman_sayisi = Array.new
	@saat = Array.new
	@task_days.each do |task_day|
		#@gun << task_day.tarih
		#@gun_eleman_sayisi << task_day.sayi
		@gun_bas = task_day.Tarih.to_time
		@gun_bit = @gun_bas + 23.hours + 59.minutes + 59.seconds
		#@s = @task.email_queue.select("CONCAT(HOUR(scheduled_at), ':00-', HOUR(scheduled_at)+1, ':00') AS Saat , COUNT(*) AS `Adet`").where(:scheduled_at => @gun_bas..@gun_bit).group("HOUR(scheduled_at)")
		@s = @task.email_queue.select("HOUR(scheduled_at) AS Saat , COUNT(*) AS `Adet`").where(:scheduled_at => @gun_bas.utc..@gun_bit.utc).group("HOUR(scheduled_at)")
		#@s.each do |duzeltme|
			# http://stackoverflow.com/questions/4046289/convert-datetime-string-to-utc-in-rails
		 #   duzelt = (@gun_bas + duzeltme.Saat.to_i.hours).to_s
			#duzeltme.Saat = Time.zone.parse(duzelt)
		#end
		@saat << @s
	
	end
	
	# sonra o günlerin hangi saatlerinde kaç email var onu bulalım:
	# bununla saat aralıklarında kaç tane var bulmak mümkün.
	
	#@gun_bas = '2013-04-05'.to_time
	#@gun_bit = @gun_bas + 1.days
	#@saat = @task.email_queue.select("CONCAT(HOUR(scheduled_at), ':00-', HOUR(scheduled_at)+1, ':00') AS Saat , COUNT(*) AS `Adet`").where(:scheduled_at => @gun_bas..@gun_bit).group("HOUR(scheduled_at)")

	
	
	
	
	
	
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.xml
  def new
    @task = Task.new
	@message = Message.where(:used => 0) # sadece kullanılmamış mesajlardan birini seçmemiz için.

	
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @task }
    end
	
	
	
	
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
	@message = Message.where(:used => 0) # sadece kullanılmamış mesajlardan birini seçmemiz için.
  end

  # POST /tasks
  # POST /tasks.xml
  def create
    #@task = Task.new(params[:task])
    @task = Task.new(task_params)
	@message = Message.where(:used => 0) # sadece kullanılmamış mesajlardan birini seçmemiz için.
	
	
	
=begin
						#gitmemiş email listesi:
						qu = EmailQueue.where(:sent => 0)
						
						#gitmemiş email sayısı:
						quc = qu.count
	
						#son bir saatteki tüm email sayısı:
						qt1 = EmailQueue.where(:created_at => 1.hour.ago..Time.now).count

						#son bir saatteki gitmemiş email sayısı:
						qu1 = EmailQueue.where(:sent => 0, :created_at => 1.hour.ago..Time.now).count

						#son bir saatteki gitmiş email sayısı:
						qt1 = EmailQueue.where(:sent => 1, :created_at => 1.hour.ago..Time.now).count

						fark = 0
						#c = @task.email_queue.count
						i = 1
						qu.each do |job|
							if i % 5 + 1 == 5 
								fark += 1.hour
							end
							i += 1

							job.update_attributes(:scheduled_at => Time.now + fark)

							
							
						end

=end
	
	@last_email_queue = EmailQueue.where(:sent => 0).order("scheduled_at desc")

    respond_to do |format|
      if @task.save
=begin	  
		#son bir saatteki tüm email sayısı:
		@ecount = EmailQueue.where(:created_at => (1.hour.ago.utc)..(Time.now.utc)).count # veritabanındaki tarihleri karşılaştırırken UTC olarak yapmalısın bu işi.
	    # Görevi oluşturduktan sonra görevi ilgilendiren mail adresleri için tek tek mail kuyruğu tablosunda kayıt oluşturuyoruz.
		@zamanlama_tarihi = Time.zone.now
		@task.group.users.each do |user|
			EmailQueue.create(:task_id => @task.id, :group_id => @task.group.id, :user_id => user.id, :message_id => @task.message.id, :scheduled_at => @zamanlama_tarihi)
			#@queue.save
		end
		@task.message.update_attributes(:used => 1)	# Göreve ve ona ait mail kuyruğu kayıtlarını oluşturduğumuz için o mesajı kullanıldı kabul ediyoruz ki diğer görevlerde kullanılmasın.
=end		
		
		@task.message.update_attributes(:used => 1)	# Göreve ve ona ait mail kuyruğu kayıtlarını oluşturduğumuz için o mesajı kullanıldı kabul ediyoruz ki diğer görevlerde kullanılmasın.
		@kota = 500 # saatlik kota #TODO yandex 1000 diye 80den 500e çıkardım.
		@users = @task.group.users
		#skota = kota
		@q_sayisi = @users.count # eklenecek queue sayısı
		@q = 0
		@u = 0
		#@bas_tarihi = @task.scheduled_at + 1.hours - @task.scheduled_at.min.minutes - @task.scheduled_at.sec.seconds # 1 saat sonrasının başından itibaren zamanlayacak.
		@bas_tarihi = @task.scheduled_at - @task.scheduled_at.min.minutes - @task.scheduled_at.sec.seconds # görevin oluşturulduğu saat dakikanın saat başından itibaren zamanlayacak.
		@bit_tarihi = @bas_tarihi + 59.minutes + 59.seconds
		while @q < @q_sayisi 
			
			#o saat araligindaki tüm email sayısı:
			@ecount = EmailQueue.where(:scheduled_at => (@bas_tarihi.utc)..(@bit_tarihi.utc)).count # veritabanındaki tarihleri karşılaştırırken UTC olarak yapmalısın bu işi.
			#o saat aralığı için kullanabileceğimiz kota sayısı
			
			@skota = @kota - @ecount
			# times sayaci sifirdan baslar yani 3.times demek 0 1 2 demek.
			@skota.times do |i|
				if @u < @q_sayisi
					@user = @users[@u]				
					#EmailQueue.create(:task_id => @task.id, :group_id => @task.group.id, :user_id => @user.id, :message_id => @task.message.id, :scheduled_at => @bas_tarihi.utc)
					EmailQueue.create(:task_id => @task.id, :group_id => @task.group.id, :user_id => @user.id, :message_id => @task.message.id, :scheduled_at => @bas_tarihi)

					@u += 1
				end
			end
		
			@bas_tarihi += 1.hours 
			@bit_tarihi = @bas_tarihi + 1.hours
			@q = @u # bukadar email kaldı zamanlanması gereken. sıfırlanana kadar devam edecek döngü.
		end
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		

		
        format.html { redirect_to(@task, :notice => 'Task was successfully created.') }
        format.xml  { render :xml => @task, :status => :created, :location => @task }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.xml
  def update
    @task = Task.find(params[:id])

    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to(@task, :notice => 'Task was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.xml
  def destroy
    @task = Task.find(params[:id])
	@task.email_queue.destroy_all # görevi silmeden önce göreve bağlı mesaj kuyruğunu siliyoruz çünkü modelde dependant :restrict yaptığımız için direk task.destroy yapmamıza izin vermez hata verir.
	@task.message.update_attributes(:used => 0)	# Görevi ve ona ait mail kuyruğu kayıtlarını sildiğimiz için o mesaj kullanılmadı o yüzden diğer görevlerden birinde kullanılabilecek hale getiriyoruz.
    @task.destroy

    respond_to do |format|
      format.html { redirect_to(tasks_url) }
      format.xml  { head :ok }
    end
  end
  
  
  
  def execute_tasks
  

	# TODO bu fonksiyon ile crontab icin olan gonderme fonksiyonunu ayni yerden kullandirt yoksa ikisi arasinda farklilik olusabilir.
  
	@simdi = Time.zone.now
	@bas_tarihi = @simdi - @simdi.min.minutes - @simdi.sec.seconds # şu anki Türkiye saatinin başlangıcını hesaplar.
	@bit_tarihi = @bas_tarihi + 59.minutes + 59.seconds
	
	@unsents = EmailQueue.where(:sent => 0, :scheduled_at => (@bas_tarihi.utc)..(@bit_tarihi.utc)) # veritabanındaki tarihleri karşılaştırırken UTC olarak yapmalısın bu işi.
	#@unsents = EmailQueue.all # veritabanındaki tarihleri karşılaştırırken UTC olarak yapmalısın bu işi.
	@raporlanacaklar = Array.new
	
	@unsents.each do |unsent|
		#unsent.sent = true
		##TEST AMAÇLI OLDUĞUNDAN MAIL GÖNDERİMİMİNİ SADECE EĞER TASK İSMİ turker İSE YAPAR.
		#if unsent.task.name == 'turker'		
			#MAILI GONDER BU SATIRDA
			
			user = unsent.user
			message = unsent.message
			#eeksik_evrak_listesi = user.eksik_evrak_listesi
			eemail = user.email
			ename = user.name
			esurname = user.surname
			esubject = message.subject
			ebody = message.body

			
			# eksik_evraklar = 
			
			
			ScheduledMailer.duyuru_maili(eemail, ename, esurname, esubject, ebody).deliver # smtp ayarlarını, oluşturduğum app/config/initializers/setup_mail.rb den alıyor. dosya adı önemli değil içeriği önemli anladığım kadarıyla.
	
		#end
		unsent.update_attributes(:sent => 1) #bu başarılı çünkü modelde validasyonu update için devre dışı bıraktım yoksa eski tarih validasyonuma takılıyordu.
		@raporlanacaklar << unsent.user.email
	end
	
	
	@unsents_count = @unsents.count

  
  end
  
  
  
  
  
  
  
  
  
   private


  def task_params
    params.require(:task).permit(:name, :group_id, :message_id, :scheduled_at, :completed, :created_at, :updated_at)
  end
			
			

  def sort_column
    Task.column_names.include?(params[:sort]) ? params[:sort] : "scheduled_at"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end 
  
  def filter_archive
	%w[0 1].include?(params[:arsiv]) ? params[:arsiv] : "0"
  end



  
  
  
  # bunu ana kontrollere koydum
  # http://stackoverflow.com/questions/8138317/ror-undefined-method-http-basic-authenticate-with
  #def authentication_check
   #authenticate_or_request_with_http_basic do |user, password|
    #user == USER && password == PASSWORD
   #end
  #end
  
  
  
end

# sql group by hour of datetime

=begin
# http://stackoverflow.com/questions/10429611/mysql-group-by-hours
# asagidakinin çıktısı şu şekilde: 9:00-10:00 	13

SELECT   CONCAT(HOUR(scheduled_at), ':00-', HOUR(scheduled_at)+1, ':00') AS Saatler
  ,      COUNT(*) AS `Adet`
FROM     email_queues
WHERE    scheduled_at BETWEEN '2013-04-05' AND '2013-04-06'
GROUP BY HOUR(scheduled_at)


=end

#http://stackoverflow.com/questions/7911014/activerecord-find-and-only-return-selected-columns

#http://stackoverflow.com/questions/1414951/how-do-i-get-elapsed-time-in-milliseconds-in-ruby
=begin
def time_diff_milli(start, finish)
   (finish - start) * 1000.0
end

t1 = Time.now
# arbitrary elapsed time
t2 = Time.now

msecs = time_diff_milli t1, t2

=end

# ARGE add

# TODO Basic authentication