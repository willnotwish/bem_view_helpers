require 'bem_view_helpers/version'
require 'bem_view_helpers/view_helper'

require 'active_support/concern'

module BemViewHelpers
	extend ActiveSupport::Concern

	included do
		helper BemViewHelpers::ViewHelper
	end
end
