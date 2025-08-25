module User::AiQuota
  extend ActiveSupport::Concern

  DEFAULT_QUOTA = Ai::Quota::Money.wrap("$100").in_microcents

  included do
    has_one :ai_quota, class_name: "Ai::Quota"
  end

  def spend_ai_quota(cost)
    fetch_or_create_ai_quota.spend(cost)
  end

  def ensure_ai_quota_not_depleted
    fetch_or_create_ai_quota.ensure_not_depleted
  end

  private
    def fetch_or_create_ai_quota
      ai_quota || create_ai_quota!(limit: DEFAULT_QUOTA)
    end
end
