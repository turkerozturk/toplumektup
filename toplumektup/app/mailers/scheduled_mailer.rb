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


class ScheduledMailer < ActionMailer::Base

  #default :from => "turker@example.org"
  	# http://stackoverflow.com/questions/957422/rails-actionmailer-format-sender-and-recipient-name-email-address  
    require 'mail'
    address = Mail::Address.new "info@example.org" # ex: "john@example.com"
    address.display_name = "Falanca Derneği" # ex: "John Doe"
    # Set the From or Reply-To header to the following:
    #address.format # returns "John Doe <john@example.com>"
    #default :from => "info@example.org"
	default :from => address.format
  def duyuru_maili(email, name, surname, subject, body)
    
    #@ip = ip
    #mail(:to => "turkerozturk@example.org", :subject => "toplumail.example.org Test Duyurusu#{ip}")
	 
	@email = email
	@name = name
	@surname = surname
	@subject = subject
	@simdi = Time.zone.now.to_s
	@body = body
	#@body = "<p>Sayın #{@name} #{@surname},</p><br /><br />" + body #  + "<br /><br /><p>Not: Bu test mesajı, toplumail.turkerozturk.com yazılımındaki görevin manuel çalıştırılması ile gönderildi.</p>"
	#http://stackoverflow.com/questions/8381499/replace-words-in-string-ruby
	#sentence["{isim}"] = @name
	#sentence["{soyad}"] = @surname
	#sentence["{email}"] = @email
	#sentence["{simdi}"] = Time.zone.now
	#r = /\{isim\}/i
	
	
	

	@body.gsub!(/\{isim\}/i,@name)
	@body.gsub!(/\{soyad\}/i,@surname)
	@body.gsub!(/\{email\}/i,@email)
	@body.gsub!(/\{simdi\}/i,@simdi)
	# bunu tasks_controller icine koydum @body.gsub!(/\{eksik_evraklar\}/i,@simdi)
	user = User.where(:email => @email).first
	
	if @body.match(/\{eksik_evraklar\}/i)
		eksik_evraklar = user.eksik_evrak_listesi.join('<br />')
		@body.gsub!(/\{eksik_evraklar\}/i,eksik_evraklar)
	end
	#@body = body.html_safe
	
	
	  #mail(to: user.email, body: email_body, content_type: "text/html", subject: "Already rendered!")
	  # SELECT email FROM `users` where id IN (SELECT user_id FROM `email_queues` where sent = 0 and task_id =57)
   # begin
      mail(:to => "#{@email}", :subject => "#{@subject}", :body => @body, :content_type => "text/html; charset=UTF-8")
	#rescue
	
	#end
	
	
  end
end


# http://rbjl.net/13-organise-your-code-comments-with-rake-notes-todo
# TODO email gövdesi içerisine değişken pass etmek. Şu anda :body parametresini komple gönderiyorum ama o zaman da dosya olarak duran şablon devredışı kalıyor.

# TODO kendine bir rake notes:custom ANNOTATION=BİTTİ kelimesi belirle bitmiş işler için http://rbjl.net/13-organise-your-code-comments-with-rake-notes-todo

# BITTI custom kelime yani komment başına koyduğun kelimeyi todo veya fixme gibi rake ile buldurtmak. Fakat konsolda Türkçe karakter problemi var ve case sensitiv olduğundan büyük I kullandım.