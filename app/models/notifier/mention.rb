class Notifier::Mention < Notifier
  alias mention source

  private
    def resource
      mention.source
    end

    def recipients
      if mention.self_mention?
        []
      else
        [ mention.mentionee ]
      end
    end

    def creator
      mention.mentioner
    end
end
