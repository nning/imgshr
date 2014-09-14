module BossTokenAble
  def self.included(base)
    base.class_eval do
      before_action :boss_token, only: [:show]
    end
  end

  def writable?
    !(gallery.read_only && !boss_token)
  end

  protected

  def boss_token
    if session["boss_token_#{gallery.slug}"]
      @boss_token ||= BossToken.find_by_slug(session["boss_token_#{gallery.slug}"])
    end
  end

  def boss_token_session(gallery)
    session["boss_token_#{gallery.slug}"] = gallery.boss_token.slug
  end

  def enforce_read_only
    head :forbidden unless writable?
  end
end
