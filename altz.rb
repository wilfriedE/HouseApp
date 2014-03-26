require 'sinatra'

class String
  def to_bool
  return true if self == true || self =~ (/(true|t|yes|y|1)$/i)
  return false if self == false || self.empty? || self =~ (/(false|f|no|n|0)$/i)
  raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end
class UserInfo

  attr_accessor :name, :age, :app, :psen1, :psen2, :ds, :father, :mother, :mgram, :mgramp, :pgram, :pgramp, :risk, :low_risk, :high_risk
  def age
    @age
  end

  def age=(str)
    @age = str
  end
 
end 

def check_for(arg, person, continue)
 
 if arg == 'app'

  if person.app.to_bool == true
    person.risk = 100
  else
    check_for('psen1', person, true )
  end

 elsif arg == 'psen1'

  if person.psen1.to_bool == true
    person.risk = 100
  else
    check_for('psen2', person, true  )
  end

 elsif arg == 'psen2'

  if person.psen2.to_bool == true
    person.risk = 95
    check_for('ds', person, false)    
  else
    check_for('ds', person, true ) 
  end

 elsif arg == 'ds'

  if person.ds.to_bool == true

    person.low_risk = 25
    if continue  #ONLY when psen2 is false then continue is true
      person.high_risk = person.risk
      check_for_parents('directparent', person, true)
    else
      person.high_risk = 95
      person.risk = nil
    end

  else
  
    if continue 
      person.high_risk = person.risk
        check_for_parents('directparent', person, true)
    end

  end

 else 
 end
if person.risk
 person.high_risk = person.risk
 end 
end

 def check_for_parents(arg, person, continue)

  if arg == 'directparent'
    
    if person.father.to_bool == true && person.mother.to_bool == true
      person.risk = 100
      person.low_risk = nil
    elsif person.father.to_bool == true && person.mother.to_bool == false
      person.risk = 50
      check_for_parents('maternalparent', person, true)
    elsif person.father.to_bool == false && person.mother.to_bool == true
      person.risk = 50
      check_for_parents('paternalparent', person, true)
    elsif person.father.to_bool == false && person.mother.to_bool == false
       person.risk = 0
      check_for_parents('paternalparent', person, true)
      check_for_parents('maternalparent', person, true)
    end
    
  elsif arg == 'maternalparent'
    if person.mgramp.to_bool || person.mgram.to_bool == true
        if person.mgramp.to_bool == true && person.mgram.to_bool == true
        person.risk += 50
      else 
        person.risk += 25 
      end
    end
  
  elsif arg == 'paternalparent'
    if person.pgramp.to_bool || person.pgram.to_bool == true
      if person.pgramp.to_bool == true && person.pgram.to_bool == true
      person.risk += 50
      else
      person.risk += 25
 
      end
    end
  end
if person.risk
 person.high_risk = person.risk
 end 
end

  set :public_folder => "public", :static => true

  get "/" do
    erb :welcome
  end
  get "/validates_age" do 
  	if !params[:age].to_s.empty? && !params[:name].to_s.empty?
	  	if params[:age].to_i > 64
	  		erb :too_old
	  	else
	  		redirect  "/analyze?name=#{params[:name]}&age=#{params[:age]}" 
	  	end
	  else 
	 	"<h1>You need to input both your name and age, in order to continue.</h1>"
	  end
  end
  
  get '/analyze' do
  	erb :evaluate_case
  end
  post "/analyze" do
 	User = UserInfo.new
	User.age = params[:age]
	User.name = params[:name]
	if params[:app]
		User.app = params[:app]
	else
	 	User.app = "false"
	end

	if params[:psen1]
		User.psen1= params[:psen1]
	else
	 	User.psen1 = "false"
	end

	if params[:psen2]
		User.psen2 = params[:psen2]
	else
	 	User.psen2 = "false"
	end

	if params[:ds]
		User.ds = params[:ds]
	else
	 	User.ds = "false"
	end
	if params[:father]
		User.father = params[:father]
	else
	 	User.father = "false"
	end
 
	if params[:app]
		User.mother = params[:mother]
	else
	 	User.mother = "false"
	end
	 
	if params[:mgram]
		User.mgram = params[:mgram]
	else
	 	User.mgram = "false"
	end
	 
	 if params[:mgramp]
		User.mgramp = params[:mgramp]
	else
	 	User.mgramp = "false"
	end
	 
	if params[:pgram]
		User.pgram = params[:pgram]
	else
	 	User.pgram = "false"
	end
 
	if params[:pgramp]
		User.pgramp= params[:pgramp]
	else
	 	User.pgramp = "false"
	end
   check_for('app', User, true)
   @user = User
   erb :results
  end
