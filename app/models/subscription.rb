class Subscription < ApplicationRecord
  belongs_to :magazine
  belongs_to :reader
end
