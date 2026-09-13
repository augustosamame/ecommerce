module Ecommerce
  # Per-request theme state. ActiveSupport resets it around every request and
  # job, so a theme resolved for one host never leaks into another thread.
  # (Named ThemeContext rather than Current: the engine already relies on the
  # host app's ::Current for platform/user.)
  class ThemeContext < ActiveSupport::CurrentAttributes
    # Settings hash from Ecommerce.host_themes for the requested host (or nil).
    attribute :theme_settings
  end
end
