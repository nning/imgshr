module BossTokenAble
  def self.included(base)
    base.class_eval do
      before_action :boss_token, only: [:show]
      base.extend BossTokenAble
    end
  end

  def writable?
    !(gallery.read_only && !boss_token)
  end

  protected

  def boss_token
    return if skip_boss_token?

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

  def skip_boss_token(*actions)
    @@_skip_boss_token       ||= {}
    @@_skip_boss_token[self]   = actions.map(&:to_s)
  end

  def skip_boss_token?
    return false unless defined? @@_skip_boss_token

    controller_entry = @@_skip_boss_token[self.class]

    if controller_entry && controller_entry.include?(params[:action])
      return true
    end

    false
  end
end
