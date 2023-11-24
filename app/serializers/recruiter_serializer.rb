class RecruiterSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :company_name, :city, :mobile_no

  has_many :jobs
end
