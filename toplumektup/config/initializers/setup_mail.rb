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


# SMTP configuration
#ActionMailer.delivery_method = :smtp
#http://asciicasts.com/episodes/206-action-mailer-in-rails-3
#http://stackoverflow.com/questions/5021416/rails-3-actionmailer-error-hostname-was-not-match-with-the-server-certificate
ActionMailer::Base.smtp_settings = {

# YANDEX HOSTING SMTP AYARI artık ssl istiyor bir de o mail robot olmadığı anlaşıldın diye telefon numarası ve diğer kişisel bilgileri doldurmak gerekiyor.
=begin
:address => 'smtp.yandex.ru',
:port => 465,
:domain => "smtp.yandex.ru", 
:user_name => 'info@example.org',
:password => 'passwordhere',
:authentication => :login,
:openssl_verify_mode => 'none',
:enable_starttls_auto => true  
=end

# YANDEX ESKİ HOSTING SMTP AYARI

:address => 'smtp.yandex.ru',
:port => 587,
:domain => "smtp.yandex.ru", 
:user_name => 'info@example.org',
:password => 'passwordhere',
:authentication => :plain,
:openssl_verify_mode => 'none',
:enable_starttls_auto => true  


# MARKUM HOSTING SMTP AYARI
=begin
:address => 'mail.example.net',
:port => 587,
:domain => "mail.example.net", 
:user_name => 'info@example.net',
:password => 'passwordhere',
:authentication => :plain,
:openssl_verify_mode => 'none',
:enable_starttls_auto => true  
=end

=begin
:address => 'mail.example.net',
:port => 587,
:domain => "mail.example.net", 
:user_name => 'user@example.net',
:password => 'passwordhere',
:authentication => :plain,
:openssl_verify_mode => 'none',
:enable_starttls_auto => true  
=end
}

=begin
		$mail = new PHPMailer(true); //defaults to using php "mail()"; the true param means it will throw exceptions on errors, which we need to catch.

		$mail->CharSet="utf-8";

		

		$mail->IsSMTP(); // telling the class to use SMTP

		$mail->Host       = "mail.example.org"; // SMTP server

		$mail->SMTPDebug  = 0;                     // enables SMTP debug information (for testing)

												   // 1 = errors and messages

												   // 2 = messages only

		$mail->SMTPAuth   = true;                  // enable SMTP authentication

		//$mail->SMTPSecure = 'tls';

		$mail->Port       = 587;                    // set the SMTP port for the GMAIL server

		$mail->Username   = "kayit@example.org"; // SMTP account username

		$mail->Password   = "passwordhere";        // SMTP account password

		$mail->IsHTML(true);

		 

		



		$mail->AddAddress($email,$fullname); //formu doldurana da gitmesi için

		$mail->AddBCC("kayit@example.org"); // Bir kopyasını kendimize gizli olarak gönderiyoruz.

		$mail->AddBCC("genelmudur@example.net"); // test amaçlı kendimize gönderdikleririmizi de BCC ile saklıyoruz.

		$mail->SetFrom("kayit@example.org", "Falanca Derneği (Etkinlik Kayıt İşlemi)"); //bu satir cok onemli, koymazsan diger satirlar dogru olsa bilemailgitmeyip hata veriyor. Zaten KİMDEN kısmında görünecek. Ve SMTP helo domain problemi olmaması için o domaindeki bir mail adresi olmalı.

		//$mail->AddReplyTo($email, $fullname);

		$mail->AddReplyTo("kayit@example.org", "Falanca Derneği (Etkinlik Kayıt İşlemi)");

		$mail->Subject = $subject;

		$mail->Body = $message;

=end