module SanitizeParamsHelper
  # this module cleans form input and sanitizes value to prevent XSS vulns
  # Based on http://selvaonrails.wordpress.com/2012/04/03/ruby-on-rails-sanitize-4/ 
  
  def sanitize_vals(node)
    if node.respond_to?(:each)
      if node.is_a?(Array)
        sanitized=[]
        node.each do |k|
          val = k.is_a?(String) ? Sanitize.clean(k) : k
          sanitized << val
        end
      elsif node.is_a?(Hash)
        sanitized={}
        node.each do |k,v|
          if v.is_a?(Hash)
            sanitized[k] = sanitize_vals(v)
          else
            val = v.is_a?(String) ? Sanitize.clean(v) : v
            sanitized[k] = val
          end
        end
      else
        sanitized = node.is_a?(String) ? Sanitize.clean(node) : node
      end
    else
      sanitized = node.is_a?(String) ? Sanitize.clean(node) : node
    end
    sanitized
  end
  
  def sanitize_parameters!
    
    self.each do |key, value|
      # if it’s a hash, we need to check each value inside it…
      # puts "handling #{key} value: #{value}"
      if value.is_a?(Hash)

        value.each do |hash_key, hash_value|
          self[key][hash_key] = sanitize_vals(hash_value)
        end

        # byebug
        # self[key].symbolize_keys!
      elsif value.is_a?(String)
        # puts "#{key} is a String"
        self[key] = Sanitize.clean(value)
      else
        # puts "#{key} nothing"
      end
    end

    self.merge!(self.symbolize_keys) rescue self

  end
      
end
# include the extension 
ActionController::Parameters.send(:include, SanitizeParamsHelper)
