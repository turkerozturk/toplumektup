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


class GroupsUsersRelation < ActiveRecord::Base
belongs_to :group #, :dependent => :restrict
belongs_to :user #, :dependent => :restrict

# http://www.seanbehan.com/validate-uniqueness-on-join-tables-in-rails
# http://stackoverflow.com/questions/3276110/rails-3-validation-on-uniqueness-on-multiple-attributes

#validates :group, :uniqueness => {:scope => :recipient}

# bu ise yaramadi, web sayfasini reload yapinca ayni kaydi ikinci defa ucuncu defa ekliyor yani. ben de migration dosyasi olusturup varolan indeksi kaldirip unique parametresi ile yeniden olusturdum ve rake db:migrate yaptim. tabi veritabani hata veriyor, vermemesi icin de birsey yapmak lazim.
#validates_uniqueness_of :recipient_id, :scope => :group_id

end
