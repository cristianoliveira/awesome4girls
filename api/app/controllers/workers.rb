# frozen_string_literal: true

# Implements auth on Sidekiq::Web.
#
# When authenticated user has information about workers.
#
class WorkersController < Sidekiq::Web
  def initialize
    use(Rack::Auth::Basic) do |name, password|
      user = User.find_by_name(name)
      user && user.auth?(password) && user.is_a?(User::ROLE_ADMIN)
    end
  end
end
