class ReviewScore < ApplicationRecord
  belongs_to :event_rating
  belongs_to :review_metric
  has_one :event, through: :event_rating
  has_one :conference, through: :event_rating

  after_save :update_average
  after_destroy :update_average

  validates :score, inclusion: 0..5 # 0 is N/A
  validates :review_metric, presence: true, uniqueness: { scope: :event_rating }
  validates :event_rating, presence: true

  protected

  def update_average
    event_rating.event.recalculate_review_averages!
  end
end