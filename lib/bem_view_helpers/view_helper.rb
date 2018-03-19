# view_helper.rb

require 'bem_view_helpers/builder'

module BemViewHelpers
	module ViewHelper

	  def bem_block( name, content=nil, options={}, &block )
	  	builder = Builder.new( nil, self )
	  	builder.block( name, content, options, &block )
	  end
	end
end