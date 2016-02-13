class Wish < ActiveRecord::Base
  belongs_to :author, class_name:"User"
  has_many :donor_links
  has_many :donor_connections, through: :donor_links, source: :connection
  has_many :donee_links
  has_many :donee_connections, through: :donee_links, source: :connection

  STATE_AVAILABLE=0
  STATE_CALL_FOR_CO_DONORS=1
  STATE_RESERVED=5
  STATE_ACQUIRED=9
  STATE_FULFILLED=10

  validates :title, presence: true
  validates :author, presence: true
end
