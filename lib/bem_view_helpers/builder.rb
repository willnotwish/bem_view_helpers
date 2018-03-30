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
      %i(header footer main section aside p).each do |tag_name|
        define_method tag_name do |name, content=nil, options={}, &block|
          _bem( name, content, options.merge(tag_name: tag_name), &block )
        end
      end

    private 

      def _bem( name, content, options, &block )
        if content && content.is_a?( Hash)
          options = content
          content = nil
        end

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


      # def header( name, content=nil, options={}, &block )
      #   _bem( name, content, options.merge(tag_name: :header), &block)
      # end

      # def footer( name, content=nil, options={}, &block )
      #   _bem( name, content, options.merge(tag_name: :footer), &block)
      # end

      # def main( name, content=nil, options={}, &block )
      #   _bem( name, content, options.merge(tag_name: :main), &block)
      # end

      # def paragraph( name, content=nil, options={}, &block )
      #   _bem( name, content, options.merge(tag_name: :p), &block)
      # end

      # def section( name, content=nil, options={}, &block )
      #   _bem( name, content, options.merge(tag_name: :section), &block)
      # end

      # def aside( name, content=nil, options={}, &block )
      #   _bem( name, content, options.merge(tag_name: :aside), &block)
      # end

