# builder.rb

module BemViewHelpers
  module ViewHelper
    class Builder

      attr_reader :current_block, :context

      delegate :capture, :content_tag, to: :context

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

      def header( name=nil, content=nil, options={}, &block )
        name ||= 'header'
        _bem( name, content, options.merge(tag_name: 'header'), &block)
      end

      def main( name=nil, content=nil, options={}, &block )
        name ||= 'main'
        _bem( name, content, options.merge(tag_name: 'main'), &block)
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
          capture( builder, &block )
        end 

        modifiers = options.map do |key, value|
          key = key.to_s
          next if key == 'html' || key == 'tag_name'

          value = value.call if value.respond_to? :call
          value ? key : nil
        end.compact

        
        html_classes = [current_name]
        modifiers.each do |modifier|
          html_classes << "#{current_name}--#{modifier}"
        end

        content_tag( (options[:tag_name] || :div), content, html_options.merge( class: html_classes.join(' ') ) )
      end
    end
  end
end
