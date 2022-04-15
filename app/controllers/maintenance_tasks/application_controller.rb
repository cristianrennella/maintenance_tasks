# frozen_string_literal: true

module MaintenanceTasks
  # Base class for all controllers used by this engine.
  #
  # Can be extended to add different authentication and authorization code.
  class ApplicationController < ActionController::Base
    before_action :require_admin

    BULMA_CDN = "https://cdn.jsdelivr.net"

    content_security_policy do |policy|
      policy.style_src(
        BULMA_CDN,
        # ruby syntax highlighting
        "'sha256-y9V0na/WU44EUNI/HDP7kZ7mfEci4PAOIjYOOan6JMA='",
      )
      policy.script_src(
        # page refresh script
        "'sha256-kOtH9RgO29UNB3GHLZpYttLMkK0yn5uWA9jDK1WLXlQ='",
      )
      policy.frame_ancestors(:self)
    end

    before_action do
      request.content_security_policy_nonce_generator ||=
        ->(_request) { SecureRandom.base64(16) }
      request.content_security_policy_nonce_directives = ["style-src"]
    end

    protect_from_forgery with: :exception

    private

    def require_admin
      redirect_to main_app.root_path, flash: {danger: "No estas autorizado."} unless current_user&.admin?
    end
  end
end
