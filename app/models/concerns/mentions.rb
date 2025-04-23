module Mentions
  extend ActiveSupport::Concern

  included do
    has_many :mentions, as: :source, dependent: :destroy
    has_many :mentionees, through: :mentions
    before_save :remember_mentionable_content
    after_touch :remember_mentionable_content
    after_save_commit :create_mentions_later, if: :mentionable_content_changed?
  end

  def create_mentions(mentioner: Current.user)
    scan_mentionees.each do |mentionee|
      mentionee.mentioned_by mentioner, at: self
    end
  end

  def mentionable_content
    markdown_associations.collect do |association|
      send(association.name)&.to_plain_text
    end.compact.join(" ")
  end

  private
    def markdown_associations
      self.class.reflect_on_all_associations(:has_one).filter { it.klass == ActionText::Markdown }
    end

    def remember_mentionable_content
      @mentionable_content_before_save ||= self.class.find(id).mentionable_content if id && !previously_new_record?
    end

    def create_mentions_later
      Mention::CreateJob.perform_later(self, mentioner: Current.user)
    end

    def mentionable_content_changed?
      previously_new_record? || @mentionable_content_before_save != mentionable_content
    end

    def scan_mentionees
      scan_mentioned_handles.filter_map do |mention|
        mentionable_users.find { |user| user.mentionable_handles.include?(mention) }
      end
    end

    def mentionable_users
      collection.users
    end

    def scan_mentioned_handles
      mentionable_content.scan(/(?<!\w)@(\w+)/).flatten.uniq(&:downcase)
    end
end
