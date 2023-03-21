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


#encoding: UTF-8

# kullanımı:
# Isim Göbekadı Soyad	isimsoyad@gmail.com	Öğrenci
# biçiminde yukarıdaki gibi her satırda tablarla ayrılmış olarak isimsoyad email occupation bilgilerini import.txt dosyasına koyup
# bu scripti konsoldan çalıştıracaksınız.
# bunu yapabilmek için de sadece o bilgileri phpmyadmin ile export edip metin belgesine yapıştırmak gerek.
# sadece databaseda olmayan emailların olduğu satırları databasea kaydeder.

require "rubygems"
require "active_record"

ActiveRecord::Base.establish_connection(  adapter: 'mysql2',  host: 'localhost',  username: 'mysqluserhere',  password: 'mysqlpasswordhere',  database: 'toplumektup',  encoding: 'utf8',  socket: '/var/run/mysqld/mysqld.sock'  )
  
class User < ActiveRecord::Base
end

sayac1,sayac2,sayac3 = 0,0,0
File.open("import.txt", "r").each_line do |line|
  
  data = line.split(/\t/)
  fullname = data[0]
  kelimeler = fullname.split(" ").map(&:strip)
  case kelimeler.size 
    when 0
     isim = 'Isim'
     soyad = 'Soyad'
    when 1
     isim = kelimeler.first
     soyad = "Soyad"
    when 2
     isim = kelimeler.first
     soyad = kelimeler.last
    else
     isim = kelimeler.first(kelimeler.size - 1).join(' ')
     soyad = kelimeler.last
   end




  email = data[1].strip
  occupation = data[2]

  u = User.find_by_email(email)

  if u.blank?
    sayac2 += 1
    puts "YENI: #{email} ISIM: #{isim} SOYAD: #{soyad}"

    yeni = User.create(:name => isim, :surname => soyad, :email => email, :occupation => 
occupation, :blocked => 0, :photo => 'yok.jpg')

 
  else
    sayac3 += 1
    puts "ESKI: #{u.email} I: #{u.name}(#{isim}) S: #{u.surname}(#{soyad})"
  end

  sayac1 += 1
end

puts "#{sayac1} KAYITTA #{sayac2} YENI, #{sayac3} ESKI"


