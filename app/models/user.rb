class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.validate_email_field = true # for available options see documentation in: Authlogic::ActsAsAuthentic
  end # block optional
  
  belongs_to :department
  has_many :stock_adjusments
  has_many :stock_transfers
  has_many :packs
  validates :department_id, :presence => true
  scope :active, where("disabled = false")

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end
end
