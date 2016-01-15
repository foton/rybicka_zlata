class Person < ActiveRecord::Base
	#obdarovany
	belongs_to :donee, class_name: User 
	#darce
	belongs_to :donor, class_name: User

	

end