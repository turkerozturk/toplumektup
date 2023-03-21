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


class EmailQueuesController < ApplicationController
  # GET /email_queues
  # GET /email_queues.xml
  def index
  
  
  
    
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


	@email_queues = EmailQueue.where(:sent => 0)
	# bitti eğer kuyruk sayısı nil ise hata vermesin.
=begin	
	if @email_queues.count > 0
		@son_saat_basi = @unsent_email_queues.order("scheduled_at desc").first.scheduled_at.strftime("%Y-%m-%d %H:00:00").to_time - 3.hours # FIXME burada 3 diye yazma zaman dilimini hesaplat
		@son_saat_sonu = (@son_saat_basi + 59.minutes + 59.seconds) 
		@n = EmailQueue.where(:sent => 0, :scheduled_at => @u_saat_basi..@u_saat_sonu).count
		@nl = EmailQueue.where(:sent => 0, :scheduled_at => @son_saat_basi..@son_saat_sonu).count
	
	end
=end
#@l = @u.order("scheduled_at desc").first.scheduled_at.strftime("%Y-%m-%d %H:00:00").to_time
	@unsent_email_queues = EmailQueue.where(:sent => 0)
	#@l = @unsent_email_queues.order("scheduled_at desc").first.scheduled_at.strftime("%d.%m.%Y %H:00:00").to_time
	#@z = @l.to_time + 1.hour
	@saat_basi = (Time.zone.now - Time.zone.now.min.minutes - Time.zone.now.sec.seconds) # istanbul türkiye # BU tam doğru #Time object without minutes and seconds
	@saat_sonu = (Time.zone.now - Time.zone.now.min.minutes - Time.zone.now.sec.seconds + 59.minutes + 59.seconds) # istanbul türkiye # BU tam doğru #Time object without minutes and seconds
	@s_saat_basi = (Time.now - Time.now.min.minutes - Time.now.sec.seconds) #sunucu # BU tam doğru #Time object without minutes and seconds
	@s_saat_sonu = (Time.now - Time.now.min.minutes - Time.now.sec.seconds + 59.minutes + 59.seconds) #sunucu # BU tam doğru #Time object without minutes and seconds
	@u_saat_basi = (Time.now.utc - Time.now.utc.min.minutes - Time.now.utc.sec.seconds) #mysql # BU tam doğru #Time object without minutes and seconds
	@u_saat_sonu = (Time.now.utc - Time.now.utc.min.minutes - Time.now.utc.sec.seconds + 59.minutes + 59.seconds) #mysql # BU tam doğru #Time object without minutes and seconds


	# serverin saati:                                                       Time.now -> Wed Apr 03 22:20:06 -0700 2013
	# doğru Türkiye saati(ayar dosyasına istanbul yazdığımız için):         Time.zone.now veya Time.current -> Thu, 04 Apr 2013 08:21:04 EEST +03:00
	# yanlış hesaba neden olur: @tarih = Time.now.utc + (2 * 3600) # çünkü saatleri 31 martta 1 saat ileri alınca bu yalan oldu çünkü 2 değil 3 saat fark oluşuyor.
    # Time.zone.now.to_date -> Thu, 04 Apr 2013
    # Time.zone.now.to_date + 8.hour ->  Thu, 04 Apr 2013 08:00:00 EEST +03:00 (saat toplatarak saatler arası farkı buldurtmayı hedefliyoruz ancak dikkat et 2 veya 3 saat farkı yıl içinde değişir)
	# 59:59.999999
	# (Time.zone.now.to_date + Time.zone.now.hour).to_time
	# https://groups.google.com/forum/?fromgroups=#!topic/rubyonrails-talk/2u6Ac29nxjU Time object without minutes and seconds? 
	# BU tam doğru saat_basi = (Time.zone.now - Time.zone.now.min.minutes - Time.zone.now.sec.seconds) #Time object without minutes and seconds
	# BU tam doğru saat_sonu = (Time.zone.now - Time.zone.now.min.minutes - Time.zone.now.sec.seconds + 59.minutes + 59.seconds) #Time object without minutes and seconds

	#@n = @l.to_time + 1.hour
	
	# EmailQueue.where(:created_at => ("2013-04-05 20:00:00".to_date)..("2013-04-05 21:00:00".to_date))
	# a = Visitor.where(:created_at => (Time.current.to_date)..(Time.zone.now.to_date + 1.days))
	#a = Visitor.where(:created_at => (Time.current.to_date)..(Time.zone.now.to_date + 1.days)).count
	
#@ayhali = MoonPhase.where(["datetime <= CURDATE()"]).order('datetime DESC').first.datetime.to_date
#@ayhali = MoonPhase.where(["datetime <= CURDATE()"]).order('datetime DESC').first.phaseid




	
	
	
	
	
	
	

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @email_queues }
    end
  end

  # GET /email_queues/1
  # GET /email_queues/1.xml
  def show
    @email_queue = EmailQueue.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @email_queue }
    end
  end

  # GET /email_queues/new
  # GET /email_queues/new.xml
  def new
    @email_queue = EmailQueue.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @email_queue }
    end
  end

  # GET /email_queues/1/edit
  def edit
    @email_queue = EmailQueue.find(params[:id])
  end

  # POST /email_queues
  # POST /email_queues.xml
  def create
    @email_queue = EmailQueue.new(params[:email_queue])

    respond_to do |format|
      if @email_queue.save
        format.html { redirect_to(@email_queue, :notice => 'Email queue was successfully created.') }
        format.xml  { render :xml => @email_queue, :status => :created, :location => @email_queue }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @email_queue.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /email_queues/1
  # PUT /email_queues/1.xml
  def update
    @email_queue = EmailQueue.find(params[:id])

    respond_to do |format|
      if @email_queue.update_attributes(params[:email_queue])
        format.html { redirect_to(@email_queue, :notice => 'Email queue was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @email_queue.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /email_queues/1
  # DELETE /email_queues/1.xml
  def destroy
    @email_queue = EmailQueue.find(params[:id])
    @email_queue.destroy

    respond_to do |format|
      format.html { redirect_to(email_queues_url) }
      format.xml  { head :ok }
    end
  end
end
