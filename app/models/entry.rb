class Entry < ApplicationRecord
  belongs_to :user

  validates :name, :username, :password,  presence: true
  validate :url_must_be_valid

  encrypts :username, deterministic: true
  encrypts :password

  scope :search_name, ->(name) { where(arel_table[:name].matches("%#{name}%")) if name.present? }

  def self.search(name)
    search_name(name).order(:name)
  end


  private

  def url_must_be_valid
    return if url.blank?

    unless url.include?("http://") || url.include?("https://")
      errors.add(:url, "must be valid")
    end
  end
end
