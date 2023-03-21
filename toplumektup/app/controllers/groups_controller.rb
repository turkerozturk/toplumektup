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


class GroupsController < ApplicationController
  helper_method :sort_column, :sort_direction, :filter_archive

  # GET /groups
  # GET /groups.xml
  def index
    #@groups = Group.all
	#@groups = Group.order(sort_column + " " + sort_direction).search(params[:search], params[:filter])
	@groups = Group.order(sort_column + ' ' + sort_direction)

	# "select * from recipients where id not in (SELECT distinct recipient_id FROM `groups_recipients` )"
	# http://stackoverflow.com/questions/2616978/is-there-an-activerecord-equivalent-to-using-a-nested-subquery-i-e-where-no    (activerecord not in subquery)
	@notmember = User.find_by_sql("select * from users where id not in(select distinct user_id from groups_users_relations) and blocked = 0")
=begin	
	  def self.not_used_by(account)
      
  end
=end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.xml
  def show
    @group = Group.find(params[:id])
	
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.xml
  def new
    @group = Group.new
	
	#@abder_uyeleri = User.select('distinct email, name, surname, id').where(:blocked => 0, :member => 1)
	 @grubun_uyesi_olmayanlar = User.select('distinct email, name, surname, id').where(:blocked => 0).order("name asc").group("email, name, surname, id").all - @group.users #- @abder_uyeleri#.count # çoklu distinct yapınca sql sorgusu doğru olmasına rağmen count değeri mantıksız bir biçimde sanki select * . count yapmış gibi hepsini verdiğinden bu şekilde kaynak tüketmeyen ve doğru count veren bir çözüm uyguladık. http://stackoverflow.com/questions/5092745/rails-3-difference-between-relation-count-and-relation-all-count
   
	# @grubun_uyesi_olmayanlar = User.select('distinct email, name, surname, id').where(:blocked => 0).order("name asc").group("email, name, surname, id").all - @group.users #.count # çoklu distinct yapınca sql sorgusu doğru olmasına rağmen count değeri mantıksız bir biçimde sanki select * . count yapmış gibi hepsini verdiğinden bu şekilde kaynak tüketmeyen ve doğru count veren bir çözüm uyguladık. http://stackoverflow.com/questions/5092745/rails-3-difference-between-relation-count-and-relation-all-count
     @grubun_uyesi_olmayanlarin_sayisi = @grubun_uyesi_olmayanlar.count
	 
    @grubun_uyesi_olanlar = @group.users.order("name asc")
	@grubun_uyesi_olanlarin_sayisi = @grubun_uyesi_olanlar.count

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
	#@grubun_uyesi_olmayanlar = User.order("name asc").all - @group.users
	 @grubun_uyesi_olmayanlar = User.select('distinct email, name, surname, id').where(:blocked => 0).order("name asc").group("email, name, surname, id").all - @group.users#.count # çoklu distinct yapınca sql sorgusu doğru olmasına rağmen count değeri mantıksız bir biçimde sanki select * . count yapmış gibi hepsini verdiğinden bu şekilde kaynak tüketmeyen ve doğru count veren bir çözüm uyguladık. http://stackoverflow.com/questions/5092745/rails-3-difference-between-relation-count-and-relation-all-count
    @grubun_uyesi_olmayanlarin_sayisi = @grubun_uyesi_olmayanlar.count
	 
	@grubun_uyesi_olanlar = @group.users.order("name asc")
	@grubun_uyesi_olanlarin_sayisi = @grubun_uyesi_olanlar.count
	
	
	@users = User.find_by_sql("select name from users")	
  end

  # POST /groups
  # POST /groups.xml
  def create
    @group = Group.new(group_params)
	@grubun_uyesi_olmayanlar = User.all
	# TODO view dosyasında @grubun_uyesi_olanlar hata vermiyor ama ne yapsak daha iyi olur?
	if params.has_key?(:userk)
		@userk = params[:userk]
		# http://stackoverflow.com/questions/4982371/handling-unique-record-exceptions-in-a-controller
		begin
			@group.users << User.find(@userk)
		rescue
			# unique veri ise hata olusunca hatayş ekrana yazmamasi icin begin rescue kullandik ve ekrana ayni sayfayi getirdigin icin hatayi gostermiyor hata oldugunu anlayamiorsun.
		
		end
	end	
    respond_to do |format|
      if @group.save
        format.html { redirect_to(@group, :notice => 'Group was successfully created.') }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.xml
  def update
    @group = Group.find(params[:id])
	if params.has_key?(:userk)
		@userk = params[:userk]
		# http://stackoverflow.com/questions/4982371/handling-unique-record-exceptions-in-a-controller
		begin
			@group.users << User.find(@userk)
		rescue
			# unique veri ise hata olusunca hatayş ekrana yazmamasi icin begin rescue kullandik ve ekrana ayni sayfayi getirdigin icin hatayi gostermiyor hata oldugunu anlayamiorsun.
		
		end
	end	
	if params.has_key?(:usern)
		@usern = params[:usern]
		@group.users.delete(User.find(@usern))
		

	end

    respond_to do |format|
      #if @group.update_attributes(params[:group])
      if @group.update(group_params)
        format.html { redirect_to(@group, :notice => 'Group was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.xml
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to(groups_url) }
      format.xml  { head :ok }
    end
  end
  
  private

  def group_params
    params.require(:group).permit(:name, :description, :created_at, :updated_at)
  end


  def sort_column
    Group.column_names.include?(params[:sort]) ? params[:sort] : 'name'
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end 

  def filter_archive
	%w[0 1].include?(params[:arsiv]) ? params[:arsiv] : '0'
  end
  
end
