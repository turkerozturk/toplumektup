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


# encoding: utf-8
class MessagesController < ApplicationController
#rake db:migrate RAILS_ENV="production" 
  helper_method :sort_column, :sort_direction, :filter_archive
  
  
  
#http://stackoverflow.com/questions/4136248/how-to-generate-a-human-readable-time-range-using-ruby-on-rails
# bu fonksiyonu bulduğum çok iyi oldu adam iyi ki yapmış. ancak negatiflerde işe yaramıyor vereceğin sayı pozitif olmalı.
	def humanize_datetime secs
	  [[60, :saniye], [60, :dakika], [24, :saat], [1000, :gün]].map{ |count, name|
		if secs > 0
		  secs, n = secs.divmod(count)
		  "#{n.to_i} #{name}"
		end
	  }.compact.reverse.join(' ')
	end
  # GET /messages
  # GET /messages.xml
  def index
    #@messages = Message.all
		#d= "desc"
	
	
	@arsiv = params[:arsiv]
	if @arsiv == "1"
		@messages = Message.where(:used => 1).order(sort_column + " " + sort_direction).search(params[:search], params[:filter])
	else	
		@messages = Message.where(:used => 0).order(sort_column + " " + sort_direction).search(params[:search], params[:filter])
	end
	
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @messages }
    end
  end

  # GET /messages/1
  # GET /messages/1.xml
  def show
    @message = Message.find(params[:id])
    #@users = User.find(EmailQueue.where(:message_id => @message.id).select(:user_id).map {|i| i.user_id})


    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/new
  # GET /messages/new.xml
  def new
=begin  
	@message = Message.new
	@total_daily_quota = Sender.sum(:dailyquota)
	@total_remaining_quota = @total_daily_quota - Sender.sum(:remainingquota)
	@total_users_count = User.where(:status => 1).count
=end
  
    @message = Message.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/1/edit
  def edit
    @message = Message.find(params[:id])
  end

  # POST /messages
  # POST /messages.xml
  def create
    #@message = Message.new(params[:message])
    @message = Message.new(message_params)


    respond_to do |format|
      if @message.save
        format.html { redirect_to(@message, :notice => 'Message was successfully created.') }
        format.xml  { render :xml => @message, :status => :created, :location => @message }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.xml
  def update
    @message = Message.find(params[:id])

    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to(@message, :notice => 'Message was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.xml
  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to(messages_url) }
      format.xml  { head :ok }
    end
  end
  
  
  	def duplicate
		@source_message = Message.find(params[:id])
		@message = Message.new(:subject => @source_message.subject, :body => @source_message.body)
		@message.save
		respond_to do |format|
         format.html { redirect_to(@message, :notice => 'Mesaj başarıyla teksir edildi.') }
		end
	
	end
	
	
	def show_recipients
		@message = Message.find(params[:id])
		#http://stackoverflow.com/questions/4241211/how-do-i-convert-an-activerecord-result-array-to-a-normal-array
		@users = User.where( id: EmailQueue.where(:message_id => @message.id).select(:user_id).map{|i| i.user_id} ).order('name asc') #istediğimiz user_id leri çektikten sonra hash dan arraye dönüştürmek için map komutunu kullanııp sonra da arraydekileri find ile bulduruyoruz.
  # BU HATA VERİR, YUKARIDAKİ WHERE OLANI KULLAN ÇÖZÜM: http://stackoverflow.com/questions/16180963/activerecord-finding-best-effort-results,  @users = User.find( EmailQueue.where(:message_id => @message.id).select(:user_id).map {|i| i.user_id}, :order => "name asc" ) #istediğimiz user_id leri çektikten sonra hash dan arraye dönüştürmek için map komutunu kullanııp sonra da arraydekileri find ile bulduruyoruz.

#.order("name asc")
	end
	
 
  private

  def message_params
    params.require(:message).permit(:subject, :body, :locked, :used, :sent_at, :description, :created_at, :updated_at)
  end
  
  def sort_column
    Message.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end 
  
  def filter_archive
	%w[0 1].include?(params[:arsiv]) ? params[:arsiv] : "0"
  end
  
  # BITTI mesajları listelenirken oluşturma tarihi en üstte olacak şekilde gelmeli.
  # TODO mesaja arşiv filtre checki düğmesi koy. Başlangıçta sayfa ilk geldiğinde arşivdeki mesajlar görünmesin.
  
  # TODO Konsol Turkce karakter problemini gider.
end
