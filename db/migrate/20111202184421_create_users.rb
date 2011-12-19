class CreateUsers < ActiveRecord::Migration
  #chaning method name from 'change' to "self.up"
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
  end
  
  #this was not autogenerated from 'generate model User name:string email:string' - not sure why, need to google this and see if it has to do with rails 3.1; adding code from book for now. 
  def self.down
    drop_table :users
  end
end