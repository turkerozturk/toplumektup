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
:user_name => 'info@example.org.tr',
:password => '11111',
:authentication => :login,
:openssl_verify_mode => 'none',
:enable_starttls_auto => true  
=end

# YANDEX ESKİ HOSTING SMTP AYARI
=begin
:address => 'smtp.yandex.ru',
:port => 587,
:domain => "smtp.yandex.ru", 
:user_name => 'info@1111.org.tr',
:password => '11111',
:authentication => :plain,
:openssl_verify_mode => 'none',
:enable_starttls_auto => true  
=end

# MARKUM HOSTING SMTP AYARI
=begin
:address => 'mail.aaaaaa.org.tr',
:port => 587,
:domain => "mail.aaaaaaa.org.tr", 
:user_name => 'info@aaaaaa.org.tr',
:password => 'aaaaaaa',
:authentication => :plain,
:openssl_verify_mode => 'none',
:enable_starttls_auto => true  
=end

# GMAIL HOSTING SMTP AYARI
:address              => "smtp.gmail.com",
:port                 => 587,
:domain               => 'smtp.gmail.com',
:user_name            => 'aaaaa.aaaaa.aaaaa@gmail.com',
:password             => 'aaaaaa',
:authentication       => 'plain',
:enable_starttls_auto => true 

=begin
:address => 'mail.aaaaaa.com',
:port => 587,
:domain => "mail.aaaaaa.com", 
:user_name => 'aaaaaa@aaaaa.com',
:password => 'aaaaaa',
:authentication => :plain,
:openssl_verify_mode => 'none',
:enable_starttls_auto => true  
=end
}

=begin
		$mail = new PHPMailer(true); //defaults to using php "mail()"; the true param means it will throw exceptions on errors, which we need to catch.

		$mail->CharSet="utf-8";

		

		$mail->IsSMTP(); // telling the class to use SMTP

		$mail->Host       = "mail.aaaaaa.org.tr"; // SMTP server

		$mail->SMTPDebug  = 0;                     // enables SMTP debug information (for testing)

												   // 1 = errors and messages

												   // 2 = messages only

		$mail->SMTPAuth   = true;                  // enable SMTP authentication

		//$mail->SMTPSecure = 'tls';

		$mail->Port       = 587;                    // set the SMTP port for the GMAIL server

		$mail->Username   = "aaaaaa@aaaaaa.org.tr"; // SMTP account username

		$mail->Password   = "aaaaaa";        // SMTP account password

		$mail->IsHTML(true);

		 

		



		$mail->AddAddress($email,$fullname); //formu doldurana da gitmesi için

		$mail->AddBCC("aaaaaa@aaaaaa.org.tr"); // Bir kopyasını kendimize gizli olarak gönderiyoruz.

		$mail->AddBCC("aaaaaa@gmail.com"); // test amaçlı kendimize gönderdikleririmizi de BCC ile saklıyoruz.

		$mail->SetFrom("aaa@aaaaa.org.tr", "zzzzzz Derneği (Etkinlik Kayıt İşlemi)"); //bu satir cok onemli, koymazsan diger satirlar dogru olsa bilemailgitmeyip hata veriyor. Zaten KİMDEN kısmında görünecek. Ve SMTP helo domain problemi olmaması için o domaindeki bir mail adresi olmalı.

		//$mail->AddReplyTo($email, $fullname);

		$mail->AddReplyTo("aaaaa@aaaaa.org.tr", "zzzzzz Derneği (Etkinlik Kayıt İşlemi)");

		$mail->Subject = $subject;

		$mail->Body = $message;

=end