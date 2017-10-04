class Comment < ApplicationRecord
  belongs_to :post

  scope :approved, -> {where(approved: true)}

  def self.recent(look_back = 14.days)
  	where "created_at < ?", look_back.from_now
  end
end
