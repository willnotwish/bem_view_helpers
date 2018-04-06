# builder.rb

module BemViewHelpers
  module ViewHelper
    class Builder

      attr_reader :current_block, :context

      def initialize( block, _context )
        @current_block = block
        @context = _context
      end

      def block( name, content=nil, options={}, &block )
        _bem( name, content, options, &block )    
      end

      def element( name, content=nil, options={}, &block )
        _bem( name, content, options, &block )    
      end

      # Sytactic sugar for common HTML tags
      %i(aside header footer main section p h1 h2 h3 h4 h5 nav).each do |tag_name|
        # define_method tag_name do |block_or_element_name=nil, content=nil, options={}, &block|
          # options, content = content, nil if content && content.is_a?( Hash )
        define_method tag_name do |*args, &block|
          options = args.extract_options!

          block_or_element_name, content = args[0], args[1]

          _bem( block_or_element_name || tag_name, content, options.merge(tag_name: tag_name), &block )
        end
      end

    private 

      def _bem( name, content, options, &block )
        options, content = content, nil if content && content.is_a?( Hash )

        raise ArgumentError, "Missing content or block" if content.nil? && !block_given?

        html_options = options[:html] ||= {}

        current_name = current_block ? "#{current_block}__#{name}" : name

        content ||= begin
          builder = self.class.new( current_name, context )
          context.capture( builder, &block )
        end 

        modifiers = options.map do |key, value|
          key = key.to_s
          next if key == 'html' || key == 'tag_name'

          value = value.call if value.respond_to? :call
          value ? key.dasherize : nil
        end.compact

        
        html_classes = [current_name]
        modifiers.each do |modifier|
          html_classes << "#{current_name}--#{modifier}"
        end

        html_options = html_options.merge( class: html_classes.join(' ') )

        tag_name = options[:tag_name] || :div
        context.content_tag( tag_name, content, html_options )
      end
    end
  end
end
