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


=begin

	BU SCRIPT NE İŞE YARAR?
	CRON GÖREVİ İLE SÜREKLİ OLARAK ÇALIŞTIRILIR.
	VERİTABANINDA GÖNDERİLMEYİ BEKLEYEN VE ZAMANI GELMİŞ MESAJLAR VARSA İLGİLİLERE GÖNDERİR.



=end

@simdi = Time.zone.now
	@bas_tarihi = @simdi - @simdi.min.minutes - @simdi.sec.seconds # şu anki Türkiye saatinin başlangıcını hesaplar.
	@bit_tarihi = @bas_tarihi + 59.minutes + 59.seconds
	
	@unsents = EmailQueue.where(:sent => 0, :scheduled_at => (@bas_tarihi.utc)..(@bit_tarihi.utc)) # veritabanındaki tarihleri karşılaştırırken UTC olarak yapmalısın bu işi.
	#@unsents = EmailQueue.all # veritabanındaki tarihleri karşılaştırırken UTC olarak yapmalısın bu işi.
  @unsents.each do |unsent|
    puts "haha"

  end
    exit
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



puts "qqq"




#require '/home/toplumektup/.gems/gems/bcrypt-ruby-3.0.1/lib/bcrypt'
	#@s = @task.email_queue.select("HOUR(scheduled_at) AS Saat , COUNT(*) AS `Adet`").where(:scheduled_at => @gun_bas.utc..@gun_bit.utc).group("HOUR(scheduled_at)")
# http://logeshprabu.wordpress.com/2011/04/30/cronjob-for-rails-runner/
# buna ait cronjob su sekilde
#  */10 * * * * /home/toplumektup/toplumektup.turkerozturk.com/script/rails runner /home/toplumektup/toplumektup.turkerozturk.com/turker/send.rb
# */10 * * * * cd /home/toplumektup/toplumektup.turkerozturk.com/ && /home/toplumektup/toplumektup.turkerozturk.com/script/rails runner /home/toplumektup/toplumektup.turkerozturk.com/turker/send.rb
# o satırı crontab -e ile olusturdugumuz dosyanin icine yapitiriyoruz. her 15 dakikada bir calisir.
# http://stackoverflow.com/questions/6092292/cron-job-rails-3-loading-system-ruby-not-rvm-ruby
# http://wiki.dreamhost.com/RubyGems


# BUNDLER GEM BULAMAZ CRONDA HATA VERIR, MESELA BCRYPT GEMINI YUKLEDIKTEN SONRA YUKARIDAKI CALISMADI ASAGIDAKI ILE CALISTIRDIM YANI BASINA bash --login - c yazip komutu da tirnak icine aldim.
# basla
# BUNUNLA HALLETTIM http://stackoverflow.com/questions/5849090/cron-job-cant-get-it-to-run-what-syntax-to-use-for-the-crontab #tabi zaman kismini web arayuzunde yazma oradan tiklayarak sec.
# */10 * * * * bash --login -c 'cd /home/toplumektup/toplumektup.turkerozturk.com/ && /home/toplumektup/toplumektup.turkerozturk.com/script/rails runner /home/toplumektup/toplumektup.turkerozturk.com/turker/send.rb'
# bit
=begin
Cron jobs don't load the user's environment. Try adding RAILS_ENV=production before your command within crontab, or whichever environment you need.

Example:

RAILS_ENV=production
*/3 * * * * /your/command/here

OR, if you want to make sure you have your user's full environment, execute the command within a login shell:

*/3 * * * * bash --login -c '/your/command/here'

=end
